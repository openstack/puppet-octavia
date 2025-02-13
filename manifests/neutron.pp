# == Class: octavia::neutron
#
# Setup and configure octavia.conf neutron section.
#
# === Parameters:
#
# [*password*]
#   (Required) Password for user
#
# [*auth_url*]
#   (Optional) Keystone Authentication URL
#   Defaults to 'http://localhost:5000'
#
# [*username*]
#   (Optional) User for accessing neutron
#   Defaults to 'neutron'
#
# [*project_name*]
#   (Optional) Tenant for accessing neutron
#   Defaults to 'services'
#
# [*user_domain_name*]
#   (Optional) keystone user domain
#   Defaults to 'Default'
#
# [*project_domain_name*]
#   (Optional) keystone project domain
#   Defaults to 'Default'
#
# [*system_scope*]
#   (Optional) Scope for system operations.
#   Defaults to $facts['os_service_default']
#
# [*auth_type*]
#   (Optional) keystone authentication type
#   Defaults to 'password'
#
# [*region_name*]
#   (Optional) The region in which the identity server can be found.
#   Defaults to $facts['os_service_default']
#
# [*service_name*]
#   (Optional) The name of the neutron service in the keystone catalog.
#   Defaults to $facts['os_service_default']
#
# [*endpoint_override*]
#   (Optional) Always use this endpoint URL for requests for this client.
#   Defaults to $facts['os_service_default']
#
# [*valid_interfaces*]
#   (Optional) List of interfaces, in order of preference for endpoint URL.
#   Defaults to $facts['os_service_default']
#
class octavia::neutron (
  $password,
  $auth_url             = 'http://localhost:5000',
  $username             = 'neutron',
  $project_name         = 'services',
  $user_domain_name     = 'Default',
  $project_domain_name  = 'Default',
  $system_scope         = $facts['os_service_default'],
  $auth_type            = 'password',
  $region_name          = $facts['os_service_default'],
  $service_name         = $facts['os_service_default'],
  $endpoint_override    = $facts['os_service_default'],
  $valid_interfaces     = $facts['os_service_default'],
) {

  include octavia::deps

  if is_service_default($system_scope) {
    $project_name_real = $project_name
    $project_domain_name_real = $project_domain_name
  } else {
    $project_name_real = $facts['os_service_default']
    $project_domain_name_real = $facts['os_service_default']
  }

  octavia_config {
    'neutron/auth_url':            value => $auth_url;
    'neutron/username':            value => $username;
    'neutron/project_name':        value => $project_name_real;
    'neutron/password':            value => $password, secret => true;
    'neutron/user_domain_name':    value => $user_domain_name;
    'neutron/project_domain_name': value => $project_domain_name_real;
    'neutron/system_scope':        value => $system_scope;
    'neutron/auth_type':           value => $auth_type;
    'neutron/region_name':         value => $region_name;
    'neutron/service_name':        value => $service_name;
    'neutron/endpoint_override':   value => $endpoint_override;
    'neutron/valid_interfaces':    value => join(any2array($valid_interfaces), ',');
  }
}
