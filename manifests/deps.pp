# == Class: octavia::deps
#
#  Octavia anchors and dependency management
#
class octavia::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'octavia::install::begin': }
  -> Package<| tag == 'octavia-package'|>
  ~> anchor { 'octavia::install::end': }
  -> anchor { 'octavia::config::begin': }
  -> Octavia_config<||>
  ~> anchor { 'octavia::config::end': }
  -> anchor { 'octavia::certificate::begin': }
  -> File<| tag == 'octavia-certificate' |>
  ~> anchor { 'octavia::certificate::end': }
  -> anchor { 'octavia::db::begin': }
  -> anchor { 'octavia::db::end': }
  ~> anchor { 'octavia::dbsync::begin': }
  -> anchor { 'octavia::dbsync::end': }
  ~> anchor { 'octavia::service::begin': }
  ~> Service<| tag == 'octavia-service' |>
  ~> anchor { 'octavia::service::end': }

  Anchor['octavia::config::begin']
  -> Octavia_api_uwsgi_config<||>
  -> Anchor['octavia::config::end']

  # Installation or config changes will always restart services.
  Anchor['octavia::install::end'] ~> Anchor['octavia::service::begin']
  Anchor['octavia::config::end']  ~> Anchor['octavia::service::begin']

  # Changes in certificate or folders will restart services.
  Anchor['octavia::certificate::end'] ~> Anchor['octavia::service::begin']
}
