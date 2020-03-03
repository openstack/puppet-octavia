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

    context 'with invalid lb topology' do
      before do
        params.merge!({
          :loadbalancer_topology => 'foo'
        })
      end
      it { is_expected.to raise_error(Puppet::Error) }
    end

    context 'configured with specific parameters' do
      before do
        params.merge!({
          :workers               => 8,
          :amp_flavor_id         => '42',
          :amp_image_tag         => 'amphorae1',
          :amp_secgroup_list     => ['lb-mgmt-sec-grp'],
          :amp_boot_network_list => ['lbnet1', 'lbnet2'],
          :loadbalancer_topology => 'SINGLE',
          :amp_ssh_key_name      => 'custom-amphora-key',
          :key_path              => '/opt/octavia/ssh/amphora_key',
          :amp_project_name      => 'loadbalancers',
          :nova_flavor_config    => {
            'ram'     => '2048',
            'disk'    => '3',
            'vcpus'   => '4'
          }
        })
      end

      it { is_expected.to contain_octavia_config('controller_worker/workers').with_value(8) }
      it { is_expected.to contain_octavia_config('controller_worker/amp_flavor_id').with_value('42') }
      it { is_expected.to contain_octavia_config('controller_worker/amp_image_tag').with_value('amphorae1') }
      it { is_expected.to contain_octavia_config('controller_worker/amp_secgroup_list').with_value(['lb-mgmt-sec-grp']) }
      it { is_expected.to contain_octavia_config('controller_worker/amp_boot_network_list').with_value(['lbnet1', 'lbnet2']) }
      it { is_expected.to contain_octavia_config('controller_worker/loadbalancer_topology').with_value('SINGLE') }
      it { is_expected.to contain_octavia_config('controller_worker/amp_ssh_key_name').with_value('custom-amphora-key') }
      it 'deploys a nova flavor for amphora' do
        is_expected.to contain_nova_flavor('octavia_42').with(
          :ensure    => 'present',
          :id        => '42',
          :ram       => '2048',
          :disk      => '3',
          :vcpus     => '4',
          :is_public => false,
          :project   => 'loadbalancers',
          :tag       => ['octavia'],
        )
      end
    end

    it 'configures worker parameters' do
      is_expected.to contain_octavia_config('controller_worker/workers').with_value(4)
      is_expected.to contain_octavia_config('controller_worker/amp_flavor_id').with_value('65')
      is_expected.to contain_octavia_config('controller_worker/amphora_driver').with_value('amphora_haproxy_rest_driver')
      is_expected.to contain_octavia_config('controller_worker/compute_driver').with_value('compute_nova_driver')
      is_expected.to contain_octavia_config('controller_worker/network_driver').with_value('allowed_address_pairs_driver')
      is_expected.to contain_octavia_config('controller_worker/amp_ssh_key_name').with_value('octavia-ssh-key')
      is_expected.to contain_octavia_config('haproxy_amphora/timeout_client_data').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_octavia_config('haproxy_amphora/timeout_member_connect').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_octavia_config('haproxy_amphora/timeout_member_data').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_octavia_config('haproxy_amphora/timeout_tcp_inspect').with_value('<SERVICE DEFAULT>')
    end

    context 'with ssh key access disabled' do
      before do
        params.merge!({ :enable_ssh_access => false }) end

      it 'disables configuration of SSH key properties' do
        is_expected.to contain_octavia_config('controller_worker/amp_ssh_key_name').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with ssh key access disabled and key management enabled' do
      before do
        params.merge!({
          :enable_ssh_access => false,
          :manage_keygen     => true,
        })
      end

      it "raises an error" do
        is_expected.to raise_error(Puppet::Error)
      end
    end

    it 'deploys nova flavor for octavia worker' do
      is_expected.to contain_nova_flavor('octavia_65').with(
        :ensure    => 'present',
        :id        => '65',
        :ram       => '1024',
        :disk      => '2',
        :vcpus     => '1',
        :is_public => false,
        :tag       => ['octavia'],
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
        params.merge!({ :manage_service => false, :enabled        => false }) end

      it 'configures octavia-worker service' do
        is_expected.to contain_service('octavia-worker').with(
          :ensure     => nil,
          :name       => platform_params[:worker_service_name],
          :enable     => false,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => ['octavia-service'],
        )
      end
    end

    context 'with enabled sshkey gen' do
      before do
        params.merge!({
          :manage_keygen => true,
          :key_path      => '/etc/octavia/.ssh/octavia_ssh_key'})
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
