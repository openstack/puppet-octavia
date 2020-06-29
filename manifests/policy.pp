# == Class: octavia::policy
#
# Configure the octavia policies
#
# === Parameters
#
# [*policies*]
#   (Optional) Set of policies to configure for octavia
#   Example :
#     {
#       'octavia-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'octavia-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the octavia policy.yaml file
#   Defaults to /etc/octavia/policy.yaml
#
class octavia::policy (
  $policies    = {},
  $policy_path = '/etc/octavia/policy.yaml',
) {

  include octavia::deps
  include octavia::params

  validate_legacy(Hash, 'validate_hash', $policies)

  Openstacklib::Policy::Base {
    file_path   => $policy_path,
    file_user   => 'root',
    file_group  => $::octavia::params::group,
    file_format => 'yaml',
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'octavia_config': policy_file => $policy_path }

}
