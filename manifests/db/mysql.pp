# The octavia::db::mysql class implements mysql backend for octavia
#
# This class can be used to create tables, users and grant
# privilege for a mysql octavia database.
#
# == Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'octavia'.
#
# [*persistence_dbname*]
#   (Optional) Name of the database dedicated to task_flow persistence.
#   Defaults to 'undef'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'octavia'.
#
# [*host*]
#   (Optional) The default source host user is allowed to connect from.
#   Defaults to '127.0.0.1'
#
# [*allowed_hosts*]
#   (Optional) Other hosts the user is allowed to connect from.
#   Defaults to 'undef'.
#
# [*charset*]
#   (Optional) The database charset.
#   Defaults to 'utf8'
#
# [*collate*]
#   (Optional) The database collate.
#   Only used with mysql modules >= 2.2.
#   Defaults to 'utf8_general_ci'
#
class octavia::db::mysql(
  String[1] $password,
  $dbname             = 'octavia',
  $persistence_dbname = undef,
  $user               = 'octavia',
  $host               = '127.0.0.1',
  $charset            = 'utf8',
  $collate            = 'utf8_general_ci',
  $allowed_hosts      = undef
) {

  include octavia::deps

  ::openstacklib::db::mysql { 'octavia':
    user          => $user,
    password      => $password,
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  if $persistence_dbname {
    ::openstacklib::db::mysql { 'octavia_persistence':
      user          => $user,
      password      => $password,
      dbname        => $persistence_dbname,
      host          => $host,
      charset       => $charset,
      collate       => $collate,
      allowed_hosts => $allowed_hosts,
      create_user   => false,
    }
  }

  Anchor['octavia::db::begin']
  ~> Class['octavia::db::mysql']
  ~> Anchor['octavia::db::end']

}
