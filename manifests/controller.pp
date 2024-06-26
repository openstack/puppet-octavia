# == Class: octavia::controller
#
# === Parameters
#
# [*heartbeat_key*]
#   (required) Key to validate amphora messages.
#
# [*amp_active_retries*]
#   (optional) Retry attempts to wait for Amphora to become active.
#   Defaults to $facts['os_service_default']
#
# [*amp_active_wait_sec*]
#   (optional) Seconds to wait between checks on whether an Amphora has
#   become active.
#   Defaults to $facts['os_service_default']
#
# [*amp_flavor_id*]
#   (optional) Nova instance flavor id for the Amphora.
#   Note: since we set manage_nova_flavor to True by default, we need
#   to set a valid amp_flavor_id by default, 65 was picked randomly.
#   Defaults to '65'.
#
# [*amp_image_tag*]
#   Glance image tag for Amphora image. Allows the Amphora image to be
#   referred to by a tag instead of an ID, allowing the Amphora image to
#   be updated without requiring reconfiguration of Octavia.
#   Defaults to $facts['os_service_default']
#
# [*amp_image_owner_id*]
#   Restrict glance image selection to a specific owner ID.  This is a
#   recommended security setting.
#   Defaults to $facts['os_service_default']
#
# [*amp_secgroup_list*]
#   List of security groups to use for Amphorae.
#   Defaults to $facts['os_service_default']
#
# [*amp_boot_network_list*]
#   List of networks to attach to Amphorae.
#   Defaults to $facts['os_service_default']
#
# [*loadbalancer_topology*]
#   (optional) Load balancer topology configuration
#   Defaults to $facts['os_service_default']
#
# [*amphora_driver*]
#   (optional) Name of driver for communicating with amphorae
#   Defaults to $facts['os_service_default']
#
# [*compute_driver*]
#   (optional) Name of driver for managing amphorae VMs
#   Defaults to $facts['os_service_default']
#
# [*network_driver*]
#   (optional) Name of network driver for configuring networking
#   for amphorae.
#   Defaults to $facts['os_service_default']
#
# [*volume_driver*]
#   (optional) Name of volume driver for managing amphora volumes
#   Defaults to $facts['os_service_default']
#
# [*image_driver*]
#   (optional) Name of volume driver for managing amphora image
#   Defaults to $facts['os_service_default']
#
# [*amp_timezone*]
#   (optional) Defines the timezone to use as represented in
#   /usr/share/zoneinfo.
#   Defaults to $facts['os_service_default']
#
# [*amphora_delete_retries*]
#   (optional) Number of times an amphora delete should be retried.
#   Defaults to $facts['os_service_default']
#
# [*amphora_delete_retry_interval*]
#   (optional) Time, in seconds, between amphora delete retries.
#   Defaults to $facts['os_service_default']
#
# [*event_notifications*]
#   (optional) Enable octavia event notifications.
#   Defaults to $facts['os_service_default']
#
# [*db_commit_retry_attempts*]
#   (optional) The number of times the database action will be attempted.
#   Defaults to $facts['os_service_default']
#
# [*db_commit_retry_initial_delay*]
#   (optional) The time to backoff retry attempt.
#   Defaults to $facts['os_service_default']
#
# [*db_commit_retry_backoff*]
#   (optional) Tie time to backoff retry attempts.
#   Defaults to $facts['os_service_default']
#
# [*db_commit_retry_max*]
#   (optional) The maximum amount of time to wait between retry attempts.
#   Defaults to $facts['os_service_default']
#
# [*amp_ssh_key_name*]
#   (optional) Name of Openstack SSH keypair for communicating with amphora
#   Defaults to 'octavia-ssh-key'
#
# [*enable_ssh_access*]
#   (optional) Enable SSH key configuration for amphorae. Note that setting
#   to false disables configuration of SSH key related properties.
#   Defaults to true
#
# [*timeout_client_data*]
#   (optional) Frontend client inactivity timeout.
#   Defaults to $facts['os_service_default']
#
# [*timeout_member_connect*]
#   (optional) Backend member connection timeout.
#   Defaults to $facts['os_service_default']
#
# [*timeout_member_data*]
#   (optional) Backend member inactivity timeout.'
#   Defaults to $facts['os_service_default']
#
# [*timeout_tcp_inspect*]
#   (optional) Time to wait for TCP packets for content inspection.
#   Defaults to $facts['os_service_default']
#
# [*connection_max_retries*]
#   (optional) Maximum number of retries when contacting amphora.
#   Defaults to $facts['os_service_default']
#
# [*connection_retry_interval*]
#   (optional) Number of seconds to wait between connection attempts to amphora.
#   Defaults to $facts['os_service_default']
#
# [*active_connection_max_retries*]
#   (optional) Retry threshold for connecting to active amphorae.
#   Defaults to $facts['os_service_default']
#
# [*active_connection_retry_interval*]
#   (optional) Retry timeout between connection attempts in seconds for active
#   amphora.
#   Defaults to $facts['os_service_default']
#
# [*failover_connection_max_retries*]
#   (optional) Retry threshold for connecting to an amphora in failover.
#   Defaults to $facts['os_service_default']
#
# [*failover_connection_retry_interval*]
#   (optional) Retry timeout between connection attempts in seconds for amphora
#   in failover.
#   Defaults to $facts['os_service_default']
#
# [*connection_logging*]
#   (optional) When false, disables logging of tenant connection flows. This
#   includes storing them locally and sending them to the tenant syslog
#   endpoints.
#   Defaults to $facts['os_service_default']
#
# [*build_rate_limit*]
#   (optional) Number of amphorae that could be build per controller worker,
#   simultaneously.
#   Defaults to $facts['os_service_default']
#
# [*build_active_retries*]
#   (optional) Retry threshold for waiting for a build slot for an amphorae.
#   Defaults to $facts['os_service_default']
#
# [*build_retry_interval*]
#   (optional) Retry timeout between build attempts in seconds.
#   Defaults to $facts['os_service_default']
#
# [*api_db_commit_retry_attempts*]
#   (optional) The number of times the database action will be attempted.
#   Defaults to $facts['os_service_default']
#
# [*api_db_commit_retry_initial_delay*]
#   (optional) The time to backoff retry attempt.
#   Defaults to $facts['os_service_default']
#
# [*api_db_commit_retry_backoff*]
#   (optional) Tie time to backoff retry attempts.
#   Defaults to $facts['os_service_default']
#
# [*api_db_commit_retry_max*]
#   (optional) The maximum amount of time to wait between retry attempts.
#   Defaults to $facts['os_service_default']
#
# [*default_connection_limit*]
#   (optional) Default connection_limit for listeners.
#   Defaults to $facts['os_service_default']
#
# [*agent_request_read_timeout*]
#   (optional) The time in seconds to allow a request from the controller to
#   run before terminating the socket.
#   Defaults to $facts['os_service_default']
#
# [*agent_tls_protocol*]
#   (optional) Minimum TLS protocol for communication with the amphora agent.
#   Defaults to $facts['os_service_default']
#
# [*admin_log_targets*]
#   (optional) The list of syslog endpoints, host:port comma separated list,
#   to receive administrative log messages.
#   Defaults to $facts['os_service_default']
#
# [*administrative_log_facility*]
#   (optional) The syslog "LOG_LOCAL" facility to use for the administrative
#   log messages.
#   Defaults to $facts['os_service_default']
#
# [*forward_all_logs*]
#   (optional) When true, all log messages from the amphora will be forwarded
#   to the administrative log endpoints, including non-load balancing related
#   logs.
#   Defaults to $facts['os_service_default']
#
# [*tenant_log_targets*]
#   (optional) The list of syslog endpoints, host:port comma separated list,
#   to receive tenant traffic flow log messages.
#   Defaults to $facts['os_service_default']
#
# [*user_log_facility*]
#   (optional) The syslog "LOG_LOCAL" facility to use for the tenant traffic
#   flow log messages.
#   Defaults to $facts['os_service_default']
#
# [*user_log_format*]
#   (optional) The tenant traffic flow log format string.
#   Defaults to $facts['os_service_default']
#
# [*log_protocol*]
#   (optional) The log forwarding transport protoocl. One of UDP or TCP.
#   Defaults to $facts['os_service_default']
#
# [*log_retry_count*]
#   (optional) The maximum attempts to retry connecting to the logging host.
#   Defaults to $facts['os_service_default']
#
# [*log_retry_interval*]
#   (optional) The time, in seconds, to wait between retries connecting to
#   the logging host.
#   Defaults to $facts['os_service_default']
#
# [*log_queue_size*]
#   (optional) The queue size (messages) to buffer log messages.
#   Defaults to $facts['os_service_default']
#
# [*logging_template_override*]
#   (optional) Custom logging configuration template.
#   Defaults to $facts['os_service_default']
#
# [*disable_local_log_storage*]
#   (optional) When true, logs will not be stored on the amphora filesystem.
#   This includes all kernel, system, and security logs.
#   Defaults to $facts['os_service_default']
#
# [*vrrp_advert_int*]
#   (optional) Amphora role and priority advertisement internal in seconds.
#   Defaults to $facts['os_service_default']
#
# [*vrrp_check_interval*]
#   (optional) VRRP health check script run interval in seconds.
#   Defaults to $facts['os_service_default']
#
# [*vrrp_fail_count*]
#   (optional) Number of successive failures before transition to a fail rate.
#   Defaults to $facts['os_service_default']
#
# [*vrrp_success_count*]
#   (optional) Number of consecutive successes before transition to a success rate.
#   Defaults to $facts['os_service_default']
#
# [*vrrp_garp_refresh_interval*]
#   (optional) Time in seconds between gratuitous ARP announcements from the MASTER.
#   Defaults to $facts['os_service_default']
#
# [*vrrp_garp_refresh_count*]
#   (optional) Number of gratuitous ARP announcements to make on each refresh interval.
#   Defaults to $facts['os_service_default']
#
# [*controller_ip_port_list*]
#   (optional) The list of controllers in a host:port comma separated
#   list if multiple. This is added to the amphora config and is used
#   when it connects back to the controllers to report its health.
#   Defaults to $facts['os_service_default']
#
# [*heartbeat_interval*]
#   (optional) Sleep time between sending heartbeats.
#   Defaults to undef
#
class octavia::controller (
  String[1] $heartbeat_key,
  $amp_active_retries                 = $facts['os_service_default'],
  $amp_active_wait_sec                = $facts['os_service_default'],
  String[1] $amp_flavor_id            = '65',
  $amp_image_tag                      = $facts['os_service_default'],
  $amp_image_owner_id                 = $facts['os_service_default'],
  $amp_secgroup_list                  = $facts['os_service_default'],
  $amp_boot_network_list              = $facts['os_service_default'],
  $loadbalancer_topology              = $facts['os_service_default'],
  $amphora_driver                     = $facts['os_service_default'],
  $compute_driver                     = $facts['os_service_default'],
  $network_driver                     = $facts['os_service_default'],
  $volume_driver                      = $facts['os_service_default'],
  $image_driver                       = $facts['os_service_default'],
  $amp_timezone                       = $facts['os_service_default'],
  $amphora_delete_retries             = $facts['os_service_default'],
  $amphora_delete_retry_interval      = $facts['os_service_default'],
  $event_notifications                = $facts['os_service_default'],
  $db_commit_retry_attempts           = $facts['os_service_default'],
  $db_commit_retry_initial_delay      = $facts['os_service_default'],
  $db_commit_retry_backoff            = $facts['os_service_default'],
  $db_commit_retry_max                = $facts['os_service_default'],
  Boolean $enable_ssh_access          = true,
  String[1] $amp_ssh_key_name         = 'octavia-ssh-key',
  $timeout_client_data                = $facts['os_service_default'],
  $timeout_member_connect             = $facts['os_service_default'],
  $timeout_member_data                = $facts['os_service_default'],
  $timeout_tcp_inspect                = $facts['os_service_default'],
  $connection_max_retries             = $facts['os_service_default'],
  $connection_retry_interval          = $facts['os_service_default'],
  $connection_logging                 = $facts['os_service_default'],
  $active_connection_max_retries      = $facts['os_service_default'],
  $active_connection_retry_interval   = $facts['os_service_default'],
  $failover_connection_max_retries    = $facts['os_service_default'],
  $failover_connection_retry_interval = $facts['os_service_default'],
  $build_rate_limit                   = $facts['os_service_default'],
  $build_active_retries               = $facts['os_service_default'],
  $build_retry_interval               = $facts['os_service_default'],
  $api_db_commit_retry_attempts       = $facts['os_service_default'],
  $api_db_commit_retry_initial_delay  = $facts['os_service_default'],
  $api_db_commit_retry_backoff        = $facts['os_service_default'],
  $api_db_commit_retry_max            = $facts['os_service_default'],
  $default_connection_limit           = $facts['os_service_default'],
  $agent_request_read_timeout         = $facts['os_service_default'],
  $agent_tls_protocol                 = $facts['os_service_default'],
  $admin_log_targets                  = $facts['os_service_default'],
  $administrative_log_facility        = $facts['os_service_default'],
  $forward_all_logs                   = $facts['os_service_default'],
  $tenant_log_targets                 = $facts['os_service_default'],
  $user_log_facility                  = $facts['os_service_default'],
  $user_log_format                    = $facts['os_service_default'],
  $log_protocol                       = $facts['os_service_default'],
  $log_retry_count                    = $facts['os_service_default'],
  $log_retry_interval                 = $facts['os_service_default'],
  $log_queue_size                     = $facts['os_service_default'],
  $logging_template_override          = $facts['os_service_default'],
  $disable_local_log_storage          = $facts['os_service_default'],
  $vrrp_advert_int                    = $facts['os_service_default'],
  $vrrp_check_interval                = $facts['os_service_default'],
  $vrrp_fail_count                    = $facts['os_service_default'],
  $vrrp_success_count                 = $facts['os_service_default'],
  $vrrp_garp_refresh_interval         = $facts['os_service_default'],
  $vrrp_garp_refresh_count            = $facts['os_service_default'],
  $controller_ip_port_list            = $facts['os_service_default'],
  $heartbeat_interval                 = $facts['os_service_default'],
) inherits octavia::params {

  include octavia::deps
  include octavia::db

  if ! is_service_default($loadbalancer_topology) and
      ! ($loadbalancer_topology in ['SINGLE', 'ACTIVE_STANDBY']) {
    fail('load balancer topology must be one of SINGLE or ACTIVE_STANDBY')
  }

  if $enable_ssh_access {
    octavia_config { 'controller_worker/amp_ssh_key_name' : value => $amp_ssh_key_name; }
  }
  else {
    octavia_config { 'controller_worker/amp_ssh_key_name' : value => $facts['os_service_default'] }
  }

  octavia_config {
    'controller_worker/amp_active_retries'               : value => $amp_active_retries;
    'controller_worker/amp_active_wait_sec'              : value => $amp_active_wait_sec;
    'controller_worker/amp_flavor_id'                    : value => $amp_flavor_id;
    'controller_worker/amp_image_tag'                    : value => $amp_image_tag;
    'controller_worker/amp_image_owner_id'               : value => $amp_image_owner_id;
    'controller_worker/amp_secgroup_list'                : value => join(any2array($amp_secgroup_list), ',');
    'controller_worker/amp_boot_network_list'            : value => join(any2array($amp_boot_network_list), ',');
    'controller_worker/loadbalancer_topology'            : value => $loadbalancer_topology;
    'controller_worker/amphora_driver'                   : value => $amphora_driver;
    'controller_worker/compute_driver'                   : value => $compute_driver;
    'controller_worker/network_driver'                   : value => $network_driver;
    'controller_worker/volume_driver'                    : value => $volume_driver;
    'controller_worker/image_driver'                     : value => $image_driver;
    'controller_worker/amp_timezone'                     : value => $amp_timezone;
    'controller_worker/amphora_delete_retries'           : value => $amphora_delete_retries;
    'controller_worker/amphora_delete_retry_interval'    : value => $amphora_delete_retry_interval;
    'controller_worker/event_notifications'              : value => $event_notifications;
    'controller_worker/db_commit_retry_attempts'         : value => $db_commit_retry_attempts;
    'controller_worker/db_commit_retry_initial_delay'    : value => $db_commit_retry_initial_delay;
    'controller_worker/db_commit_retry_backoff'          : value => $db_commit_retry_backoff;
    'controller_worker/db_commit_retry_max'              : value => $db_commit_retry_max;
    'haproxy_amphora/timeout_client_data'                : value => $timeout_client_data;
    'haproxy_amphora/timeout_member_connect'             : value => $timeout_member_connect;
    'haproxy_amphora/timeout_member_data'                : value => $timeout_member_data;
    'haproxy_amphora/timeout_tcp_inspect'                : value => $timeout_tcp_inspect;
    'haproxy_amphora/connection_max_retries'             : value => $connection_max_retries;
    'haproxy_amphora/connection_retry_interval'          : value => $connection_retry_interval;
    'haproxy_amphora/connection_logging'                 : value => $connection_logging;
    'haproxy_amphora/active_connection_max_retries'      : value => $active_connection_max_retries;
    'haproxy_amphora/active_connection_retry_interval'   : value => $active_connection_retry_interval;
    'haproxy_amphora/failover_connection_max_retries'    : value => $failover_connection_max_retries;
    'haproxy_amphora/failover_connection_retry_interval' : value => $failover_connection_retry_interval;
    'haproxy_amphora/build_rate_limit'                   : value => $build_rate_limit;
    'haproxy_amphora/build_active_retries'               : value => $build_active_retries;
    'haproxy_amphora/build_retry_interval'               : value => $build_retry_interval;
    'haproxy_amphora/api_db_commit_retry_attempts'       : value => $api_db_commit_retry_attempts;
    'haproxy_amphora/api_db_commit_retry_initial_delay'  : value => $api_db_commit_retry_initial_delay;
    'haproxy_amphora/api_db_commit_retry_backoff'        : value => $api_db_commit_retry_backoff;
    'haproxy_amphora/api_db_commit_retry_max'            : value => $api_db_commit_retry_max;
    'haproxy_amphora/default_connection_limit'           : value => $default_connection_limit;
    'amphora_agent/agent_request_read_timeout'           : value => $agent_request_read_timeout;
    'amphora_agent/agent_tls_protocol'                   : value => $agent_tls_protocol;
    'amphora_agent/admin_log_targets'                    : value => join(any2array($admin_log_targets), ',');
    'amphora_agent/administrative_log_facility'          : value => $administrative_log_facility;
    'amphora_agent/forward_all_logs'                     : value => $forward_all_logs;
    'amphora_agent/tenant_log_targets'                   : value => join(any2array($tenant_log_targets), ',');
    'amphora_agent/user_log_facility'                    : value => $user_log_facility;
    'haproxy_amphora/user_log_format'                    : value => $user_log_format;
    'amphora_agent/log_protocol'                         : value => $log_protocol;
    'amphora_agent/log_retry_count'                      : value => $log_retry_count;
    'amphora_agent/log_retry_interval'                   : value => $log_retry_interval;
    'amphora_agent/log_queue_size'                       : value => $log_queue_size;
    'amphora_agent/logging_template_override'            : value => $logging_template_override;
    'amphora_agent/disable_local_log_storage'            : value => $disable_local_log_storage;
    'keepalived_vrrp/vrrp_advert_int'                    : value => $vrrp_advert_int;
    'keepalived_vrrp/vrrp_check_interval'                : value => $vrrp_check_interval;
    'keepalived_vrrp/vrrp_fail_count'                    : value => $vrrp_fail_count;
    'keepalived_vrrp/vrrp_success_count'                 : value => $vrrp_success_count;
    'keepalived_vrrp/vrrp_garp_refresh_interval'         : value => $vrrp_garp_refresh_interval;
    'keepalived_vrrp/vrrp_garp_refresh_count'            : value => $vrrp_garp_refresh_count;
    'health_manager/controller_ip_port_list'             : value => join(any2array($controller_ip_port_list), ',');
    'health_manager/heartbeat_key'                       : value => $heartbeat_key, secret => true;
    'health_manager/heartbeat_interval'                  : value => $heartbeat_interval;
  }
}
