# == Class: octavia::roles
#
# Configure the octavia roles
#
# === Parameters
#
# [*role_names*]
#   (optional) Create keystone roles to comply with Octavia policies.
#   Defaults to ['load-balancer_observer', 'load-balancer_global_observer',
#   'load-balancer_member', 'load-balancer_quota_admin', 'load-balancer_admin']
#
class octavia::roles (
  Array[String[1]] $role_names = [
    'load-balancer_observer',
    'load-balancer_global_observer',
    'load-balancer_member',
    'load-balancer_quota_admin',
    'load-balancer_admin',
  ]
) {

  warning('The octavia::roles class is deprecated and will be removed')

  keystone_role { $role_names:
    ensure => present,
  }
}
