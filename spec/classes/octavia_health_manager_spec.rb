require 'spec_helper'

describe 'octavia::health_manager' do

  let :params do
    { :enabled        => true,
      :manage_service => true,
      :package_ensure => 'latest',
    }
  end

  shared_examples_for 'octavia-health-manager' do

    let :pre_condition do
      "include nova
       class { 'octavia::controller' :
         heartbeat_key => 'abcdefghi',
       }"
    end

    context 'with minimal parameters' do
      it { is_expected.to contain_octavia_config('health_manager/health_update_threads').with_value('4') }
      it { is_expected.to contain_octavia_config('health_manager/stats_update_threads').with_value('4') }
      it { is_expected.to contain_octavia_config('health_manager/failover_threads').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('health_manager/heartbeat_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('health_manager/health_check_interval').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('health_manager/sock_rlimit').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('health_manager/failover_threshold').with_value('<SERVICE DEFAULT>') }
    end

    it 'installs octavia-health-manager package' do
      is_expected.to contain_package('octavia-health-manager').with(
        :ensure => 'latest',
        :name   => platform_params[:health_manager_package_name],
        :tag    => ['openstack', 'octavia-package'],
      )
    end

    [{:enabled => true}, {:enabled => false}].each do |param_hash|
      context "when service should be #{param_hash[:enabled] ? 'enabled' : 'disabled'}" do
        before do
          params.merge!(param_hash)
        end

        it 'configures octavia-health-manager service' do
          is_expected.to contain_service('octavia-health-manager').with(
            :ensure     => (params[:manage_service] && params[:enabled]) ? 'running' : 'stopped',
            :name       => platform_params[:health_manager_service_name],
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

      it 'does not configure octavia-health-manager service' do
        is_expected.to_not contain_service('octavia-health-manager')
      end
    end

    context 'with host and port default values' do
      it { is_expected.to contain_octavia_config('health_manager/bind_ip').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('health_manager/bind_port').with_value('<SERVICE DEFAULT>') }
    end

    context 'with host and port values override' do
      before do
        params.merge!({
          :ip   => '10.0.0.15',
          :port => '5555'})
      end

        it { is_expected.to contain_octavia_config('health_manager/bind_ip').with_value('10.0.0.15') }
        it { is_expected.to contain_octavia_config('health_manager/bind_port').with_value('5555') }
    end

    context 'configured with specific parameters' do
      before do
        params.merge!({
          :health_update_threads => 8,
          :stats_update_threads  => 12,
          :failover_threads      => 10,
          :heartbeat_timeout     => 60,
          :health_check_interval => 3,
          :sock_rlimit           => 1,
          :failover_threshold    => 2,
        })
      end
      it { is_expected.to contain_octavia_config('health_manager/health_update_threads').with_value(8) }
      it { is_expected.to contain_octavia_config('health_manager/stats_update_threads').with_value(12) }
      it { is_expected.to contain_octavia_config('health_manager/failover_threads').with_value(10) }
      it { is_expected.to contain_octavia_config('health_manager/heartbeat_timeout').with_value(60) }
      it { is_expected.to contain_octavia_config('health_manager/health_check_interval').with_value(3) }
      it { is_expected.to contain_octavia_config('health_manager/sock_rlimit').with_value(1) }
      it { is_expected.to contain_octavia_config('health_manager/failover_threshold').with_value(2) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :os_workers => 4 }))
      end
      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :health_manager_package_name => 'octavia-health-manager',
            :health_manager_service_name => 'octavia-health-manager' }
        when 'RedHat'
          { :health_manager_package_name => 'openstack-octavia-health-manager',
            :health_manager_service_name => 'octavia-health-manager' }
        end
      end
      it_behaves_like 'octavia-health-manager'
    end
  end

end
