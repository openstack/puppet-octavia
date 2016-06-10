# Parameters for puppet-octavia
#
class octavia::params {
  include ::openstacklib::defaults

  $api_service_name    = 'octavia-api'
  $worker_service_name = 'octavia-worker'
  case $::osfamily {
    'RedHat': {
      $common_package_name = 'openstack-octavia-common'
      $api_package_name    = 'openstack-octavia-api'
      $worker_package_name = 'openstack-octavia-worker'
    }
    'Debian': {
      $common_package_name = 'octavia-common'
      $api_package_name    = 'octavia-api'
      $worker_package_name = 'octavia-worker'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
