# Installs and configures the octavia health manager service
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
# [*package_ensure*]
#   (optional) ensure state for package.
#   Defaults to 'present'
#
# [*ip*]
#   (optional) The bind ip for the health manager
#   Defaults to $facts['os_service_default']
#
# [*port*]
#   (optional) The bind port for the health manager
#   Defaults to $facts['os_service_default']
#
# [*health_update_threads*]
#  (optional) Number of processes for amphora health update
#  Defaults to $facts['os_workers']
#
# [*stats_update_threads*]
#  (optional) Number of processes for amphora stats update
#  Defaults to $facts['os_workers']
#
# [*failover_threads*]
#  (optional) The number of threads performing amphora failovers.
#  Defaults to $facts['os_service_default']
#
# [*heartbeat_timeout*]
#  (optional) Interval, in seconds, to wait before failing over an amphora.
#  Defaults to $facts['os_service_default']
#
# [*health_check_interval*]
#  (optional) Sleep time between health checks in seconds.
#  Defaults to $facts['os_service_default']
#
# [*sock_rlimit*]
#  (optional) Sets the value of the heartbeat recv buffer
#  Defaults to $facts['os_service_default']
#
# [*failover_threshold*]
#  (optional) Stop failovers if the count of simultaneously failed amphora
#  reaches this number.
#  Defaults to $facts['os_service_default']
#
class octavia::health_manager (
  Boolean $manage_service                 = true,
  Boolean $enabled                        = true,
  Stdlib::Ensure::Package $package_ensure = 'present',
  $ip                                     = $facts['os_service_default'],
  $port                                   = $facts['os_service_default'],
  $health_update_threads                  = $facts['os_workers'],
  $stats_update_threads                   = $facts['os_workers'],
  $failover_threads                       = $facts['os_service_default'],
  $heartbeat_timeout                      = $facts['os_service_default'],
  $health_check_interval                  = $facts['os_service_default'],
  $sock_rlimit                            = $facts['os_service_default'],
  $failover_threshold                     = $facts['os_service_default'],
) {
  include octavia::deps
  include octavia::params
  include octavia::controller

  package { 'octavia-health-manager':
    ensure => $package_ensure,
    name   => $octavia::params::health_manager_package_name,
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
      name       => $octavia::params::health_manager_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => ['octavia-service'],
    }
  }

  octavia_config {
    'health_manager/bind_ip'                : value => $ip;
    'health_manager/bind_port'              : value => $port;
    'health_manager/health_update_threads'  : value => $health_update_threads;
    'health_manager/stats_update_threads'   : value => $stats_update_threads;
    'health_manager/failover_threads'       : value => $failover_threads;
    'health_manager/heartbeat_timeout'      : value => $heartbeat_timeout;
    'health_manager/health_check_interval'  : value => $health_check_interval;
    'health_manager/sock_rlimit'            : value => $sock_rlimit;
    'health_manager/failover_threshold'     : value => $failover_threshold;
  }
}
