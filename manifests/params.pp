# Parameters for puppet-octavia
#
class octavia::params {
  include openstacklib::defaults

  $pyver3 = $openstacklib::defaults::pyver3

  $api_service_name            = 'octavia-api'
  $worker_service_name         = 'octavia-worker'
  $health_manager_service_name = 'octavia-health-manager'
  $housekeeping_service_name   = 'octavia-housekeeping'
  $driver_agent_service_name   = 'octavia-driver-agent'
  $client_package_name         = 'python3-octaviaclient'
  $ovn_provider_package_name   = 'python3-ovn-octavia-provider'
  $user                        = 'octavia'
  $group                       = 'octavia'

  case $facts['os']['family'] {
    'RedHat': {
      $common_package_name         = 'openstack-octavia-common'
      $api_package_name            = 'openstack-octavia-api'
      $worker_package_name         = 'openstack-octavia-worker'
      $health_manager_package_name = 'openstack-octavia-health-manager'
      $housekeeping_package_name   = 'openstack-octavia-housekeeping'
      $driver_agent_package_name   = 'openstack-octavia-driver-agent'
      $octavia_wsgi_script_path    = '/var/www/cgi-bin/octavia'
      $octavia_wsgi_script_source  = "/usr/lib/python${pyver3}/site-packages/octavia/wsgi/api.py"
      $python_redis_package_name   = 'python3-redis'
      $python_kazoo_package_name   = 'python3-kazoo'
      $python_etcd3gw_package_name = 'python3-etcd3gw'
    }
    'Debian': {
      $common_package_name         = 'octavia-common'
      $api_package_name            = 'octavia-api'
      $worker_package_name         = 'octavia-worker'
      $health_manager_package_name = 'octavia-health-manager'
      $housekeeping_package_name   = 'octavia-housekeeping'
      $driver_agent_package_name   = 'octavia-driver-agent'
      $octavia_wsgi_script_path    = '/usr/lib/cgi-bin/octavia'
      $octavia_wsgi_script_source  = '/usr/bin/octavia-wsgi'
      $python_redis_package_name   = 'python3-redis'
      $python_kazoo_package_name   = 'python3-kazoo'
      $python_etcd3gw_package_name = 'python3-etcd3gw'
    }
    default: {
      fail("Unsupported osfamily: ${facts['os']['family']}")
    }
  } # Case $facts['os']['family']
}
