# == Class: octavia::keystone::auth
#
# Configures octavia user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for octavia user.
#
# [*auth_name*]
#   (Optional) Username for octavia service.
#   Defaults to 'octavia'.
#
# [*email*]
#   (Optional) Email for octavia user.
#   Defaults to 'octavia@localhost'.
#
# [*tenant*]
#   (Optional) Tenant for octavia user.
#   Defaults to 'services'.
#
# [*roles*]
#   (Optional) List of roles assigned to octavia user.
#   Defaults to ['admin']
#
# [*system_scope*]
#   (Optional) Scope for system operations.
#   Defaults to 'all'
#
# [*system_roles*]
#   (Optional) List of system roles assigned to octavia user.
#   Defaults to []
#
# [*configure_endpoint*]
#   (Optional) Should octavia endpoint be configured?
#   Defaults to true.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to true.
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to true.
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'load-balancer'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to 'octavia'
#
# [*service_description*]
#   (Optional) Description of the service.
#   Default to 'OpenStack Load Balancing Service'
#
# [*public_url*]
#   (Optional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9876'
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9876'
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9876'
#
class octavia::keystone::auth (
  String[1] $password,
  String[1] $auth_name                    = 'octavia',
  String[1] $email                        = 'octavia@localhost',
  String[1] $tenant                       = 'services',
  Array[String[1]] $roles                 = ['admin'],
  String[1] $system_scope                 = 'all',
  Array[String[1]] $system_roles          = [],
  Boolean $configure_endpoint             = true,
  Boolean $configure_user                 = true,
  Boolean $configure_user_role            = true,
  String[1] $service_description          = 'OpenStack Load Balancing Service',
  String[1] $service_name                 = 'octavia',
  String[1] $service_type                 = 'load-balancer',
  String[1] $region                       = 'RegionOne',
  Keystone::PublicEndpointUrl $public_url = 'http://127.0.0.1:9876',
  Keystone::EndpointUrl $admin_url        = 'http://127.0.0.1:9876',
  Keystone::EndpointUrl $internal_url     = 'http://127.0.0.1:9876',
) {

  include octavia::deps

  Keystone::Resource::Service_identity['octavia'] -> Anchor['octavia::service::end']

  keystone::resource::service_identity { 'octavia':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $service_name,
    service_type        => $service_type,
    service_description => $service_description,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    roles               => $roles,
    system_scope        => $system_scope,
    system_roles        => $system_roles,
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }

}
