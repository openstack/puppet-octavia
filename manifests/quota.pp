# == Class: octavia::quota
#
# Setup and configure octavia quotas.
#
# === Parameters:
#
# [*default_load_balancer_quota*]
#   (optional) Default per project load balancer quota
#   Defaults to $::os_service_default
#
# [*default_listener_quota*]
#   (optional) Default per project listener quota.
#   Defaults to $::os_service_default
#
# [*default_member_quota*]
#   (optional)  Default per project member quota.
#   Defaults to $::os_service_default
#
# [*default_pool_quota*]
#   (optional)  Default per project pool quota.
#   Defaults to $::os_service_default
#
# [*default_health_monitor_quota*]
#   (optional) Default per project health monitor quota.
#   Defaults to $::os_service_default
#
# DEPRECATED PARAMETERS
#
# [*load_balancer_quota*]
#   (optional) Default per project load balancer quota
#   Defaults to undef
#
# [*listener_quota*]
#   (optional) Default per project listener quota.
#   Defaults to undef
#
# [*member_quota*]
#   (optional)  Default per project member quota.
#   Defaults to undef
#
# [*pool_quota*]
#   (optional)  Default per project pool quota.
#   Defaults to undef
#
# [*health_monitor_quota*]
#   (optional) Default per project health monitor quota.
#   Defaults to undef
#
class octavia::quota (
  $default_load_balancer_quota   = $::os_service_default,
  $default_listener_quota        = $::os_service_default,
  $default_member_quota          = $::os_service_default,
  $default_pool_quota            = $::os_service_default,
  $default_health_monitor_quota  = $::os_service_default,
  # DEPRECATED PARAMETERS
  $load_balancer_quota           = undef,
  $listener_quota                = undef,
  $member_quota                  = undef,
  $pool_quota                    = undef,
  $health_monitor_quota          = undef,
) {

  include octavia::deps

  [
    'load_balancer_quota',
    'listener_quota',
    'member_quota',
    'pool_quota',
    'health_monitor_quota'
  ].each |String $quota_opt| {
    if getvar("${quota_opt}") != undef {
      warning("The ${quota_opt} parameter is deprecated. Use the default_${quota_opt} parameter.")
    }
    octavia_config {
      "quotas/default_${quota_opt}": value => pick(getvar("${quota_opt}"), getvar("default_${quota_opt}"))
    }
  }

  # NOTE(tkajinam): Revert back to this implementation when we remove
  #                 the deprecated parameters.
  # octavia_config {
  #   'quotas/default_load_balancer_quota':  value => $load_balancer_quota;
  #   'quotas/default_listener_quota':       value => $listener_quota;
  #   'quotas/default_member_quota':         value => $member_quota;
  #   'quotas/default_pool_quota':           value => $pool_quota;
  #   'quotas/default_health_monitor_quota': value => $health_monitor_quota;
  # }
}
