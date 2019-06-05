# Configures the octavia driver agent
#
# == Parameters
#
# [*status_socket_path*]
#   (optional) Path to the driver status unix domain socket file.
#   Defaults to $::os_service_default
#
# [*stats_socket_path*]
#   (optional) Path to the driver statistics unix domain socket file.
#   Defaults to $::os_service_default
#
# [*get_socket_path*]
#   (optional) Path to the driver get unix domain socket file.
#   Defaults to $::os_service_default
#
# [*status_request_timeout*]
#   (optional) Time, in seconds, to wait for a status update request.
#   Defaults to $::os_service_default
#
# [*status_max_processes*]
#   (optional) Maximum number of concurrent processes to use servicing status
#   updates.
#   Defaults to $::os_service_default
#
# [*stats_request_timeout*]
#   (optional) Time, in seconds, to wait for a statistics update request.
#   Defaults to $::os_service_default
#
# [*stats_max_processes*]
#   (optional) Maximum number of concurrent processes to use servicing
#   statistics updates.
#   Defaults to $::os_service_default
#
# [*get_request_timeout*]
#   (optional) Time, in seconds, to wait for a get request.
#   Defaults to $::os_service_default
#
# [*get_max_processes*]
#   (optional) Maximum number of concurrent processes to use servicing get
#   requests.
#   Defaults to $::os_service_default
#
# [*max_process_warning_percent*]
#   (optional) Percentage of max_processes (both status and stats) in use to
#   start logging warning messages about an overloaded driver-agent.
#   Defaults to $::os_service_default
#
# [*provider_agent_shutdown_timeout*]
#   (optional) The time, in seconds, to wait for provider agents to shutdown
#   after the exit event has been set.
#   Defaults to $::os_service_default
#
# [*enabled_provider_agents*]
#   (optional) List of enabled provider agents. The driver-agent will launch
#   these agents at startup.
#   Defaults to $::os_service_default
#
class octavia::driver_agent (
  $status_socket_path              = $::os_service_default,
  $stats_socket_path               = $::os_service_default,
  $get_socket_path                 = $::os_service_default,
  $status_request_timeout          = $::os_service_default,
  $status_max_processes            = $::os_service_default,
  $stats_request_timeout           = $::os_service_default,
  $stats_max_processes             = $::os_service_default,
  $get_request_timeout             = $::os_service_default,
  $get_max_processes               = $::os_service_default,
  $max_process_warning_percent     = $::os_service_default,
  $provider_agent_shutdown_timeout = $::os_service_default,
  $enabled_provider_agents         = $::os_service_default,
) inherits octavia::params {

  include ::octavia::deps

  # Octavia packaging does not currently provide a separate agent service or package.

  octavia_config {
    'driver_agent/status_socket_path':              value => $status_socket_path;
    'driver_agent/stats_socket_path':               value => $stats_socket_path;
    'driver_agent/get_socket_path':                 value => $get_socket_path;
    'driver_agent/status_request_timeout':          value => $status_request_timeout;
    'driver_agent/status_max_processes':            value => $status_max_processes;
    'driver_agent/stats_request_timeout':           value => $stats_request_timeout;
    'driver_agent/stats_max_processes':             value => $stats_max_processes;
    'driver_agent/get_request_timeout':             value => $get_request_timeout;
    'driver_agent/get_max_processes':               value => $get_max_processes;
    'driver_agent/max_process_warning_percent':     value => $max_process_warning_percent;
    'driver_agent/provider_agent_shutdown_timeout': value => $provider_agent_shutdown_timeout;
    'driver_agent/enabled_provider_agents':         value => $enabled_provider_agents;
  }
}
