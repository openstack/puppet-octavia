# == Class: octavia::client
#
# Installs the octavia python library.
#
# === Parameters
#
# [*ensure*]
#   (Optional) Ensure state for package.
#
class octavia::client (
  Stdlib::Ensure::Package $ensure = 'present',
) {
  include octavia::deps
  include octavia::params

  package { 'python-octaviaclient':
    ensure => $ensure,
    name   => $octavia::params::client_package_name,
    tag    => ['openstack', 'openstackclient'],
  }
  include openstacklib::openstackclient
}
