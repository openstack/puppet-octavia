# == Class: octavia::task_flow
#
# Setup and configure octavia.conf task_flow section.
#
# === Parameters
#
# [*engine*]
#   (optional) TaskFlow engine to use.
#   Defaults to $::os_service_default
#
# [*max_workers*]
#   (optional) The maximum number of workers.
#   Defaults to $::os_service_default
#
# [*disable_revert*]
#   (optional) If True, disable the controller worker taskflow flows from
#   reverting.
#   Defaults to $::os_service_default
#
# [*jobboard_enabled*]
#   (optional) Enable the jobboard feature in taskflow.
#   Defaults to $::os_service_default
#
# [*jobboard_backend_driver*]
#   (optional) Jobboard backend driver that will monitor job state.
#   Defaults to $::os_service_default
#
# [*jobboard_backend_hosts*]
#   (optional) IP addresses of the redis backend for jobboard.
#   Defaults to $::os_service_default
#
# [*jobboard_backend_port*]
#   (optional) The port of jobboard backend server.
#   Defaults to $::os_service_default
#
# [*jobboard_backend_password*]
#   (optional) Password for the jobboard backend server.
#   Defaults to $::os_service_default
#
# [*jobboard_backend_namespace*]
#   (optional) The name used for the job id on the backend server.
#   Defaults to $::os_service_default
#
# [*jobboard_redis_sentinel*]
#   (optional) Sentinel name if it is used for Redis.
#   Defaults to $::os_service_default
#
# [*jobboard_redis_backend_ssl_options*]
#   (optional) Redis jobboard backend ssl configuration options
#   Defaults to $::os_service_default
#
# [*jobboard_zookeeper_ssl_options*]
#   (optional) Zookeeper jobboard backend ssl configuration options.
#   Defaults to $::os_service_default
#
# [*jobboard_expiration_time*]
#   (optional) Expiration time in seconds for jobboard tasks.
#   Defaults to $::os_service_default
#
# [*jobboard_save_logbook*]
#   (optional) Save logbook info.
#   Defaults to $::os_service_default
#
# [*persistence_connection*]
#   (optional) Url used to connect to the persistence database.
#   Defaults to $::os_service_default
#
class octavia::task_flow (
  $engine                             = $::os_service_default,
  $max_workers                        = $::os_service_default,
  $disable_revert                     = $::os_service_default,
  $jobboard_enabled                   = $::os_service_default,
  $jobboard_backend_driver            = $::os_service_default,
  $jobboard_backend_hosts             = $::os_service_default,
  $jobboard_backend_port              = $::os_service_default,
  $jobboard_backend_password          = $::os_service_default,
  $jobboard_backend_namespace         = $::os_service_default,
  $jobboard_redis_sentinel            = $::os_service_default,
  $jobboard_redis_backend_ssl_options = $::os_service_default,
  $jobboard_zookeeper_ssl_options     = $::os_service_default,
  $jobboard_expiration_time           = $::os_service_default,
  $jobboard_save_logbook              = $::os_service_default,
  $persistence_connection             = $::os_service_default,
) {

  include octavia::deps

  octavia_config {
    'task_flow/engine'                             : value => $engine;
    'task_flow/max_workers'                        : value => $max_workers;
    'task_flow/disable_revert'                     : value => $disable_revert;
    'task_flow/jobboard_enabled'                   : value => $jobboard_enabled;
    'task_flow/jobboard_backend_driver'            : value => $jobboard_backend_driver;
    'task_flow/jobboard_backend_hosts'             : value => join(any2array($jobboard_backend_hosts), ',');
    'task_flow/jobboard_backend_port'              : value => $jobboard_backend_port;
    'task_flow/jobboard_backend_password'          : value => $jobboard_backend_password, secret => true;
    'task_flow/jobboard_backend_namespace'         : value => $jobboard_backend_namespace;
    'task_flow/jobboard_redis_sentinel'            : value => $jobboard_redis_sentinel;
    'task_flow/jobboard_redis_backend_ssl_options' : value => join(any2array($jobboard_redis_backend_ssl_options), ',');
    'task_flow/jobboard_zookeeper_ssl_options'     : value => join(any2array($jobboard_zookeeper_ssl_options), ',');
    'task_flow/jobboard_expiration_time'           : value => $jobboard_expiration_time;
    'task_flow/jobboard_save_logbook'              : value => $jobboard_save_logbook;
    'task_flow/persistence_connection'             : value => $persistence_connection;
  }
}
