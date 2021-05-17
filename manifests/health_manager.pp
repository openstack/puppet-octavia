# Installs and configures the octavia health manager service
#
# == Parameters
#
# [*heartbeat_key*]
#   Key to validate amphora messages.
#
# [*enabled*]
#   (optional) Should the service be enabled.
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*package_ensure*]
#   (optional) ensure state for package.
#   Defaults to 'present'
#
# [*ip*]
#   (optional) The bind ip for the health manager
#   Defaults to $::os_service_default
#
# [*workers*]
#  (optional) The number of workers health_manager spawns
#  Defaults to $::os_workers
#
# [*port*]
#   (optional) The bind port for the health manager
#   Defaults to $::os_service_default
#
# DEPRECATED PARAMETERS
#
# [*event_streamer_driver*]
#   (optional) Driver to use for synchronizing octavia and lbaas databases.
#   Defaults to $::os_service_default
#
class octavia::health_manager (
  $heartbeat_key,
  $manage_service        = true,
  $enabled               = true,
  $package_ensure        = 'present',
  $ip                    = $::os_service_default,
  $port                  = $::os_service_default,
  $workers               = $::os_workers,
  # DEPRECATED PARAMETERS
  $event_streamer_driver = undef,

) inherits octavia::params {

  include octavia::deps

  validate_legacy(String, 'validate_string', $heartbeat_key)

  if $event_streamer_driver {
      warning('The event_streamer_driver parameter is deprecated as result of neutron-lbaas retirement.')
  }

  package { 'octavia-health-manager':
    ensure => $package_ensure,
    name   => $::octavia::params::health_manager_package_name,
    tag    => ['openstack', 'octavia-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    service { 'octavia-health-manager':
      ensure     => $service_ensure,
      name       => $::octavia::params::health_manager_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => ['octavia-service'],
    }
  }

  octavia_config {
    'health_manager/heartbeat_key'          : value => $heartbeat_key;
    'health_manager/bind_ip'                : value => $ip;
    'health_manager/bind_port'              : value => $port;
    'health_manager/health_update_threads'  : value => $workers;
    'health_manager/stats_update_threads'   : value => $workers;
  }
}
