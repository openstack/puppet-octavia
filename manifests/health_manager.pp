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
# [*event_streamer_driver*]
#   (optional) Driver to use for synchronizing octavia and lbaas databases.
#   Defaults to $::os_service_default
#

class octavia::health_manager (
  $heartbeat_key,
  $manage_service          = true,
  $enabled                 = true,
  $package_ensure          = 'present',
  $event_streamer_driver   = $::os_service_default,
) inherits octavia::params {

  validate_string($heartbeat_key)

  Octavia_config<||> ~> Service['octavia-health-manager']
  Package['octavia-health-manager'] -> Service['octavia-health-manager']
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
  }

  service { 'octavia-health-manager':
    ensure     => $service_ensure,
    name       => $::octavia::params::health_manager_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => ['octavia-service'],
  }

  octavia_config {
    'health_manager/heartbeat_key'          : value => $heartbeat_key;
    'health_manager/event_streamer_driver'  : value => $event_streamer_driver,
  }
}
