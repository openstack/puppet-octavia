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
#   Defaults to $facts['os_service_default']
#
# [*api_v1_enabled*]
#   (optional) Boolean if V1 API should be enabled.
#   Defaults to $facts['os_service_default']
#
# [*api_v2_enabled*]
#   (optional) Boolean if V2 API should be enabled.
#   Defaults to $facts['os_service_default']
#
# [*allow_tls_terminated_listeners*]
#   (optional) Boolean if we allow creation of TLS terminated listeners.
#   Defaults to $facts['os_service_default']
#
# [*sync_db*]
#   (optional) Run octavia-db-manage upgrade head on api nodes after installing the package.
#   Defaults to false
#
# [*enable_proxy_headers_parsing*]
#   (Optional) Enable paste middleware to handle SSL requests through
#   HTTPProxyToWSGI middleware.
#   Defaults to $facts['os_service_default'].
#
# [*max_request_body_size*]
#   (Optional) Set max request body size
#   Defaults to $facts['os_service_default'].
#
# [*default_provider_driver*]
#   (optional) Configure the default provider driver.
#   Defaults to $facts['os_service_default']
#
# [*enabled_provider_drivers*]
#   (optional) Configure the loadbalancer provider drivers.
#   Defaults to $facts['os_service_default']
#
# [*pagination_max_limit*]
#   (optional) The maximum number of items returned in a single response.
#   Defaults to $facts['os_service_default']
#
# [*healthcheck_enabled*]
#   (optional) Enable the oslo middleware healthcheck endpoint.
#   Defaults to $facts['os_service_default']
#
# [*healthcheck_refresh_interval*]
#   (optional) The interval healthcheck plugin should cache results, in seconds.
#   Defaults to $facts['os_service_default']
#
# [*default_listener_ciphers*]
#   (optional) Default OpenSSL cipher string (colon-separated) for new
#   TLS-enabled pools.
#   Defaults to $facts['os_service_default']
#
# [*default_pool_ciphers*]
#   (optional) Default OpenSSL cipher string (colon-separated) for new
#   TLS-enabled pools.
#   Defaults to $facts['os_service_default']
#
# [*tls_cipher_prohibit_list*]
#   (optional) Colon separated list of OpenSSL ciphers. Usage of these ciphers
#   will be blocked.
#   Defaults to $facts['os_service_default']
#
# [*default_listener_tls_versions*]
#   (optional) List of TLS versions to use for new TLS-enabled listeners.
#   Defaults to $facts['os_service_default']
#
# [*default_pool_tls_versions*]
#   (optional) List of TLS versions to use for new TLS-enabled pools.
#   Defaults to $facts['os_service_default']
#
# [*minimum_tls_version*]
#   (optional) Minimum allowed TLS version for listeners and pools.
#   Defaults to $facts['os_service_default']
#
# [*allow_ping_health_monitors*]
#   (optional) Allow PING type Health Monitors.
#   Defaults to $facts['os_service_default']
#
# [*allow_prometheus_listeners*]
#   (optional) Allow PROMETHEUS type listeners.
#   Defaults to $facts['os_service_default']
#
class octavia::api (
  Boolean $enabled                = true,
  Boolean $manage_service         = true,
  $service_name                   = $::octavia::params::api_service_name,
  $host                           = '0.0.0.0',
  $port                           = '9876',
  $package_ensure                 = 'present',
  $auth_strategy                  = 'keystone',
  $api_handler                    = $facts['os_service_default'],
  $api_v1_enabled                 = $facts['os_service_default'],
  $api_v2_enabled                 = $facts['os_service_default'],
  $allow_tls_terminated_listeners = $facts['os_service_default'],
  Boolean $sync_db                = false,
  $enable_proxy_headers_parsing   = $facts['os_service_default'],
  $max_request_body_size          = $facts['os_service_default'],
  $default_provider_driver        = $facts['os_service_default'],
  $enabled_provider_drivers       = $facts['os_service_default'],
  $pagination_max_limit           = $facts['os_service_default'],
  $healthcheck_enabled            = $facts['os_service_default'],
  $healthcheck_refresh_interval   = $facts['os_service_default'],
  $default_listener_ciphers       = $facts['os_service_default'],
  $default_pool_ciphers           = $facts['os_service_default'],
  $tls_cipher_prohibit_list       = $facts['os_service_default'],
  $default_listener_tls_versions  = $facts['os_service_default'],
  $default_pool_tls_versions      = $facts['os_service_default'],
  $minimum_tls_version            = $facts['os_service_default'],
  $allow_ping_health_monitors     = $facts['os_service_default'],
  $allow_prometheus_listeners     = $facts['os_service_default'],
) inherits octavia::params {

  include octavia::deps
  include octavia::policy
  include octavia::db

  if $auth_strategy == 'keystone' {
    include octavia::keystone::authtoken
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
        tag        => 'octavia-service',
      }

      # On any uwsgi config change, we must restart Octavia API.
      Octavia_api_uwsgi_config<||> ~> Service['octavia-api']

    } elsif $service_name == 'httpd' {
      service { 'octavia-api':
        ensure => 'stopped',
        name   => $::octavia::params::api_service_name,
        enable => false,
        tag    => 'octavia-service',
      }
      Service['octavia-api'] -> Service[$service_name]
      Service<| title == 'httpd' |> { tag +> 'octavia-service' }
    } else {
    fail("Invalid service_name. Either octavia-api/openstack-octavia-api for \
running as a standalone service, or httpd for being run by a httpd server")
    }
  }

  if $sync_db {
    include octavia::db::sync
  }

  if $enabled_provider_drivers =~ Hash {
    $enabled_provider_drivers_real = join(join_keys_to_values($enabled_provider_drivers, ':'), ',')
  } else {
    $enabled_provider_drivers_real = join(any2array($enabled_provider_drivers), ',')
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
    'api_settings/enabled_provider_drivers':       value => $enabled_provider_drivers_real;
    'api_settings/pagination_max_limit':           value => $pagination_max_limit;
    'api_settings/healthcheck_enabled':            value => $healthcheck_enabled;
    'api_settings/healthcheck_refresh_interval':   value => $healthcheck_refresh_interval;
    'api_settings/default_listener_ciphers':       value => join(any2array($default_listener_ciphers), ':');
    'api_settings/default_pool_ciphers':           value => join(any2array($default_pool_ciphers), ':');
    'api_settings/tls_cipher_prohibit_list':       value => join(any2array($tls_cipher_prohibit_list), ':');
    'api_settings/default_listener_tls_versions':  value => join(any2array($default_listener_tls_versions), ',');
    'api_settings/default_pool_tls_versions':      value => join(any2array($default_pool_tls_versions), ',');
    'api_settings/minimum_tls_version':            value => $minimum_tls_version;
    'api_settings/allow_ping_health_monitors':     value => $allow_ping_health_monitors;
    'api_settings/allow_prometheus_listeners':     value => $allow_prometheus_listeners;
  }

  oslo::middleware { 'octavia_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
    max_request_body_size        => $max_request_body_size,
  }
}
