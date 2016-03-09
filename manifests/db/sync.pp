#
# Class to execute octavia-manage db_sync
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the octavia-dbsync command.
#   Defaults to undef
#
class octavia::db::sync(
  $extra_params  = undef,
) {
  exec { 'octavia-db-sync':
    command     => "octavia-manage db_sync ${extra_params}",
    path        => '/usr/bin',
    user        => 'octavia',
    refreshonly => true,
    subscribe   => [Package['octavia'], Octavia_config['database/connection']],
  }

  Exec['octavia-manage db_sync'] ~> Service<| title == 'octavia' |>
}
