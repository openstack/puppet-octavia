# Parameters for puppet-octavia
#
class octavia::params {

  $api_service_name = 'octavia-api'
  case $::osfamily {
    'RedHat': {
      $common_package_name = 'openstack-octavia-common'
      $api_package_name    = 'openstack-octavia-api'
    }
    'Debian': {
      $common_package_name = 'octavia-common'
      $api_package_name    = 'octavia-api'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
