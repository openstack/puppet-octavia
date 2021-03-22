# == Class: octavia::cinder
#
# Setup and configure octavia.conf cinder section.
#
# === Parameters:
#
# [*service_name*]
#   (Optional) The name of the cinder service in the keystone catalog.
#   Defaults to $::os_service_default
#
# [*endpoint*]
#   (Optional) Custom cinder endpoint if override is necessary.
#   Defaults to $::os_service_default
#
# [*region_name*]
#   (Optional) Region in catalog to use for cinder.
#   Defaults to $::os_service_default
#
# [*endpoint_type*]
#   (Optional) Endpoint type in catalog to use for cinder.
#   Defaults to $::os_service_default
#
# [*availability_zone*]
#   (Optional) Availability zone to use for creating volume.
#   Defaults to $::os_service_default
#
# [*volume_size*]
#   (Optional) Size of volume, in GB, for Amphora instance
#   Defaults to $::os_service_default
#
# [*volume_type*]
#   (Optional) Type of volume for Amphorae voume root disk
#   Defaults to $::os_service_default
#
# [*volume_create_retry_interval*]
#   (Optional) Interval time to wait volume is created in available state
#   Defaults to $::os_service_default
#
# [*volume_create_timeout*]
#   (Optional) Timeout to wait volume is created in available
#   Defaults to $::os_service_default
#
# [*volume_create_max_retries*]
#   (Optional) Maximum number of retries to create volume
#   Defaults to $::os_service_default
#
class octavia::cinder (
  $service_name                 = $::os_service_default,
  $endpoint                     = $::os_service_default,
  $region_name                  = $::os_service_default,
  $endpoint_type                = $::os_service_default,
  $availability_zone            = $::os_service_default,
  $volume_size                  = $::os_service_default,
  $volume_type                  = $::os_service_default,
  $volume_create_retry_interval = $::os_service_default,
  $volume_create_timeout        = $::os_service_default,
  $volume_create_max_retries    = $::os_service_default,
) {

  include octavia::deps

  octavia_config {
    'cinder/service_name':                 value => $service_name;
    'cinder/endpoint':                     value => $endpoint;
    'cinder/region_name':                  value => $region_name;
    'cinder/endpoint_type':                value => $endpoint_type;
    'cinder/availability_zone':            value => $availability_zone;
    'cinder/volume_size':                  value => $volume_size;
    'cinder/volume_type':                  value => $volume_type;
    'cinder/volume_create_retry_interval': value => $volume_create_retry_interval;
    'cinder/volume_create_timeout':        value => $volume_create_timeout;
    'cinder/volume_create_max_retries':    value => $volume_create_max_retries;
  }
}
