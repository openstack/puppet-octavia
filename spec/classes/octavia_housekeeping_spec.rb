require 'spec_helper'

describe 'octavia::housekeeping' do

  let :params do
    { :enabled        => true,
      :manage_service => true,
      :package_ensure => 'latest',
    }
  end

  shared_examples_for 'octavia-housekeeping' do

    it 'installs octavia-housekeeping package' do
      is_expected.to contain_package('octavia-housekeeping').with(
        :ensure => 'latest',
        :name   => platform_params[:housekeeping_package_name],
        :tag    => ['openstack', 'octavia-package'],
      )
    end

    context 'check parameters with defaults' do
      ['cleanup_interval', 'amphora_expiry_age', 'load_balancer_expiry_age',
       'cert_interval', 'cert_expiry_buffer', 'cert_rotate_threads'].each do |param_with_default|
         it { is_expected.to contain_octavia_config("house_keeping/#{param_with_default}").with_value('<SERVICE DEFAULT>') }
      end
    end

    let :default_parameters do
      { :cleanup_interval          => 26,
        :amphora_expiry_age        => 200000,
        :load_balancer_expiry_age  => 23131,
        :cert_interval             => 200,
        :cert_expiry_buffer        => 20000056,
        :cert_rotate_threads       => 20,
      }
    end

    context 'check with non-default parameters' do
      before :each do
        params.merge!(default_parameters)
      end
      ['cleanup_interval', 'amphora_expiry_age', 'load_balancer_expiry_age',
       'cert_interval', 'cert_expiry_buffer', 'cert_rotate_threads'].each do |param_with_default|
         it { is_expected.to contain_octavia_config("house_keeping/#{param_with_default}").with_value(default_parameters[param_with_default.to_sym]) }
      end
    end


    [{:enabled => true}, {:enabled => false}].each do |param_hash|
      context "when service should be #{param_hash[:enabled] ? 'enabled' : 'disabled'}" do
        before do
          params.merge!(param_hash)
        end

        it 'configures octavia-housekeeping service' do
          is_expected.to contain_service('octavia-housekeeping').with(
            :ensure     => (params[:manage_service] && params[:enabled]) ? 'running' : 'stopped',
            :name       => platform_params[:housekeeping_service_name],
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

      it 'does not configure octavia-housekeeping service' do
        is_expected.to_not contain_service('octavia-housekeeping')
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
        case facts[:os]['family']
        when 'Debian'
          { :housekeeping_package_name => 'octavia-housekeeping',
            :housekeeping_service_name => 'octavia-housekeeping' }
        when 'RedHat'
          { :housekeeping_package_name => 'openstack-octavia-housekeeping',
            :housekeeping_service_name => 'octavia-housekeeping' }
        end
      end
      it_behaves_like 'octavia-housekeeping'
    end
  end

end
