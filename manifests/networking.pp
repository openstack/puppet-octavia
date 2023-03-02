# == Class: octavia::networking
#
# Setup and configure octavia.conf networking section.
#
# === Parameters:
#
# [*max_retries*]
#  (Optional) The maximum attempts to retry an action with the networking
#  service.
#  Defaults to $facts['os_service_default']
#
# [*retry_interval*]
#  (Optional) Seconds to wait before retrying an action with the networking
#  service.
#  Defaults to $facts['os_service_default']
#
# [*retry_backoff*]
#  (Optional) The seconds to backoff retry attempts.
#  Defaults to $facts['os_service_default']
#
# [*retry_max*]
#  (Optional) The maximum interval in seconds between retry attempts.
#  Defaults to $facts['os_service_default']
#
# [*port_detach_timeout*]
#  (Optional) Seconds to wait for a port to detach from an amphora.
#  Defaults to $facts['os_service_default']
#
# [*allow_vip_network_id*]
#  (Optional) Can users supply a network_id for their VIP?
#  Defaults to $facts['os_service_default']
#
# [*allow_vip_subnet_id*]
#  (Optional) Can users supply a subnet_id for their VIP?
#  Defaults to $facts['os_service_default']
#
# [*allow_vip_port_id*]
#  (Optional) Can users supply a port_id for their VIP?
#  Defaults to $facts['os_service_default']
#
# [*valid_vip_networks*]
#  (Optional) List of network_ids that are valid for VIP creation.
#  Defaults to $facts['os_service_default']
#
# [*reserved_ips*]
#  (Optional) List of IP addresses reserved from being used for member
#  addresses.
#  Defaults to $facts['os_service_default']
#
# [*allow_invisible_resource_usage*]
#  (Optional) When True, users can use network resources they cannot normally
#  see as VIP or member subnets.
#  Defaults to $facts['os_service_default']
#
class octavia::networking (
  $max_retries                    = $facts['os_service_default'],
  $retry_interval                 = $facts['os_service_default'],
  $retry_backoff                  = $facts['os_service_default'],
  $retry_max                      = $facts['os_service_default'],
  $port_detach_timeout            = $facts['os_service_default'],
  $allow_vip_network_id           = $facts['os_service_default'],
  $allow_vip_subnet_id            = $facts['os_service_default'],
  $allow_vip_port_id              = $facts['os_service_default'],
  $valid_vip_networks             = $facts['os_service_default'],
  $reserved_ips                   = $facts['os_service_default'],
  $allow_invisible_resource_usage = $facts['os_service_default'],
) {

  include octavia::deps

  octavia_config {
    'networking/max_retries':                    value => $max_retries;
    'networking/retry_interval':                 value => $retry_interval;
    'networking/retry_backoff':                  value => $retry_backoff;
    'networking/retry_max':                      value => $retry_max;
    'networking/port_detach_timeout':            value => $port_detach_timeout;
    'networking/allow_vip_network_id':           value => $allow_vip_network_id;
    'networking/allow_vip_subnet_id':            value => $allow_vip_subnet_id;
    'networking/allow_vip_port_id':              value => $allow_vip_port_id;
    'networking/valid_vip_networks':             value => join(any2array($valid_vip_networks), ',');
    'networking/reserved_ips':                   value => join(any2array($reserved_ips), ',');
    'networking/allow_invisible_resource_usage': value => $allow_invisible_resource_usage;
  }
}
