# == Class: octavia::task_flow
#
# Setup and configure octavia.conf task_flow section.
#
# === Parameters
#
# [*engine*]
#   (optional) TaskFlow engine to use.
#   Defaults to $facts['os_service_default']
#
# [*max_workers*]
#   (optional) The maximum number of workers.
#   Defaults to $facts['os_service_default']
#
# [*disable_revert*]
#   (optional) If True, disable the controller worker taskflow flows from
#   reverting.
#   Defaults to $facts['os_service_default']
#
# [*jobboard_enabled*]
#   (optional) Enable the jobboard feature in taskflow.
#   Defaults to $facts['os_service_default']
#
# [*jobboard_backend_driver*]
#   (optional) Jobboard backend driver that will monitor job state.
#   Defaults to 'redis_taskflow_driver'
#
# [*jobboard_backend_hosts*]
#   (optional) IP addresses of the redis backend for jobboard.
#   Defaults to $facts['os_service_default']
#
# [*jobboard_backend_port*]
#   (optional) The port of jobboard backend server.
#   Defaults to $facts['os_service_default']
#
# [*jobboard_backend_username*]
#   (optional) User name for the jobboard backend server.
#   Defaults to $facts['os_service_default']
#
# [*jobboard_backend_password*]
#   (optional) Password for the jobboard backend server.
#   Defaults to $facts['os_service_default']
#
# [*jobboard_backend_namespace*]
#   (optional) The name used for the job id on the backend server.
#   Defaults to $facts['os_service_default']
#
# [*jobboard_redis_backend_db*]
#   (optional) Database ID in redis server.
#   Defaults to $facts['os_service_default']
#
# [*jobboard_redis_sentinel*]
#   (optional) Sentinel name if it is used for Redis.
#   Defaults to $facts['os_service_default']
#
# [*jobboard_redis_sentinel_username*]
#   (optional) Redis Sentinel server user name.
#   Defaults to $facts['os_service_default']
#
# [*jobboard_redis_sentinel_password*]
#   (optional) Redis Sentinel server password.
#   Defaults to $facts['os_service_default']
#
# [*jobboard_redis_backend_ssl_options*]
#   (optional) Redis jobboard backend ssl configuration options
#   Defaults to $facts['os_service_default']
#
# [*jobboard_redis_sentinel_ssl_options*]
#   (optional) Redis sentinel ssl configuration options
#   Defaults to $facts['os_service_default']
#
# [*jobboard_zookeeper_ssl_options*]
#   (optional) Zookeeper jobboard backend ssl configuration options.
#   Defaults to $facts['os_service_default']
#
# [*jobboard_etcd_ssl_options*]
#   (optional) Etcd jobboard backend ssl configuration options.
#   Defaults to $facts['os_service_default']
#
# [*jobboard_etcd_timeout*]
#   (optional) Timeout when communicating with the Etcd backend.
#   Defaults to $facts['os_service_default']
#
# [*jobboard_etcd_api_path*]
#   (optional) API Path of the Etcd server.
#   Defaults to $facts['os_service_default']
#
# [*jobboard_expiration_time*]
#   (optional) Expiration time in seconds for jobboard tasks.
#   Defaults to $facts['os_service_default']
#
# [*jobboard_save_logbook*]
#   (optional) Save logbook info.
#   Defaults to $facts['os_service_default']
#
# [*persistence_connection*]
#   (optional) Url used to connect to the persistence database.
#   Defaults to $facts['os_service_default']
#
# [*manage_backend_package*]
#   (Optional) Whether to install the backend package.
#   Defaults to true.
#
# [*package_ensure*]
#   (Optional) ensure state for package.
#   Defaults to 'present'
#
class octavia::task_flow (
  $engine                                                 = $facts['os_service_default'],
  $max_workers                                            = $facts['os_service_default'],
  $disable_revert                                         = $facts['os_service_default'],
  $jobboard_enabled                                       = $facts['os_service_default'],
  Octavia::JobboardBackendDriver $jobboard_backend_driver = 'redis_taskflow_driver',
  $jobboard_backend_hosts                                 = $facts['os_service_default'],
  $jobboard_backend_port                                  = $facts['os_service_default'],
  $jobboard_backend_username                              = $facts['os_service_default'],
  $jobboard_backend_password                              = $facts['os_service_default'],
  $jobboard_backend_namespace                             = $facts['os_service_default'],
  $jobboard_redis_backend_db                              = $facts['os_service_default'],
  $jobboard_redis_sentinel                                = $facts['os_service_default'],
  $jobboard_redis_sentinel_username                       = $facts['os_service_default'],
  $jobboard_redis_sentinel_password                       = $facts['os_service_default'],
  $jobboard_redis_backend_ssl_options                     = $facts['os_service_default'],
  $jobboard_redis_sentinel_ssl_options                    = $facts['os_service_default'],
  $jobboard_zookeeper_ssl_options                         = $facts['os_service_default'],
  $jobboard_etcd_ssl_options                              = $facts['os_service_default'],
  $jobboard_etcd_timeout                                  = $facts['os_service_default'],
  $jobboard_etcd_api_path                                 = $facts['os_service_default'],
  $jobboard_expiration_time                               = $facts['os_service_default'],
  $jobboard_save_logbook                                  = $facts['os_service_default'],
  $persistence_connection                                 = $facts['os_service_default'],
  Boolean $manage_backend_package                         = true,
  $package_ensure                                         = 'present',
) {
  include octavia::deps
  include octavia::params

  $jobboard_redis_backend_ssl_options_real = $jobboard_redis_backend_ssl_options ? {
    Hash    => join(join_keys_to_values($jobboard_redis_backend_ssl_options, ':'), ','),
    default => join(any2array($jobboard_redis_backend_ssl_options), ','),
  }
  $jobboard_redis_sentinel_ssl_options_real = $jobboard_redis_sentinel_ssl_options ? {
    Hash    => join(join_keys_to_values($jobboard_redis_sentinel_ssl_options, ':'), ','),
    default => join(any2array($jobboard_redis_sentinel_ssl_options), ','),
  }
  $jobboard_zookeeper_ssl_options_real = $jobboard_zookeeper_ssl_options ? {
    Hash    => join(join_keys_to_values($jobboard_zookeeper_ssl_options, ':'), ','),
    default => join(any2array($jobboard_zookeeper_ssl_options), ','),
  }
  $jobboard_etcd_ssl_options_real = $jobboard_etcd_ssl_options ? {
    Hash    => join(join_keys_to_values($jobboard_etcd_ssl_options, ':'), ','),
    default => join(any2array($jobboard_etcd_ssl_options), ','),
  }

  if $manage_backend_package {
    case $jobboard_backend_driver {
      'zookeeper_taskflow_driver': {
        stdlib::ensure_packages('python-kazoo', {
          name   => $octavia::params::python_kazoo_package_name,
          ensure => $package_ensure,
          tag    => ['openstack'],
        })
        Anchor['octavia::install::begin']
        -> Package['python-kazoo']
        -> Anchor['octavia::install::end']
      }
      'etcd_taskflow_driver': {
        stdlib::ensure_packages('python-etcd3gw', {
          name   => $octavia::params::python_etcd3gw_package_name,
          ensure => $package_ensure,
          tag    => ['openstack'],
        })
        Anchor['octavia::install::begin']
        -> Package['python-etcd3gw']
        -> Anchor['octavia::install::end']
      }
      default: {
        stdlib::ensure_packages('python-redis', {
          name   => $octavia::params::python_redis_package_name,
          ensure => $package_ensure,
          tag    => ['openstack'],
        })
        Anchor['octavia::install::begin']
        -> Package['python-redis']
        -> Anchor['octavia::install::end']
      }
    }
  }

  octavia_config {
    'task_flow/engine'                              : value => $engine;
    'task_flow/max_workers'                         : value => $max_workers;
    'task_flow/disable_revert'                      : value => $disable_revert;
    'task_flow/jobboard_enabled'                    : value => $jobboard_enabled;
    'task_flow/jobboard_backend_driver'             : value => $jobboard_backend_driver;
    'task_flow/jobboard_backend_hosts'              : value => join(any2array($jobboard_backend_hosts), ',');
    'task_flow/jobboard_backend_port'               : value => $jobboard_backend_port;
    'task_flow/jobboard_backend_username'           : value => $jobboard_backend_username;
    'task_flow/jobboard_backend_password'           : value => $jobboard_backend_password, secret => true;
    'task_flow/jobboard_backend_namespace'          : value => $jobboard_backend_namespace;
    'task_flow/jobboard_redis_backend_db'           : value => $jobboard_redis_backend_db;
    'task_flow/jobboard_redis_sentinel'             : value => $jobboard_redis_sentinel;
    'task_flow/jobboard_redis_sentinel_username'    : value => $jobboard_redis_sentinel_username;
    'task_flow/jobboard_redis_sentinel_password'    : value => $jobboard_redis_sentinel_password, secret => true;
    'task_flow/jobboard_redis_backend_ssl_options'  : value => $jobboard_redis_backend_ssl_options_real;
    'task_flow/jobboard_redis_sentinel_ssl_options' : value => $jobboard_redis_sentinel_ssl_options_real;
    'task_flow/jobboard_zookeeper_ssl_options'      : value => $jobboard_zookeeper_ssl_options_real;
    'task_flow/jobboard_etcd_ssl_options'           : value => $jobboard_etcd_ssl_options_real;
    'task_flow/jobboard_etcd_timeout'               : value => $jobboard_etcd_timeout;
    'task_flow/jobboard_etcd_api_path'              : value => $jobboard_etcd_api_path;
    'task_flow/jobboard_expiration_time'            : value => $jobboard_expiration_time;
    'task_flow/jobboard_save_logbook'               : value => $jobboard_save_logbook;
    'task_flow/persistence_connection'              : value => $persistence_connection;
  }
}
