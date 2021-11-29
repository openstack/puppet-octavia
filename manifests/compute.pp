# == Class: octavia::compute
#
# Setup and configure octavia.conf compute section.
#
# === Parameters:
#
# [*max_retries*]
#  (Optional) The maximum attempts to retry an acction with the compute
#  service.
#  Defaults to $::os_service_default
#
# [*retry_interval*]
#  (Optional) Seocnds to wait before retrying an action with the compute
#  service.
#  Defaults to $::os_service_default
#
# [*retry_backoff*]
#  (Optional) The seconds to backoff retry attempts.
#  Defaults to $::os_service_default
#
# [*retry_max*]
#  (Optional) The maximum interval in seconds between retry attempts.
#  Defaults to $::os_service_default
#
class octavia::compute (
  $max_retries    = $::os_service_default,
  $retry_interval = $::os_service_default,
  $retry_backoff  = $::os_service_default,
  $retry_max      = $::os_service_default,
) {

  include octavia::deps

  octavia_config {
    'compute/max_retries':    value => $max_retries;
    'compute/retry_interval': value => $retry_interval;
    'compute/retry_backoff':  value => $retry_backoff;
    'compute/retry_max':      value => $retry_max;
  }
}
