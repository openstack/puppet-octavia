# == Class: octavia::certificates
#
#  Configure the octavia certificates for TLS authentication
#
# === Parameters
#
# [*cert_generator*]
#   (Optional) Certificate generator to use.
#   Defaults to $::os_service_default
#
# [*cert_manager*]
#   (Optional) Certificate manager to use.
#   Defaults to $::os_service_default
#
# [*region_name*]
#   (Optional) Region name to use when connecting to cert manager.
#   Defaults to $::os_service_default
#
# [*endpoint_type*]
#   (Optional) Endpoint type to use when connecting to cert manager.
#   Defaults to $::os_service_default
#
# [*ca_certificate*]
#   (Optional) Path to the CA certificate for Octavia
#   Defaults to $::os_service_default
#
# [*ca_private_key*]
#   (Optional) Path for private key used to sign certificates
#   Defaults to $::os_service_default
#
# [*server_certs_key_passphrase*]
#   (Optional) Passphrase for encrypting Amphora Certificates and Private Keys.
#   Must be exactly 32 characters.
#   Defaults to 'insecure-key-do-not-use-this-key'
#
# [*ca_private_key_passphrase*]
#   (Optional) CA password used to sign certificates
#   Defaults to $::os_service_default
#
# [*client_ca*]
#   (Optional) Path to the client CA certificate.
#   This option is not needed unless you want to separate the
#   ca_certificate/server_ca and the client_ca.
#   Defaults to undef
#
# [*client_cert*]
#   (Optional) Path for client certificate used to connect to amphorae.
#   Defaults to $::os_service_default
#
# [*ca_certificate_data*]
#   (Optional) CA certificate for Octavia
#   Defaults to undef
#
# [*ca_private_key_data*]
#   (Optional) CA private key for signing certificates
#   Defaults to undef
#
# [*client_ca_data*]
#   (Optional) Client CA certificate.
#   You must specify the client_ca parameter where to place this CA
#   if you give the data here.
#   Defaults to undef
#
# [*client_cert_data*]
#   (Optional) Client certificate used for connecting to amphorae
#   Defaults to undef
#
# [*file_permission_owner*]
#   (Optional) User account for file owner.
#   Defaults to 'octavia'
#
# [*file_permission_group*]
#   (Optional) User group for file permissions
#   Defaults to 'octavia'
#
class octavia::certificates (
  $cert_generator              = $::os_service_default,
  $cert_manager                = $::os_service_default,
  $region_name                 = $::os_service_default,
  $endpoint_type               = $::os_service_default,
  $ca_certificate              = $::os_service_default,
  $ca_private_key              = $::os_service_default,
  $server_certs_key_passphrase = 'insecure-key-do-not-use-this-key',
  $ca_private_key_passphrase   = $::os_service_default,
  $client_ca                   = undef,
  $client_cert                 = $::os_service_default,
  $ca_certificate_data         = undef,
  $ca_private_key_data         = undef,
  $client_ca_data              = undef,
  $client_cert_data            = undef,
  $file_permission_owner       = 'octavia',
  $file_permission_group       = 'octavia'
) {

  include ::octavia::deps

  $client_ca_real = pick($client_ca, $ca_certificate)

  octavia_config {
    'certificates/cert_generator'              : value => $cert_generator;
    'certificates/cert_manager'                : value => $cert_manager;
    'certificates/region_name'                 : value => $region_name;
    'certificates/endpoint_type'               : value => $endpoint_type;
    'certificates/ca_certificate'              : value => $ca_certificate;
    'certificates/ca_private_key'              : value => $ca_private_key;
    'certificates/server_certs_key_passphrase' : value => $server_certs_key_passphrase;
    'certificates/ca_private_key_passphrase'   : value => $ca_private_key_passphrase;
    'controller_worker/client_ca'              : value => $client_ca_real;
    'haproxy_amphora/client_cert'              : value => $client_cert;
    'haproxy_amphora/server_ca'                : value => $ca_certificate;
  }
  if !$server_certs_key_passphrase  {
    fail('server_certs_key_passphrase is required for Octavia. Please provide a 32 characters passphrase.')
  }
  if length($server_certs_key_passphrase)!=32 {
      fail("The passphrase '${server_certs_key_passphrase}' is invalid for server_certs_key_passphrase. Please provide a 32 characters
      passphrase.")
  }
  # The file creation will create the parent directory for each file if necessary, but
  # only to one level.
  if $ca_certificate_data {
    if is_service_default($ca_certificate) {
      fail('You must provide a path for storing the CA certificate')
    }
    ensure_resource('file', dirname($ca_certificate), {
      ensure => directory,
      owner  => $file_permission_owner,
      group  => $file_permission_group,
      mode   => '0755',
      tag    => 'octavia-certificate',
    })
    file { $ca_certificate:
      ensure    => file,
      content   => $ca_certificate_data,
      group     => $file_permission_owner,
      owner     => $file_permission_group,
      mode      => '0755',
      replace   => true,
      show_diff => false,
      tag       => 'octavia-certificate',
    }
  }
  if $ca_private_key_data {
    if is_service_default($ca_private_key) {
      fail('You must provide a path for storing the CA private key')
    }
    ensure_resource('file', dirname($ca_private_key), {
      ensure => directory,
      owner  => $file_permission_owner,
      group  => $file_permission_group,
      mode   => '0755',
      tag    => 'octavia-certificate',
    })
    file { $ca_private_key:
      ensure    => file,
      content   => $ca_private_key_data,
      group     => $file_permission_owner,
      owner     => $file_permission_group,
      mode      => '0755',
      replace   => true,
      show_diff => false,
      tag       => 'octavia-certificate',
    }
  }
  if $client_ca and $client_ca_data {
    ensure_resource('file', dirname($client_ca), {
      ensure => directory,
      owner  => $file_permission_owner,
      group  => $file_permission_group,
      mode   => '0755',
      tag    => 'octavia-certificate',
    })
    file { $client_ca:
      ensure    => file,
      content   => $client_ca_data,
      group     => $file_permission_owner,
      owner     => $file_permission_group,
      mode      => '0755',
      replace   => true,
      show_diff => false,
      tag       => 'octavia-certificate',
    }
  }
  if $client_cert_data {
    if is_service_default($client_cert) {
      fail('You must provide a path for storing the client certificate')
    }
    ensure_resource('file', dirname($client_cert), {
      ensure => directory,
      owner  => $file_permission_owner,
      group  => $file_permission_group,
      mode   => '0755',
      tag    => 'octavia-certificate',
    })
    file { $client_cert:
      ensure    => file,
      content   => $client_cert_data,
      group     => $file_permission_owner,
      owner     => $file_permission_group,
      mode      => '0755',
      replace   => true,
      show_diff => false,
      tag       => 'octavia-certificate',
    }
  }
}
