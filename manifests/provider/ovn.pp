# Configures the octavia ovn driver
#
# == Parameters
#
# [*package_ensure*]
#   (optional) ensure state for package.
#   Defaults to 'present'
#
# [*ovn_nb_connection*]
#   (optional) The connection string for the OVN_Northbound OVSDB.
#   Defaults to $facts['os_service_default']
#
# [*ovn_nb_private_key*]
#   (optional) The PEM file with private key for SSL connection to OVN-NB-DB
#   Defaults to $facts['os_service_default']
#
# [*ovn_nb_certificate*]
#   (optional) The PEM file with certificate that certifies the private
#   key specified in ovn_nb_private_key
#   Defaults to $facts['os_service_default']
#
# [*ovn_nb_ca_cert*]
#   (optional) The PEM file with CA certificate that OVN should use to
#   verify certificates presented to it by SSL peers
#   Defaults to $facts['os_service_default']
#
# [*ovn_sb_connection*]
#   (optional) The connection string for the OVN_Southbound OVSDB.
#   Defaults to $facts['os_service_default']
#
# [*ovn_sb_private_key*]
#   (optional) The PEM file with private key for SSL connection to OVN-SB-DB
#   Defaults to $facts['os_service_default']
#
# [*ovn_sb_certificate*]
#   (optional) The PEM file with certificate that certifies the private
#   key specified in ovn_sb_private_key
#   Defaults to $facts['os_service_default']
#
# [*ovn_sb_ca_cert*]
#   (optional) The PEM file with CA certificate that OVN should use to
#   verify certificates presented to it by SSL peers
#   Defaults to $facts['os_service_default']
#
# [*ovsdb_connection_timeout*]
#   (optional) Timeout in seconds for the OVSDB connection transaction.
#   Defaults to $facts['os_service_default']
#
# [*ovsdb_retry_max_interval*]
#   (optional) Max interval in seconds between each retry to get the OVN NB and
#   SB IDLs.
#   Defaults to $facts['os_service_default']
#
# [*ovsdb_probe_interval*]
#   (optional) The probe interval for the OVSDB session in milliseconds.
#   Defaults to $facts['os_service_default']
#
class octavia::provider::ovn (
  $package_ensure           = 'present',
  $ovn_nb_connection        = $facts['os_service_default'],
  $ovn_nb_private_key       = $facts['os_service_default'],
  $ovn_nb_certificate       = $facts['os_service_default'],
  $ovn_nb_ca_cert           = $facts['os_service_default'],
  $ovn_sb_connection        = $facts['os_service_default'],
  $ovn_sb_private_key       = $facts['os_service_default'],
  $ovn_sb_certificate       = $facts['os_service_default'],
  $ovn_sb_ca_cert           = $facts['os_service_default'],
  $ovsdb_connection_timeout = $facts['os_service_default'],
  $ovsdb_retry_max_interval = $facts['os_service_default'],
  $ovsdb_probe_interval     = $facts['os_service_default'],
) {

  include octavia::deps
  include octavia::params

  package { 'ovn-octavia-provider':
    ensure => $package_ensure,
    name   => $octavia::params::ovn_provider_package_name,
    tag    => ['openstack', 'octavia-package'],
  }

  # TODO(flaviof): We need to replace octavia_config with octavia_ovn_provider_config in the future.
  # For now, the config below uses octavia_config until we can figure out how to pass extra
  # configuration files to the api running as wsgi process.
  octavia_config {
    'ovn/ovn_nb_connection':        value => join(any2array($ovn_nb_connection), ',');
    'ovn/ovn_nb_private_key':       value => $ovn_nb_private_key;
    'ovn/ovn_nb_certificate':       value => $ovn_nb_certificate;
    'ovn/ovn_nb_ca_cert':           value => $ovn_nb_ca_cert;
    'ovn/ovn_sb_connection':        value => join(any2array($ovn_sb_connection), ',');
    'ovn/ovn_sb_private_key':       value => $ovn_sb_private_key;
    'ovn/ovn_sb_certificate':       value => $ovn_sb_certificate;
    'ovn/ovn_sb_ca_cert':           value => $ovn_sb_ca_cert;
    'ovn/ovsdb_connection_timeout': value => $ovsdb_connection_timeout;
    'ovn/ovsdb_retry_max_interval': value => $ovsdb_retry_max_interval;
    'ovn/ovsdb_probe_interval':     value => $ovsdb_probe_interval;
  }
}
