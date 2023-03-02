#
# Configures credentials for service to service communication.
#
# === Parameters:
#
# [*password*]
#   (required) Password for user
#
# [*auth_url*]
#   (Optional) Keystone Authentication URL
#   Defaults to 'http://localhost:5000'
#
# [*username*]
#   (Optional) User for accessing neutron and other services.
#   Defaults to 'octavia'
#
# [*project_name*]
#   (Optional) Tenant for accessing neutron and other services
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
#   Defaults to $facts['os_service_default'].
#
class octavia::service_auth (
  $password,
  $auth_url            = 'http://localhost:5000',
  $username            = 'octavia',
  $project_name        = 'services',
  $user_domain_name    = 'Default',
  $project_domain_name = 'Default',
  $system_scope        = $facts['os_service_default'],
  $auth_type           = 'password',
  $region_name         = $facts['os_service_default'],
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
    'service_auth/auth_url'            : value => $auth_url;
    'service_auth/username'            : value => $username;
    'service_auth/project_name'        : value => $project_name_real;
    'service_auth/password'            : value => $password, secret => true;
    'service_auth/user_domain_name'    : value => $user_domain_name;
    'service_auth/project_domain_name' : value => $project_domain_name_real;
    'service_auth/system_scope'        : value => $system_scope;
    'service_auth/auth_type'           : value => $auth_type;
    'service_auth/region_name'         : value => $region_name;
  }
}
