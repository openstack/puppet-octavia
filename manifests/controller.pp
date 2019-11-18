# == Class: octavia::controller
#
# === Parameters
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
#   Defaults to $::os_service_default
#
# [*amp_secgroup_list*]
#   List of security groups to use for Amphorae.
#   Defaults to $::os_service_default
#
# [*amp_boot_network_list*]
#   List of networks to attach to Amphorae.
#   Defaults to []
#
# [*loadbalancer_topology*]
#   (optional) Load balancer topology configuration
#   Defaults to $::os_service_default
#
# [*amphora_driver*]
#   (optional) Name of driver for communicating with amphorae
#   Defaults to 'amphora_haproxy_rest_driver'
#
# [*compute_driver*]
#   (optional) Name of driver for managing amphorae VMs
#   Defaults to 'compute_nova_driver'
#
# [*network_driver*]
#   (optional) Name of network driver for configuring networking
#   for amphorae.
#   Defaults to 'allowed_address_pairs_driver' (neutron based)
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
#   Defaults to $::os_service_default
#
# [*timeout_member_connect*]
#   (optional) Backend member connection timeout.
#   Defaults to $::os_service_default
#
# [*timeout_member_data*]
#   (optional) Backend member inactivity timeout.'
#   Defaults to $::os_service_default
#
# [*timeout_tcp_inspect*]
#   (optional) Time to wait for TCP packets for content inspection.
#   Defaults to $::os_service_default
#
# [*controller_ip_port_list*]
#   (optional) The list of controllers in a host:port comma separated
#   list if multiple. This is added to the amphora config and is used
#   when it connects back to the controllers to report its health.
#   Defaults to $::os_service_default
#
# [*connection_max_retries*]
#   (optional) Maximum number of retries when contacting amphora.
#   Defaults to $::os_service_default
#
# [*connection_retry_interval*]
#   (optional) Number of seconds to wait between connection attempts to amphora.
#   Defaults to $::os_service_default
#
# [*connection_logging*]
#   (optional) When false, disables logging of tenant connection flows. This
#   includes storing them locally and sending them to the tenant syslog
#   endpoints.
#   Defaults to $::os_service_default
#
# [*build_active_retries*]
#   (optional) Retry threshold for waiting for a build slot for an amphorae.
#   Defaults to $::os_service_default
#
# [*port_detach_timeout*]
#   (optional) Seconds to wait for a port to detach from an amphora.
#   Defaults to $::os_service_default
#
# [*vrrp_advert_int*]
#   (optional) Amphora role and priority advertisement internal in seconds.
#   Defaults to $::os_service_default
#
# [*vrrp_check_interval*]
#   (optional) VRRP health check script run interval in seconds.
#   Defaults to $::os_service_default
#
# [*vrrp_fail_count*]
#   (optional) Number of successive failures before transition to a fail rate.
#   Defaults to $::os_service_default
#
# [*vrrp_success_count*]
#   (optional) Number of consecutive successes before transition to a success rate.
#   Defaults to $::os_service_default
#
# [*vrrp_garp_refresh_interval*]
#   (optional) Time in seconds between gratuitous ARP announcements from the MASTER.
#   Defaults to $::os_service_default
#
# [*vrrp_garp_refresh_count*]
#   (optional) Number of gratuitous ARP announcements to make on each refresh interval.
#   Defaults to $::os_service_default
#
# [*admin_log_targets*]
#   (optional) The list of syslog endpoints, host:port comma separated list,
#   to receive administrative log messages.
#   Defaults to $::os_service_default
#
# [*administrative_log_facility*]
#   (optional) The syslog "LOG_LOCAL" facility to use for the administrative
#   log messages.
#   Defaults to $::os_service_default
#
# [*forward_all_logs*]
#   (optional) When true, all log messages from the amphora will be forwarded
#   to the administrative log endponts, including non-load balancing related
#   logs.
#   Defaults to $::os_service_default
#
# [*tenant_log_targets*]
#   (optional) The list of syslog endpoints, host:port comma separated list,
#   to receive tenant traffic flow log messages.
#   Defaults to $::os_service_default
#
# [*user_log_facility*]
#   (optional) The syslog "LOG_LOCAL" facility to use for the tenant traffic
#   flow log messages.
#   Defaults to $::os_service_default
#
# [*user_log_format*]
#   (optional) The tenant traffic flow log format string.
#   Defaults to $::os_service_default
#
# [*disable_local_log_storage*]
#   (optional) When true, logs will not be stored on the amphora filesystem.
#   This includes all kernel, system, and security logs.
#   Defaults to $::os_service_default
#
# [*enable_anti_affinity*]
#   (optional) Flag to indicate if octavia anti-affinity feature is turned on.
#   Defaults to $::os_service_default
#
# [*anti_affinity_policy*]
#   (optional) Sets the nova anti-affinity policy for octavia.
#   Defaults to $::os_service_default

