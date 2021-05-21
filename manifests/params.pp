# Parameters for puppet-octavia
#
class octavia::params {
  include openstacklib::defaults

  $api_service_name            = 'octavia-api'
  $worker_service_name         = 'octavia-worker'
  $health_manager_service_name = 'octavia-health-manager'
  $housekeeping_service_name   = 'octavia-housekeeping'
  $client_package_name         = 'python3-octaviaclient'
  $group                       = 'octavia'

  case $::osfamily {
    'RedHat': {
      $common_package_name         = 'openstack-octavia-common'
      $api_package_name            = 'openstack-octavia-api'
      $worker_package_name         = 'openstack-octavia-worker'
      $health_manager_package_name = 'openstack-octavia-health-manager'
      $housekeeping_package_name   = 'openstack-octavia-housekeeping'
      $octavia_wsgi_script_path    = '/var/www/cgi-bin/octavia'
      $octavia_wsgi_script_source  = '/usr/bin/octavia-wsgi'
    }
    'Debian': {
      $common_package_name         = 'octavia-common'
      $api_package_name            = 'octavia-api'
      $worker_package_name         = 'octavia-worker'
      $health_manager_package_name = 'octavia-health-manager'
      $housekeeping_package_name   = 'octavia-housekeeping'
      $octavia_wsgi_script_path    = '/usr/lib/cgi-bin/octavia'
      $octavia_wsgi_script_source  = '/usr/bin/octavia-wsgi'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, \
module ${module_name} only support osfamily RedHat and Debian")
    }

  } # Case $::osfamily
}
