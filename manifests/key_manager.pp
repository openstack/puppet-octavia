# == Class: octavia::key_manager
#
# Setup and configure Key Manager options
#
# === Parameters
#
# [*backend*]
#   (Optional) Specify the key manager implementation.
#   Defaults to $facts['os_service_default']
#
class octavia::key_manager (
  $backend = $facts['os_service_default'],
) {

  include octavia::deps

  oslo::key_manager { 'octavia_config':
    backend => $backend,
  }
}
