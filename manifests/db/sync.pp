#
# Class to execute octavia-db-manage upgrade head
#
# == Parameters
#
# [*extra_params*]
#   (Optional) String of extra command line parameters to append
#   to the octavia-db-manage command.
#   Defaults to undef
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class octavia::db::sync (
  $extra_params    = undef,
  $db_sync_timeout = 300,
) {
  include octavia::deps
  include octavia::params

  exec { 'octavia-db-sync':
    command     => "octavia-db-manage upgrade head ${extra_params}",
    path        => '/usr/bin',
    user        => $octavia::params::user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['octavia::install::end'],
      Anchor['octavia::config::end'],
      Anchor['octavia::dbsync::begin']
    ],
    notify      => Anchor['octavia::dbsync::end'],
    tag         => 'openstack-db',
  }
}
