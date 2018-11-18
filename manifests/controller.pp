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
# [*controller_ip_port_list*]
#   (optional) The list of controllers in a host:port comma separated
#   list if multiple. This is added to the amphora config and is used
#   when it connects back to the controllers to report its health.
#   Defaults to $::os_service_default
#
class octavia::controller (
  $amp_flavor_id           = '65',
  $amp_image_tag           = $::os_service_default,
  $amp_secgroup_list       = $::os_service_default,
  $amp_boot_network_list   = [],
  $loadbalancer_topology   = $::os_service_default,
  $amphora_driver          = 'amphora_haproxy_rest_driver',
  $compute_driver          = 'compute_nova_driver',
  $network_driver          = 'allowed_address_pairs_driver',
  $enable_ssh_access       = true,
  $amp_ssh_key_name        = 'octavia-ssh-key',
  $controller_ip_port_list = $::os_service_default,
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
    'controller_worker/amp_flavor_id'         : value => $amp_flavor_id_real;
    'controller_worker/amp_image_tag'         : value => $amp_image_tag_real;
    'controller_worker/amp_secgroup_list'     : value => $amp_secgroup_list_real;
    'controller_worker/amp_boot_network_list' : value => $amp_boot_network_list_real;
    'controller_worker/loadbalancer_topology' : value => $loadbalancer_topology_real;
    'controller_worker/amphora_driver'        : value => $amphora_driver_real;
    'controller_worker/compute_driver'        : value => $compute_driver_real;
    'controller_worker/network_driver'        : value => $network_driver_real;
    'health_manager/controller_ip_port_list'  : value => $controller_ip_port_list;
  }
}
