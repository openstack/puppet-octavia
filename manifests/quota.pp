# == Class: octavia::quota
#
# Setup and configure octavia quotas.
#
# === Parameters:
#
# [*default_load_balancer_quota*]
#   (optional) Default per project load balancer quota
#   Defaults to $facts['os_service_default']
#
# [*default_listener_quota*]
#   (optional) Default per project listener quota.
#   Defaults to $facts['os_service_default']
#
# [*default_member_quota*]
#   (optional)  Default per project member quota.
#   Defaults to $facts['os_service_default']
#
# [*default_pool_quota*]
#   (optional)  Default per project pool quota.
#   Defaults to $facts['os_service_default']
#
# [*default_health_monitor_quota*]
#   (optional) Default per project health monitor quota.
#   Defaults to $facts['os_service_default']
#
# [*default_l7policy_quota*]
#   (optional) Default per project l7policy quota.
#   Defaults to $facts['os_service_default']
#
# [*default_l7rule_quota*]
#   (optional) Default per project l7rule quota.
#   Defaults to $facts['os_service_default']
#
class octavia::quota (
  $default_load_balancer_quota   = $facts['os_service_default'],
  $default_listener_quota        = $facts['os_service_default'],
  $default_member_quota          = $facts['os_service_default'],
  $default_pool_quota            = $facts['os_service_default'],
  $default_health_monitor_quota  = $facts['os_service_default'],
  $default_l7policy_quota        = $facts['os_service_default'],
  $default_l7rule_quota          = $facts['os_service_default'],
) {

  include octavia::deps

  octavia_config {
    'quotas/default_load_balancer_quota':  value => $default_load_balancer_quota;
    'quotas/default_listener_quota':       value => $default_listener_quota;
    'quotas/default_member_quota':         value => $default_member_quota;
    'quotas/default_pool_quota':           value => $default_pool_quota;
    'quotas/default_health_monitor_quota': value => $default_health_monitor_quota;
    'quotas/default_l7policy_quota':       value => $default_l7policy_quota;
    'quotas/default_l7rule_quota':         value => $default_l7rule_quota;
  }
}
