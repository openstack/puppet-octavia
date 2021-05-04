require 'spec_helper'

describe 'octavia::api' do
  let :params do
    { :enabled                        => true,
      :manage_service                 => true,
      :package_ensure                 => 'latest',
      :port                           => '9876',
      :host                           => '0.0.0.0',
      :api_handler                    => 'queue_producer',
      :api_v1_enabled                 => true,
      :api_v2_enabled                 => true,
      :allow_tls_terminated_listeners => false,
      :default_provider_driver        => 'ovn',
      :provider_drivers               => { 'amphora' => 'Octavia Amphora Driver', 'ovn' => 'Octavia OVN driver' },
      :pagination_max_limit           => '1000',
      :healthcheck_enabled            => true,
      :healthcheck_refresh_interval   => 5,
    }
  end

  shared_examples_for 'octavia-api' do
    let :pre_condition do
      "class { 'octavia': }
       include octavia::db
       class { 'octavia::keystone::authtoken':
         password  => 'password',
       }
      "
    end

    it { is_expected.to contain_class('octavia::deps') }
    it { is_expected.to contain_class('octavia::params') }
    it { is_expected.to contain_class('octavia::policy') }
    it { is_expected.to contain_class('octavia::keystone::authtoken') }

    it 'installs octavia-api package' do
      is_expected.to contain_package('octavia-api').with(
        :ensure => 'latest',
        :name   => platform_params[:api_package_name],
        :tag    => ['openstack', 'octavia-package'],
      )
    end

    context 'when not parameters are defined' do
      before do
        params.clear()
      end
      it 'configures with default values' do
        is_expected.to contain_octavia_config('api_settings/bind_host').with_value( '0.0.0.0' )
        is_expected.to contain_octavia_config('api_settings/bind_port').with_value( '9876' )
        is_expected.to contain_octavia_config('api_settings/auth_strategy').with_value( 'keystone' )
        is_expected.to contain_octavia_config('api_settings/api_handler').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('api_settings/api_v1_enabled').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('api_settings/api_v2_enabled').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('api_settings/allow_tls_terminated_listeners').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('api_settings/default_provider_driver').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('api_settings/enabled_provider_drivers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('api_settings/pagination_max_limit').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('api_settings/healthcheck_enabled').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('api_settings/healthcheck_refresh_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_oslo__middleware('octavia_config').with(
          :enable_proxy_headers_parsing => '<SERVICE DEFAULT>',
        )
      end
      it 'does not sync the database' do
        is_expected.not_to contain_class('octavia::db::sync')
      end
    end

    it 'configures bind_host and bind_port' do
      is_expected.to contain_octavia_config('api_settings/bind_host').with_value( params[:host] )
      is_expected.to contain_octavia_config('api_settings/bind_port').with_value( params[:port] )
      is_expected.to contain_octavia_config('api_settings/api_handler').with_value( params[:api_handler] )
      is_expected.to contain_octavia_config('api_settings/api_v1_enabled').with_value( params[:api_v1_enabled] )
      is_expected.to contain_octavia_config('api_settings/api_v2_enabled').with_value( params[:api_v2_enabled] )
      is_expected.to contain_octavia_config('api_settings/allow_tls_terminated_listeners').with_value( params[:allow_tls_terminated_listeners] )
      is_expected.to contain_octavia_config('api_settings/default_provider_driver').with_value( params[:default_provider_driver] )
      is_expected.to contain_octavia_config('api_settings/enabled_provider_drivers').with_value( params[:provider_drivers] )
      is_expected.to contain_octavia_config('api_settings/pagination_max_limit').with_value( params[:pagination_max_limit] )
      is_expected.to contain_octavia_config('api_settings/healthcheck_enabled').with_value( params[:healthcheck_enabled] )
      is_expected.to contain_octavia_config('api_settings/healthcheck_refresh_interval').with_value( params[:healthcheck_refresh_interval] )
    end

    [{:enabled => true}, {:enabled => false}].each do |param_hash|
      context "when service should be #{param_hash[:enabled] ? 'enabled' : 'disabled'}" do
        before do
          params.merge!(param_hash)
        end

        it 'configures octavia-api service' do
          is_expected.to contain_service('octavia-api').with(
            :ensure     => (params[:manage_service] && params[:enabled]) ? 'running' : 'stopped',
            :name       => platform_params[:api_service_name],
            :enable     => params[:enabled],
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => ['octavia-service', 'octavia-db-sync-service'],
          )
        end
        it { is_expected.to contain_service('octavia-api').that_subscribes_to('Anchor[octavia::service::begin]')}
        it { is_expected.to contain_service('octavia-api').that_notifies('Anchor[octavia::service::end]')}
      end
    end

    context 'with sync_db set to true' do
      before do
        params.merge!({
          :sync_db => true})
      end
      it { is_expected.to contain_class('octavia::db::sync') }
    end

    context 'with enable_proxy_headers_parsing set' do
      before do
        params.merge!({
          :enable_proxy_headers_parsing => true})
      end
      it 'configures enable_proxy_headers_parsing' do
        is_expected.to contain_oslo__middleware('octavia_config').with(
          :enable_proxy_headers_parsing => true,
        )
      end
    end

    context 'with disabled service managing' do
      before do
        params.merge!({
          :manage_service => false,
          :enabled        => false })
      end

      it 'configures octavia-api service' do
        is_expected.to_not contain_service('octavia-api')
      end
    end

    context 'with healthcheck enabled' do
      before do
        params.merge!({
          :healthcheck_enabled => true })
      end

      it 'configures healthcheck_enabled' do
        is_expected.to contain_octavia_config('api_settings/healthcheck_enabled').with_value(true)
      end
    end
  end

  shared_examples 'octavia-api wsgi' do
    let :pre_condition do
      "class { 'octavia': }
       include octavia::db
       class { 'octavia::keystone::authtoken':
         password  => 'password',
       }
       include apache
      "
    end

    let :params do
      {
        :service_name => 'httpd',
      }
    end

    context 'with required params' do
      it { should contain_package('octavia-api').with(
        :ensure => 'present',
        :name   => platform_params[:api_package_name],
        :tag    => ['openstack', 'octavia-package'],
      )}

      it { should contain_service('octavia-api').with(
        :ensure => 'stopped',
        :name   => platform_params[:api_service_name],
        :enable => false,
        :tag    => ['octavia-service', 'octavia-db-sync-service'],
      )}
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
          { :api_package_name => 'octavia-api',
            :api_service_name => 'octavia-api' }
        when 'RedHat'
          { :api_package_name => 'openstack-octavia-api',
            :api_service_name => 'octavia-api' }
        end
      end

      it_behaves_like 'octavia-api'
      it_behaves_like 'octavia-api wsgi'
    end
  end

end
