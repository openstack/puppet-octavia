# == Class: octavia::neutron
#
# Setup and configure octavia.conf neutron section.
#
# === Parameters:
#
# [*service_name*]
#   (Optional) The name of the neutron service in the keystone catalog.
#   Defaults to $facts['os_service_default']
#
# [*endpoint*]
#   (Optional) Custom neutron endpoint if override is necessary.
#   Defaults to $facts['os_service_default']
#
# [*region_name*]
#   (Optional) Region in catalog to use for neutron.
#   Defaults to $facts['os_service_default']
#
# [*endpoint_type*]
#   (Optional) Endpoint type in catalog to use for neutron.
#   Defaults to $facts['os_service_default']
#
class octavia::neutron (
  $service_name         = $facts['os_service_default'],
  $endpoint             = $facts['os_service_default'],
  $region_name          = $facts['os_service_default'],
  $endpoint_type        = $facts['os_service_default'],
) {

  include octavia::deps

  octavia_config {
    'neutron/service_name':  value => $service_name;
    'neutron/endpoint':      value => $endpoint;
    'neutron/region_name':   value => $region_name;
    'neutron/endpoint_type': value => $endpoint_type;
  }
}
