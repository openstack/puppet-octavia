# Installs & configure the octavia controller worker service
#
# == Parameters
#
# [*enabled*]
#   (optional) Should the service be enabled.
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*package_ensure*]
#   (optional) ensure state for package.
#   Defaults to 'present'
#
# [*workers*]
#   (optional) Number of worker processes.
#    Defaults to $facts['os_workers']
#
# [*manage_nova_flavor*]
#   (optional) Whether or not manage Nova flavor for the Amphora.
#   Defaults to true.
#
# [*nova_flavor_config*]
#   (optional) Nova flavor config hash.
#   Should be an hash.
#   Example:
#   $nova_flavor_config = { 'ram' => '2048' }
#   Possible options are documented in puppet-nova nova_flavor type.
#   Defaults to {}.
#
# [*key_path*]
#   (optional) full path to the private key for the amphora SSH key
#   Defaults to '/etc/octavia/.ssh/octavia_ssh_key'
#
# [*manage_keygen*]
#   (optional) Whether or not create OpenStack keypair for communicating with
#   amphora.
#   Defaults to false
#
# [*ssh_key_type*]
#   (optional) Type of ssh key to create.
#   Defaults to 'rsa'
#
# [*ssh_key_bits*]
#   (optional) Number of bits in ssh key.
#   Defaults to 2048
#
# [*amp_project_name*]
#   (optional) Set the project to be used for creating load balancer instances.
#   Defaults to 'services'
#
class octavia::worker (
  $manage_service         = true,
  $enabled                = true,
  $package_ensure         = 'present',
  $workers                = $facts['os_workers'],
  $manage_nova_flavor     = true,
  $nova_flavor_config     = {},
  $key_path               = '/etc/octavia/.ssh/octavia_ssh_key',
  $manage_keygen          = false,
  $ssh_key_type           = 'rsa',
  $ssh_key_bits           = 2048,
  $amp_project_name       = 'services',
) inherits octavia::params {

  include octavia::deps
  include octavia::controller

  validate_legacy(Hash, 'validate_hash', $nova_flavor_config)

  if ! $::octavia::controller::amp_flavor_id {
    if $manage_nova_flavor {
      fail('When managing Nova flavor, octavia::controller::amp_flavor_id is required.')
    } else {
      warning('octavia::controller::amp_flavor_id is empty, Octavia Worker might not work correctly.')
    }
  } else {
    if $manage_nova_flavor {
      $octavia_flavor = { "octavia_${::octavia::controller::amp_flavor_id}" =>
        { 'id'           => $::octavia::controller::amp_flavor_id,
          'project_name' => $amp_project_name
        }
      }

      $octavia_flavor_defaults = {
        'ensure'    => 'present',
        'ram'       => '1024',
        'disk'      => '2',
        'vcpus'     => '1',
        'is_public' => false,
        'tag'       => ['octavia']
      }
      $nova_flavor_defaults = merge($octavia_flavor_defaults, $nova_flavor_config)
      create_resources('nova_flavor', $octavia_flavor, $nova_flavor_defaults)
      if $manage_service {
        Nova_flavor<| tag == 'octavia' |> ~> Service['octavia-worker']
      }
    }
  }

  package { 'octavia-worker':
    ensure => $package_ensure,
    name   => $::octavia::params::worker_package_name,
    tag    => ['openstack', 'octavia-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    service { 'octavia-worker':
      ensure     => $service_ensure,
      name       => $::octavia::params::worker_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => ['octavia-service'],
    }
  }

  if $manage_keygen and ! $::octavia::controller::enable_ssh_access {
    fail('SSH key management cannot be enabled when SSH key access is disabled')
  }

  if $manage_keygen {
    exec {'create_amp_key_dir':
      path    => ['/bin', '/usr/bin'],
      command => "mkdir -p ${key_path}",
      creates => $key_path
    }

    file { 'amp_key_dir':
      ensure => directory,
      path   => $key_path,
      mode   => '0700',
      group  => $::octavia::params::group,
      owner  => $::octavia::params::user
    }

    ssh_keygen { $::octavia::controller::amp_ssh_key_name:
      user     => $::octavia::params::user,
      type     => $ssh_key_type,
      bits     => $ssh_key_bits,
      filename => "${key_path}/${::octavia::controller::amp_ssh_key_name}",
      comment  => 'Used for Octavia Service VM'
    }

    Package<| tag == 'octavia-package' |>
    -> Exec['create_amp_key_dir']
    -> File['amp_key_dir']
    -> Ssh_keygen[$::octavia::controller::amp_ssh_key_name]
  }

  octavia_config {
    'controller_worker/workers' : value => $workers;
  }
}
