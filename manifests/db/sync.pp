#
# Class to execute octavia-db-manage upgrade head
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
    command     => "octavia-db-manage upgrade head ${extra_params}",
    path        => '/usr/bin',
    user        => 'octavia',
    refreshonly => true,
    subscribe   => [Package['octavia'], Octavia_config['database/connection']],
  }

  Exec['octavia-db-sync'] ~> Service<| tag == 'octavia-db-sync-service' |>
}
