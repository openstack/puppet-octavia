# == Class: octavia::nova
#
# Setup and configure octavia.conf nova section.
#
# === Parameters:
#
# [*service_name*]
#   (Optional) The name of the nova service in the keystone catalog.
#   Defaults to $::os_service_default
#
# [*endpoint*]
#   (Optional) Custom nova endpoint if override is necessary.
#   Defaults to $::os_service_default
#
# [*region_name*]
#   (Optional) Region in catalog to use for nova.
#   Defaults to $::os_service_default
#
# [*endpoint_type*]
#   (Optional) Endpoint type in catalog to use for nova.
#   Defaults to $::os_service_default
#
# [*availability_zone*]
#   (Optional) Availability zone to use for creating Amphorae.
#   Defaults to $::os_service_default
#
# [*enable_anti_affinity*]
#   (Optional) Enable anti-affinity in nova.
#   Defaults to $::os_service_default
#
# [*anti_affinity_policy*]
#   (Optional) Set the anti-affinity policy to what is suitable.
#   Nova supports: anti-affinity and soft-anti-affinity.
#   Defaults to $::os_service_default
#
class octavia::nova (
  $service_name         = $::os_service_default,
  $endpoint             = $::os_service_default,
  $region_name          = $::os_service_default,
  $endpoint_type        = $::os_service_default,
  $availability_zone    = $::os_service_default,
  $enable_anti_affinity = $::os_service_default,
  $anti_affinity_policy = $::os_service_default,
) {

  include octavia::deps

  octavia_config {
    'nova/service_name':         value => $service_name;
    'nova/endpoint':             value => $endpoint;
    'nova/region_name':          value => $region_name;
    'nova/endpoint_type':        value => $endpoint_type;
    'nova/availability_zone':    value => $availability_zone;
    'nova/enable_anti_affinity': value => $enable_anti_affinity;
    'nova/anti_affinity_policy': value => $anti_affinity_policy;
  }
}