class octavia::controller (
  $amp_flavor_id               = '65',
  $amp_image_tag               = $::os_service_default,
  $amp_secgroup_list           = $::os_service_default,
  $amp_boot_network_list       = [],
  $loadbalancer_topology       = $::os_service_default,
  $amphora_driver              = 'amphora_haproxy_rest_driver',
  $compute_driver              = 'compute_nova_driver',
  $network_driver              = 'allowed_address_pairs_driver',
  $enable_ssh_access           = true,
  $amp_ssh_key_name            = 'octavia-ssh-key',
  $timeout_client_data         = $::os_service_default,
  $timeout_member_connect      = $::os_service_default,
  $timeout_member_data         = $::os_service_default,
  $timeout_tcp_inspect         = $::os_service_default,
  $controller_ip_port_list     = $::os_service_default,
  $connection_max_retries      = $::os_service_default,
  $connection_retry_interval   = $::os_service_default,
  $connection_logging          = $::os_service_default,
  $build_active_retries        = $::os_service_default,
  $port_detach_timeout         = $::os_service_default,
  $vrrp_advert_int             = $::os_service_default,
  $vrrp_check_interval         = $::os_service_default,
  $vrrp_fail_count             = $::os_service_default,
  $vrrp_success_count          = $::os_service_default,
  $vrrp_garp_refresh_interval  = $::os_service_default,
  $vrrp_garp_refresh_count     = $::os_service_default,
  $admin_log_targets           = $::os_service_default,
  $administrative_log_facility = $::os_service_default,
  $forward_all_logs            = $::os_service_default,
  $tenant_log_targets          = $::os_service_default,
  $user_log_facility           = $::os_service_default,
  $user_log_format             = $::os_service_default,
  $disable_local_log_storage   = $::os_service_default,
  $enable_anti_affinity        = $::os_service_default,
  $anti_affinity_policy        = $::os_service_default,
) inherits octavia::params {

  include ::octavia::deps
  include ::octavia::db

  # For backward compatibility
  $amp_flavor_id_real          = pick($::octavia::worker::amp_flavor_id, $amp_flavor_id)
  $amp_image_tag_real          = pick($::octavia::worker::amp_image_tag, $amp_image_tag)
  $amp_secgroup_list_real      = pick($::octavia::worker::amp_secgroup_list, $amp_secgroup_list)
  $amp_boot_network_list_real  = pick($::octavia::worker::amp_boot_network_list, $amp_boot_network_list)
  $loadbalancer_topology_real  = pick($::octavia::worker::loadbalancer_topology, $loadbalancer_topology)
  $amphora_driver_real         = pick($::octavia::worker::amphora_driver, $amphora_driver)
  $compute_driver_real         = pick($::octavia::worker::compute_driver, $compute_driver)
  $network_driver_real         = pick($::octavia::worker::network_driver, $network_driver)
  $amp_ssh_key_name_real       = pick($::octavia::worker::amp_ssh_key_name, $amp_ssh_key_name)
  $enable_ssh_access_real      = pick($::octavia::worker::enable_ssh_access, $enable_ssh_access)
  $timeout_client_data_real    = pick($::octavia::worker::timeout_client_data, $timeout_client_data)
  $timeout_member_connect_real = pick($::octavia::worker::timeout_member_connect, $timeout_member_connect)
  $timeout_member_data_real    = pick($::octavia::worker::timeout_member_data, $timeout_member_data)
  $timeout_tcp_inspect_real    = pick($::octavia::worker::timeout_tcp_inspect, $timeout_tcp_inspect)

  if ! is_service_default($::octavia::controller::loadbalancer_topology_real) and
      ! ($::octavia::controller::loadbalancer_topology_real in ['SINGLE', 'ACTIVE_STANDBY']) {
    fail('load balancer topology must be one of SINGLE or ACTIVE_STANDBY')
  }

  if $enable_ssh_access_real {
    octavia_config { 'controller_worker/amp_ssh_key_name' : value => $amp_ssh_key_name_real; }
  }
  else {
    octavia_config { 'controller_worker/amp_ssh_key_name' : value => $::os_service_default }
  }

  octavia_config {
    'controller_worker/amp_flavor_id'            : value => $amp_flavor_id_real;
    'controller_worker/amp_image_tag'            : value => $amp_image_tag_real;
    'controller_worker/amp_secgroup_list'        : value => $amp_secgroup_list_real;
    'controller_worker/amp_boot_network_list'    : value => $amp_boot_network_list_real;
    'controller_worker/loadbalancer_topology'    : value => $loadbalancer_topology_real;
    'controller_worker/amphora_driver'           : value => $amphora_driver_real;
    'controller_worker/compute_driver'           : value => $compute_driver_real;
    'controller_worker/network_driver'           : value => $network_driver_real;
    'haproxy_amphora/timeout_client_data'        : value => $timeout_client_data_real;
    'haproxy_amphora/timeout_member_connect'     : value => $timeout_member_connect_real;
    'haproxy_amphora/timeout_member_data'        : value => $timeout_member_data_real;
    'haproxy_amphora/timeout_tcp_inspect'        : value => $timeout_tcp_inspect_real;
    'health_manager/controller_ip_port_list'     : value => $controller_ip_port_list;
    'haproxy_amphora/connection_max_retries'     : value => $connection_max_retries;
    'haproxy_amphora/connection_retry_interval'  : value => $connection_retry_interval;
    'haproxy_amphora/connection_logging'         : value => $connection_logging;
    'haproxy_amphora/build_active_retries'       : value => $build_active_retries;
    'networking/port_detach_timeout'             : value => $port_detach_timeout;
    'keepalived_vrrp/vrrp_advert_int'            : value => $vrrp_advert_int;
    'keepalived_vrrp/vrrp_check_interval'        : value => $vrrp_check_interval;
    'keepalived_vrrp/vrrp_fail_count'            : value => $vrrp_fail_count;
    'keepalived_vrrp/vrrp_success_count'         : value => $vrrp_success_count;
    'keepalived_vrrp/vrrp_garp_refresh_interval' : value => $vrrp_garp_refresh_interval;
    'keepalived_vrrp/vrrp_garp_refresh_count'    : value => $vrrp_garp_refresh_count;
    'amphora_agent/admin_log_targets'            : value => $admin_log_targets;
    'amphora_agent/administrative_log_facility'  : value => $administrative_log_facility;
    'amphora_agent/forward_all_logs'             : value => $forward_all_logs;
    'amphora_agent/tenant_log_targets'           : value => $tenant_log_targets;
    'amphora_agent/user_log_facility'            : value => $user_log_facility;
    'haproxy_amphora/user_log_format'            : value => $user_log_format;
    'amphora_agent/disable_local_log_storage'    : value => $disable_local_log_storage;
    'nova/enable_anti_affinity'                  : value => $enable_anti_affinity;
    'nova/anti_affinity_policy'                  : value => $anti_affinity_policy;
  }
}
