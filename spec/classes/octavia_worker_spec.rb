require 'spec_helper'

describe 'octavia::worker' do

  let :pre_condition do
    'include nova'
  end

  let :params do
    { :enabled        => true,
      :manage_service => true,
      :package_ensure => 'latest',
    }
  end

  shared_examples_for 'octavia-worker' do

    let :pre_condition do
      "include nova
       class { 'octavia::controller' :
         heartbeat_key => 'abcdefghi',
       }"
    end

    context 'configured with specific parameters' do
      let :pre_condition do
        "include nova
         class { 'octavia::controller' :
           amp_flavor_id => '42',
           heartbeat_key => 'abcdefghi',
         }"
      end

      before do
        params.merge!({
          :workers               => 8,
          :key_path              => '/opt/octavia/ssh/amphora_key',
          :nova_flavor_config    => {
            'ram'     => '2048',
            'disk'    => '3',
            'vcpus'   => '4'
          }
        })
      end

      it { is_expected.to contain_octavia_config('controller_worker/workers').with_value(8) }
      it 'deploys a nova flavor for amphora' do
        is_expected.to contain_nova_flavor('octavia_42').with(
          :ensure       => 'present',
          :id           => '42',
          :ram          => '2048',
          :disk         => '3',
          :vcpus        => '4',
          :is_public    => false,
          :project_name => 'services',
          :tag          => ['octavia'],
        )
      end
    end

    context 'with ssh key access disabled and key management enabled' do
      let :pre_condition do
        "include nova
         class { 'octavia::controller' :
           enable_ssh_access => false,
           heartbeat_key     => 'abcdefghi',
         }"
      end

      before do
        params.merge!({
          :manage_keygen => true,
        })
      end

      it "raises an error" do
        is_expected.to raise_error(Puppet::Error)
      end
    end

    it 'deploys nova flavor for octavia worker' do
      is_expected.to contain_nova_flavor('octavia_65').with(
        :ensure       => 'present',
        :id           => '65',
        :ram          => '1024',
        :disk         => '2',
        :vcpus        => '1',
        :is_public    => false,
        :project_name => 'services',
        :tag          => ['octavia'],
      )
    end

    it 'installs octavia-worker package' do
      is_expected.to contain_package('octavia-worker').with(
        :ensure => 'latest',
        :name   => platform_params[:worker_package_name],
        :tag    => ['openstack', 'octavia-package'],
      )
    end

    [{:enabled => true}, {:enabled => false}].each do |param_hash|
      context "when service should be #{param_hash[:enabled] ? 'enabled' : 'disabled'}" do
        before do
          params.merge!(param_hash)
        end

        it 'configures octavia-worker service' do
          is_expected.to contain_service('octavia-worker').with(
            :ensure     => (params[:manage_service] && params[:enabled]) ? 'running' : 'stopped',
            :name       => platform_params[:worker_service_name],
            :enable     => params[:enabled],
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => ['octavia-service'],
          )
        end
      end
    end

    context 'with disabled service managing' do
      before do
        params.merge!({
          :manage_service => false,
          :enabled        => false
        })
      end

      it 'does not configure octavia-worker service' do
        is_expected.to_not contain_service('octavia-worker')
      end
    end

    context 'with enabled sshkey gen(rsa)' do
      before do
        params.merge!({
          :manage_keygen => true,
          :key_path      => '/etc/octavia/.ssh/octavia_ssh_key'
        })
      end

      it 'configures ssh_keygen and directory' do
        is_expected.to contain_exec('create_amp_key_dir').with(
          :path    => ['/bin', '/usr/bin'],
          :command => 'mkdir -p /etc/octavia/.ssh/octavia_ssh_key',
          :creates => '/etc/octavia/.ssh/octavia_ssh_key'
        )

        is_expected.to contain_file('amp_key_dir').with(
          :ensure  => 'directory',
          :path    => '/etc/octavia/.ssh/octavia_ssh_key',
          :mode    => '0700',
          :group   => 'octavia',
          :owner   => 'octavia'
        )

        is_expected.to contain_ssh_keygen('octavia-ssh-key').with(
          :user     => 'octavia',
          :type     => 'rsa',
          :bits     => 2048,
          :filename => '/etc/octavia/.ssh/octavia_ssh_key/octavia-ssh-key',
          :comment  => 'Used for Octavia Service VM',
        )
      end
    end

    context 'with enabled sshkey gen(ecdsa)' do
      before do
        params.merge!({
          :manage_keygen => true,
          :key_path      => '/etc/octavia/.ssh/octavia_ssh_key',
          :ssh_key_type  => 'ecdsa',
          :ssh_key_bits  => 256,
        })
      end

      it 'configures ssh_keygen and directory' do
        is_expected.to contain_exec('create_amp_key_dir').with(
          :path    => ['/bin', '/usr/bin'],
          :command => 'mkdir -p /etc/octavia/.ssh/octavia_ssh_key',
          :creates => '/etc/octavia/.ssh/octavia_ssh_key'
        )

        is_expected.to contain_file('amp_key_dir').with(
          :ensure  => 'directory',
          :path    => '/etc/octavia/.ssh/octavia_ssh_key',
          :mode    => '0700',
          :group   => 'octavia',
          :owner   => 'octavia'
        )

        is_expected.to contain_ssh_keygen('octavia-ssh-key').with(
          :user     => 'octavia',
          :type     => 'ecdsa',
          :bits     => 256,
          :filename => '/etc/octavia/.ssh/octavia_ssh_key/octavia-ssh-key',
          :comment  => 'Used for Octavia Service VM',
        )
      end
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({:os_workers => 4}))
      end
      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :worker_package_name => 'octavia-worker',
            :worker_service_name => 'octavia-worker' }
        when 'RedHat'
          { :worker_package_name => 'openstack-octavia-worker',
            :worker_service_name => 'octavia-worker' }
        end
      end
      it_behaves_like 'octavia-worker'
    end
  end

end
