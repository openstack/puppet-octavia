# == Class: octavia::db::postgresql
#
# Class that configures postgresql for octavia
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'octavia'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'octavia'.
#
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
# == Dependencies
#
# == Examples
#
# == Authors
#
# == Copyright
#
class octavia::db::postgresql(
  $password,
  $dbname     = 'octavia',
  $user       = 'octavia',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  Class['octavia::db::postgresql'] -> Service<| title == 'octavia' |>

  ::openstacklib::db::postgresql { 'octavia':
    password_hash => postgresql_password($user, $password),
    dbname        => $dbname,
    user          => $user,
    encoding      => $encoding,
    privileges    => $privileges,
  }

  ::Openstacklib::Db::Postgresql['octavia'] ~> Exec<| title == 'octavia-manage db_sync' |>

}
