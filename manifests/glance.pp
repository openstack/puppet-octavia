# == Class: octavia::glance
#
# Setup and configure octavia.conf glance section.
#
# === Parameters:
#
# [*service_name*]
#   (Optional) The name of the glance service in the keystone catalog.
#   Defaults to $facts['os_service_default']
#
# [*endpoint*]
#   (Optional) Custom glance endpoint if override is necessary.
#   Defaults to $facts['os_service_default']
#
# [*region_name*]
#   (Optional) Region in catalog to use for glance.
#   Defaults to $facts['os_service_default']
#
# [*endpoint_type*]
#   (Optional) Endpoint type in catalog to use for glance.
#   Defaults to $facts['os_service_default']
#
class octavia::glance (
  $service_name         = $facts['os_service_default'],
  $endpoint             = $facts['os_service_default'],
  $region_name          = $facts['os_service_default'],
  $endpoint_type        = $facts['os_service_default'],
) {
  include octavia::deps

  octavia_config {
    'glance/service_name':  value => $service_name;
    'glance/endpoint':      value => $endpoint;
    'glance/region_name':   value => $region_name;
    'glance/endpoint_type': value => $endpoint_type;
  }
}
