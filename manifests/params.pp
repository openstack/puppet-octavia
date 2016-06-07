# Parameters for puppet-octavia
#
class octavia::params {

  case $::osfamily {
    'RedHat': {
      $common_package_name = 'openstack-octavia-common'
    }
    'Debian': {
      $common_package_name = 'octavia-common'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
