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
          :amp_flavor_id         => '42',
          :amp_image_tag         => 'amphorae1',
          :amp_boot_network_list => ['lbnet1', 'lbnet2'],
          :loadbalancer_topology => 'SINGLE',
        })
      end

      it { is_expected.to contain_octavia_config('controller_worker/amp_flavor_id').with_value('42') }
      it { is_expected.to contain_octavia_config('controller_worker/amp_image_tag').with_value('amphorae1') }
      it { is_expected.to contain_octavia_config('controller_worker/amp_boot_network_list').with_value(['lbnet1', 'lbnet2']) }
      it { is_expected.to contain_octavia_config('controller_worker/loadbalancer_topology').with_value('SINGLE') }
    end

    it 'configures worker parameters' do
      is_expected.to contain_octavia_config('controller_worker/amp_flavor_id').with_value('65')
      is_expected.to contain_octavia_config('controller_worker/amphora_driver').with_value('amphora_haproxy_rest_driver')
      is_expected.to contain_octavia_config('controller_worker/compute_driver').with_value('compute_nova_driver')
      is_expected.to contain_octavia_config('controller_worker/network_driver').with_value('allowed_address_pairs_driver')
    end

    it 'deploys nova flavor for octavia worker' do
      is_expected.to contain_nova_flavor('octavia_65').with(
        :ensure => 'present',
        :id     => '65',
        :ram    => '1024',
        :disk   => '2',
        :vcpus  => '1',
        :tag    => ['octavia'],
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
          :enabled        => false })
      end

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

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
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
