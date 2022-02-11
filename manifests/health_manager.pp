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
# [*port*]
#   (optional) The bind port for the health manager
#   Defaults to $::os_service_default
#
# [*workers*]
#  (optional) The number of workers health_manager spawns
#  Defaults to $::os_workers
#
# [*failover_threads*]
#  (optional) The number of threads performing amphora failovers.
#
# [*heartbeat_timeout*]
#  (optional) Interval, in seconds, to wait before failing over an amphora.
#  Defaults to $::os_service_default
#
# [*health_check_interval*]
#  (optional) Sleep time between health checks in seconds.
#  Defaults to $::os_service_default
#
# [*heartbeat_interval*]
#  (optional) Sleep time between sending heartbeats.
#  Defaults to $::os_service_default
#
# [*sock_rlimit*]
#  (optional) Sets the value of the heartbeat recv buffer
#  Defaults to $::os_service_default
#
class octavia::health_manager (
  $heartbeat_key,
  $manage_service        = true,
  $enabled               = true,
  $package_ensure        = 'present',
  $ip                    = $::os_service_default,
  $port                  = $::os_service_default,
  $workers               = $::os_workers,
  $failover_threads      = $::os_service_default,
  $heartbeat_timeout     = $::os_service_default,
  $health_check_interval = $::os_service_default,
  $heartbeat_interval    = $::os_service_default,
  $sock_rlimit           = $::os_service_default,

) inherits octavia::params {

  include octavia::deps

  validate_legacy(String, 'validate_string', $heartbeat_key)

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
    'health_manager/failover_threads'       : value => $failover_threads;
    'health_manager/heartbeat_timeout'      : value => $heartbeat_timeout;
    'health_manager/health_check_interval'  : value => $health_check_interval;
    'health_manager/heartbeat_interval'     : value => $heartbeat_interval;
    'health_manager/sock_rlimit'            : value => $sock_rlimit;
  }
}
