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
  $ensure = 'present'
) {

  include octavia::deps
  include octavia::params

  package { 'python-octaviaclient':
    ensure => $ensure,
    name   => $::octavia::params::client_package_name,
    tag    => 'openstack',
  }
  include openstacklib::openstackclient
}
