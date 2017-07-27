# == Class: octavia::certificates
#
#  Configure the octavia certificates for TLS authentication
#
# === Parameters
#
# [*ca_certificate*]
#   (Optional) Path to the CA certificate for Octavia
#   Defaults to $::os_service_default
#
# [*ca_private_key*]
#   (Optional) Path for private key used to sign certificates
#   Defaults to $::os_service_default
#
# [*ca_private_key_passphrase*]
#   (Optional) CA password used to sign certificates
#   Defaults to $::os_service_default
#
# [*client_cert*]
#   (Optional) Path for client certificate used to connect to amphorae.
#   Defaults to $::os_service_default
#
class octavia::certificates (
  $ca_certificate            = $::os_service_default,
  $ca_private_key            = $::os_service_default,
  $ca_private_key_passphrase = $::os_service_default,
  $client_cert               = $::os_service_default,
) {

  include ::octavia::deps

  octavia_config {
    'certificates/ca_certificate'            : value => $ca_certificate;
    'certificates/ca_private_key'            : value => $ca_private_key;
    'certificates/ca_private_key_passphrase' : value => $ca_private_key_passphrase;
    'controller_worker/client_ca'            : value => $ca_certificate;
    'haproxy_amphora/client_cert'            : value => $client_cert;
    'haproxy_amphora/server_ca'              : value => $ca_certificate;
  }
}
