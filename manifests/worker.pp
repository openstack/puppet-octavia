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
#    Defaults to $::os_service_default
#
# [*manage_nova_flavor*]
#   (optional) Whether or not manage Nova flavor for the Amphora.
#   Defaults to true.
#
# [*nova_flavor_config*]
#   (optional) Nova flavor config hash.
#   Should be an hash.
#   Exemple:
#   $nova_flavor_config = { 'ram' => '2048' }
#   Possible options are documented in puppet-nova nova_flavor type.
#   Defaults to {}.
#
# [*key_path*]
#   (optional) full path to the private key for the amphora SSH key
#   Defaults to '/etc/octavia/.ssh/octavia_ssh_key'
#
# [*manage_keygen*]
#   (optional) Whether or not create OpenStack keypair for communicating with amphora
#   Defaults to false
#
# [*amp_project_name*]
#   (optional) Set the project to be used for creating load balancer instances.
#   Defaults to undef
#
# DEPRECATED PARAMETERS
#
# [*amp_flavor_id*]
#   (optional) Nova instance flavor id for the Amphora.
#   Note: since we set manage_nova_flavor to True by default, we need
#   to set a valid amp_flavor_id by default, 65 was picked randomly.
#   Defaults to undef
#
# [*amp_image_tag*]
#   Glance image tag for Amphora image. Allows the Amphora image to be
#   referred to by a tag instead of an ID, allowing the Amphora image to
#   be updated without requiring reconfiguration of Octavia.
#   Defaults to undef
#
# [*amp_secgroup_list*]
#   List of security groups to use for Amphorae.
#   Defaults to undef
#
# [*amp_boot_network_list*]
#   List of networks to attach to Amphorae.
#   Defaults to undef
#
# [*loadbalancer_topology*]
#   (optional) Load balancer topology configuration
#   Defaults to undef
#
# [*amphora_driver*]
#   (optional) Name of driver for communicating with amphorae
#   Defaults to undef
#
# [*compute_driver*]
#   (optional) Name of driver for managing amphorae VMs
#   Defaults to undef
#
# [*network_driver*]
#   (optional) Name of network driver for configuring networking
#   for amphorae.
#   Defaults to undef
#
# [*amp_ssh_key_name*]
#   (optional) Name of Openstack SSH keypair for communicating with amphora
#   Defaults to undef
#
# [*enable_ssh_access*]
#   (optional) Enable SSH key configuration for amphorae. Note that setting
#   to false disables configuration of SSH key related properties.
#   Defaults to undef
#
# [*timeout_client_data*]
#   (optional) Frontend client inactivity timeout.
#   Defaults to undef
#
# [*timeout_member_connect*]
#   (optional) Backend member connection timeout.
#   Defaults to undef
#
# [*timeout_member_data*]
#   (optional) Backend member inactivity timeout.'
#   Defaults to undef
#
# [*timeout_tcp_inspect*]
#   (optional) Time to wait for TCP packets for content inspection.
#   Defaults to undef
#
class octavia::worker (
  $manage_service         = true,
  $enabled                = true,
  $package_ensure         = 'present',
  $workers                = $::os_service_default,
  $manage_nova_flavor     = true,
  $nova_flavor_config     = {},
  $key_path               = '/etc/octavia/.ssh/octavia_ssh_key',
  $manage_keygen          = false,
  $amp_project_name       = undef,
  # DEPRECATED PARAMETERS
  $amp_flavor_id          = undef,
  $amp_image_tag          = undef,
  $amp_secgroup_list      = undef,
  $amp_boot_network_list  = undef,
  $loadbalancer_topology  = undef,
  $amphora_driver         = undef,
  $compute_driver         = undef,
  $network_driver         = undef,
  $amp_ssh_key_name       = undef,
  $enable_ssh_access      = undef,
  $timeout_client_data    = undef,
  $timeout_member_connect = undef,
  $timeout_member_data    = undef,
  $timeout_tcp_inspect    = undef,
) inherits octavia::params {

  include ::octavia::deps
  include ::octavia::controller

  if ($amp_flavor_id or $amp_image_tag or $amp_secgroup_list or $amp_boot_network_list or $loadbalancer_topology or $amphora_driver or
      $compute_driver or $network_driver or $amp_ssh_key_name or $enable_ssh_access or $timeout_client_data or $timeout_member_connect or
      $timeout_member_data or $timeout_tcp_inspect ) {
    warning('The amp_flavor_id, amp_image_tag, amp_secgroup_list, amp_boot_network_list, loadbalancer_topology, amphora_driver,
             compute_driver, network_driver, amp_ssh_key_name, enable_ssh_access, timeout_member_connect, timeout_member_data and
	     timeout_tcp_inspect parameters are deprecated and have been moved to octavia::controller class. Please set them there.')
  }

  validate_hash($nova_flavor_config)

  if ! $::octavia::controller::amp_flavor_id_real {
    if $manage_nova_flavor {
      fail('When managing Nova flavor, octavia::controller::amp_flavor_id is required.')
    } else {
      warning('octavia::controller::amp_flavor_id is empty, Octavia Worker might not work correctly.')
    }
  } else {
    if $manage_nova_flavor {
      $octavia_flavor = { "octavia_${::octavia::controller::amp_flavor_id_real}" =>
        { 'id'      => $::octavia::controller::amp_flavor_id_real,
          'project' => $amp_project_name
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
      Nova_flavor<| tag == 'octavia' |> ~> Service['octavia-worker']
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
  }

  service { 'octavia-worker':
    ensure     => $service_ensure,
    name       => $::octavia::params::worker_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => ['octavia-service'],
  }

  if $manage_keygen and ! $::octavia::controller::enable_ssh_access_real {
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
      group  => 'octavia',
      owner  => 'octavia'
    }

    ssh_keygen { $::octavia::controller::amp_ssh_key_name_real:
      user     => 'octavia',
      type     => 'rsa',
      bits     => 2048,
      filename => "${key_path}/${::octavia::controller::amp_ssh_key_name_real}",
      comment  => 'Used for Octavia Service VM'
    }

    Package<| tag == 'octavia-package' |>
    -> Exec['create_amp_key_dir']
    -> File['amp_key_dir']
    -> Ssh_keygen[$::octavia::controller::amp_ssh_key_name_real]
  }

  octavia_config {
    'controller_worker/workers' : value => $workers;
  }
}
