#
# Configures credentials for service to service communication.
#
# === Parameters:
#
# [*password*]
#   (required) Password for user
#
# [*auth_url*]
#   (optional) Keystone Authentication URL
#   Defaults to 'http://localhost:5000'
#
# [*username*]
#   (optional) User for accessing neutron and other services.
#   Defaults to 'octavia'
#
# [*project_name*]
#   (optional) Tenant for accessing neutron and other services
#   Defaults to 'services'
#
# [*user_domain_name*]
#   (optional) keystone user domain
#   Defaults to 'Default'
#
# [*project_domain_name*]
#   (optional) keystone project domain
#   Defaults to 'Default'
#
# [*auth_type*]
#   (optional) keystone authentication type
#   Defaults to 'password'
#
# [*region_name*]
#   (Optional) The region in which the identity server can be found.
#   Defaults to $::os_service_default.
#
class octavia::service_auth (
  $password,
  $auth_url            = 'http://localhost:5000',
  $username            = 'octavia',
  $project_name        = 'services',
  $user_domain_name    = 'Default',
  $project_domain_name = 'Default',
  $auth_type           = 'password',
  $region_name         = $::os_service_default,
) {

  include octavia::deps

  octavia_config {
    'service_auth/auth_url'            : value => $auth_url;
    'service_auth/username'            : value => $username;
    'service_auth/project_name'        : value => $project_name;
    'service_auth/password'            : value => $password, secret => true;
    'service_auth/user_domain_name'    : value => $user_domain_name;
    'service_auth/project_domain_name' : value => $project_domain_name;
    'service_auth/auth_type'           : value => $auth_type;
    'service_auth/region_name'         : value => $region_name;
  }
}
