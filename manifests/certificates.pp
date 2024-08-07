# == Class: octavia::certificates
#
#  Configure the octavia certificates for TLS authentication
#
# === Parameters
#
# [*cert_generator*]
#   (Optional) Certificate generator to use.
#   Defaults to $facts['os_service_default']
#
# [*cert_manager*]
#   (Optional) Certificate manager to use.
#   Defaults to $facts['os_service_default']
#
# [*barbican_auth*]
#   (Optional) Name of the Barbican authentication method to use.
#   Defaults to $facts['os_service_default']
#
# [*service_name*]
#   (Optional) The name of the certificate service in the keystone catalog.
#   Defaults to $facts['os_service_default']
#
# [*endpoint*]
#   (Optional) A new endpoint to override the endpoint in the keystone catalog.
#   Defaults to $facts['os_service_default']
#
# [*region_name*]
#   (Optional) Region name to use when connecting to cert manager.
#   Defaults to $facts['os_service_default']
#
# [*endpoint_type*]
#   (Optional) Endpoint type to use when connecting to cert manager.
#   Defaults to $facts['os_service_default']
#
# [*ca_certificate*]
#   (Optional) Path to the CA certificate for Octavia
#   Defaults to '/etc/ssl/certs/ssl-cert-snakeoil.pem'
#
# [*ca_private_key*]
#   (Optional) Path for private key used to sign certificates
#   Defaults to '/etc/ssl/private/ssl-cert-snakeoil.key'
#
# [*server_certs_key_passphrase*]
#   (Optional) Passphrase for encrypting Amphora Certificates and Private Keys.
#   Must be exactly 32 characters.
#   Defaults to 'insecure-key-do-not-use-this-key'
#
# [*ca_private_key_passphrase*]
#   (Optional) CA password used to sign certificates
#   Defaults to $facts['os_service_default']
#
# [*signing_digest*]
#   (Optional) Certificate signing digest.
#   Defaults to $facts['os_service_default']
#
# [*cert_validity_time*]
#   (Optional) The validity time for the Amphora Certificates (in seconds).
#   Defaults to $facts['os_service_default']
#
# [*client_ca*]
#   (Optional) Path to the client CA certificate.
#   This option is not needed unless you want to separate the
#   ca_certificate/server_ca and the client_ca.
#   Defaults to undef
#
# [*client_cert*]
#   (Optional) Path for client certificate used to connect to amphorae.
#   Defaults to $facts['os_service_default']
#
# [*ca_certificate_data*]
#   (Optional) Data CA certificate for Octavia
#   Defaults to undef
#
# [*ca_certificate_source*]
#   (Optional) Source file for CA certificate for Octavia
#   Defaults to undef
#
# [*ca_private_key_data*]
#   (Optional) Data CA private key for signing certificates
#   Defaults to undef
#
# [*ca_private_key_source*]
#   (Optional) Source file for CA private key for signing certificates
#   Defaults to undef
#
# [*client_ca_data*]
#   (Optional) Data for client CA certificate.
#   You must specify the client_ca parameter where to place this CA
#   if you give the data here.
#   Defaults to undef
#
# [*client_ca_source*]
#   (Optional) Source for client CA certificate.
#   You must specify the client_ca parameter where to place this CA
#   if you give the data here.
#   Defaults to undef
#
# [*client_cert_data*]
#   (Optional) Data for client certificate used for connecting to amphorae
#   Defaults to undef
#
# [*client_cert_source*]
#   (Optional) Source for client certificate used for connecting to amphorae
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
  $cert_generator                             = $facts['os_service_default'],
  $cert_manager                               = $facts['os_service_default'],
  $barbican_auth                              = $facts['os_service_default'],
  $service_name                               = $facts['os_service_default'],
  $endpoint                                   = $facts['os_service_default'],
  $region_name                                = $facts['os_service_default'],
  $endpoint_type                              = $facts['os_service_default'],
  Stdlib::Absolutepath $ca_certificate        = '/etc/ssl/certs/ssl-cert-snakeoil.pem',
  Stdlib::Absolutepath $ca_private_key        = '/etc/ssl/certs/ssl-cert-snakeoil.key',
  String[32, 32] $server_certs_key_passphrase = 'insecure-key-do-not-use-this-key',
  $ca_private_key_passphrase                  = $facts['os_service_default'],
  $signing_digest                             = $facts['os_service_default'],
  $cert_validity_time                         = $facts['os_service_default'],
  Optional[Stdlib::Absolutepath] $client_ca   = undef,
  Stdlib::Absolutepath $client_cert           = '/etc/octavia/certs/client.pem',
  Optional[String[1]] $ca_certificate_data    = undef,
  Optional[String[1]] $ca_certificate_source  = undef,
  Optional[String[1]] $ca_private_key_data    = undef,
  Optional[String[1]] $ca_private_key_source  = undef,
  Optional[String[1]] $client_ca_data         = undef,
  Optional[String[1]] $client_ca_source       = undef,
  Optional[String[1]] $client_cert_data       = undef,
  Optional[String[1]] $client_cert_source     = undef,
  $file_permission_owner                      = $::octavia::params::user,
  $file_permission_group                      = $::octavia::params::group,
) inherits octavia::params {

  include octavia::deps

  $client_ca_real = pick($client_ca, $ca_certificate)

  octavia_config {
    'certificates/cert_generator'              : value => $cert_generator;
    'certificates/cert_manager'                : value => $cert_manager;
    'certificates/barbican_auth'               : value => $barbican_auth;
    'certificates/service_name'                : value => $service_name;
    'certificates/endpoint'                    : value => $endpoint;
    'certificates/region_name'                 : value => $region_name;
    'certificates/endpoint_type'               : value => $endpoint_type;
    'certificates/ca_certificate'              : value => $ca_certificate;
    'certificates/ca_private_key'              : value => $ca_private_key;
    'certificates/server_certs_key_passphrase' : value => $server_certs_key_passphrase, secret => true;
    'certificates/ca_private_key_passphrase'   : value => $ca_private_key_passphrase, secret => true;
    'certificates/signing_digest'              : value => $signing_digest;
    'certificates/cert_validity_time'          : value => $cert_validity_time;
    'controller_worker/client_ca'              : value => $client_ca_real;
    'haproxy_amphora/client_cert'              : value => $client_cert;
    'haproxy_amphora/server_ca'                : value => $ca_certificate;
  }

  # The file creation will create the parent directory for each file if necessary, but
  # only to one level.
  if $ca_certificate_data or $ca_certificate_source {
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
      source    => $ca_certificate_source,
      group     => $file_permission_owner,
      owner     => $file_permission_group,
      mode      => '0640',
      replace   => true,
      show_diff => false,
      tag       => 'octavia-certificate',
    }
  }

  if $ca_private_key_data or $ca_private_key_source {
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
      source    => $ca_private_key_source,
      group     => $file_permission_owner,
      owner     => $file_permission_group,
      mode      => '0640',
      replace   => true,
      show_diff => false,
      tag       => 'octavia-certificate',
    }
  }

  if $client_ca and ( $client_ca_data or $client_ca_source ) {
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
      source    => $client_ca_source,
      group     => $file_permission_owner,
      owner     => $file_permission_group,
      mode      => '0640',
      replace   => true,
      show_diff => false,
      tag       => 'octavia-certificate',
    }
  }

  if $client_cert_data or $client_cert_source {
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
      source    => $client_cert_source,
      group     => $file_permission_owner,
      owner     => $file_permission_group,
      mode      => '0640',
      replace   => true,
      show_diff => false,
      tag       => 'octavia-certificate',
    }
  }
}
