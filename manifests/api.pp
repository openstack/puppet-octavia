# Installs & configure the octavia service
#
# == Parameters
#
# [*enabled*]
#   (optional) Should the service be enabled.
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*service_name*]
#   (Optional) Name of the service that will be providing the
#   server functionality of octavia-api.
#   If the value is 'httpd', this means octavia-api will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'octavia::wsgi::apache'...}
#   to make octavia-api be a web app using apache mod_wsgi.
#   Defaults to $::octavia::params::api_service_name
#
# [*host*]
#   (optional) The octavia api bind address.
#   Defaults to '0.0.0.0'
#
# [*port*]
#   (optional) The octavia api port.
#   Defaults to '9876'
#
# [*package_ensure*]
#   (optional) ensure state for package.
#   Defaults to 'present'
#
# [*auth_strategy*]
#   (optional) set authentication mechanism
#   Defaults to 'keystone'
#
# [*api_handler*]
#   (optional) The handler that the API communicates with
#   Defaults to $::os_service_default
#
# [*api_v1_enabled*]
#   (optional) Boolean if V1 API should be enabled.
#   Defaults to $::os_service_default
#
# [*api_v2_enabled*]
#   (optional) Boolean if V2 API should be enabled.
#   Defaults to $::os_service_default
#
# [*allow_tls_terminated_listeners*]
#   (optional) Boolean if we allow creation of TLS terminated listeners.
#   Defaults to $::os_service_default
#
# [*sync_db*]
#   (optional) Run octavia-db-manage upgrade head on api nodes after installing the package.
#   Defaults to false
#
# [*enable_proxy_headers_parsing*]
#   (Optional) Enable paste middleware to handle SSL requests through
#   HTTPProxyToWSGI middleware.
#   Defaults to $::os_service_default.
#
# [*default_provider_driver*]
#   (optional) Configure the default provider driver.
#   Defaults to $::os_service_default
#
# [*provider_drivers*]
#   (optional) Configure the loadbalancer provider drivers.
#   Defaults to $::os_service_default
#
# [*pagination_max_limit*]
#   (optional) The maximum number of items returned in a single response.
#   Defaults to $::os_service_default
#
# [*healthcheck_enabled*]
#   (optional) Enable the oslo middleware healthcheck endppint.
#   Defaults to $::os_service_default
#
# [*healthcheck_refresh_interval*]
#   (optional) The interval healthcheck plugin should cache results, in seconds.
#   Defaults to $::os_service_default
#
# DEPRECATED PARAMETERS
#
# [*ovn_nb_connection*]
#   (optional) The connection string for the OVN_Northbound OVSDB.
#   Defaults to undef
#
class octavia::api (
  $enabled                        = true,
  $manage_service                 = true,
  $service_name                   = $::octavia::params::api_service_name,
  $host                           = '0.0.0.0',
  $port                           = '9876',
  $package_ensure                 = 'present',
  $auth_strategy                  = 'keystone',
  $api_handler                    = $::os_service_default,
  $api_v1_enabled                 = $::os_service_default,
  $api_v2_enabled                 = $::os_service_default,
  $allow_tls_terminated_listeners = $::os_service_default,
  $sync_db                        = false,
  $enable_proxy_headers_parsing   = $::os_service_default,
  $default_provider_driver        = $::os_service_default,
  $provider_drivers               = $::os_service_default,
  $pagination_max_limit           = $::os_service_default,
  $healthcheck_enabled            = $::os_service_default,
  $healthcheck_refresh_interval   = $::os_service_default,
  # DEPRECATED PARAMETERS
  $ovn_nb_connection              = undef
) inherits octavia::params {

  include octavia::deps
  include octavia::policy
  include octavia::db

  if $auth_strategy == 'keystone' {
    include octavia::keystone::authtoken
  }

  if $ovn_nb_connection {
      warning('The ovn_nb_connection parameter is deprecated from octavia::api. Use octavia::provider::ovn::ovn_nb_connection.')
  }

  package { 'octavia-api':
    ensure => $package_ensure,
    name   => $::octavia::params::api_package_name,
    tag    => ['openstack', 'octavia-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    if $service_name == $::octavia::params::api_service_name {
      service { 'octavia-api':
        ensure     => $service_ensure,
        name       => $::octavia::params::api_service_name,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
        tag        => ['octavia-service', 'octavia-db-sync-service'],
      }
    } elsif $service_name == 'httpd' {
      include apache::params
      service { 'octavia-api':
        ensure => 'stopped',
        name   => $::octavia::params::api_service_name,
        enable => false,
        tag    => ['octavia-service', 'octavia-db-sync-service'],
      }
      Service['octavia-api'] -> Service[$service_name]
      Service<| title == 'httpd' |> { tag +> ['octavia-service', 'octavia-db-sync-service'] }
    }
  }

  if $sync_db {
    include octavia::db::sync
  }

  octavia_config {
    'api_settings/bind_host':                      value => $host;
    'api_settings/bind_port':                      value => $port;
    'api_settings/auth_strategy':                  value => $auth_strategy;
    'api_settings/api_handler':                    value => $api_handler;
    'api_settings/api_v1_enabled':                 value => $api_v1_enabled;
    'api_settings/api_v2_enabled':                 value => $api_v2_enabled;
    'api_settings/allow_tls_terminated_listeners': value => $allow_tls_terminated_listeners;
    'api_settings/default_provider_driver':        value => $default_provider_driver;
    'api_settings/enabled_provider_drivers':       value => $provider_drivers;
    'api_settings/pagination_max_limit':           value => $pagination_max_limit;
    'api_settings/healthcheck_enabled':            value => $healthcheck_enabled;
    'api_settings/healthcheck_refresh_interval':   value => $healthcheck_refresh_interval;
  }

  oslo::middleware { 'octavia_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing
  }
}
