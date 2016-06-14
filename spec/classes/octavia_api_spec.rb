require 'spec_helper'

describe 'octavia::api' do

  let :pre_condition do
    "class { 'octavia': }
     include ::octavia::db"
  end

  let :params do
    { :enabled           => true,
      :manage_service    => true,
      :keystone_auth_uri => 'http://127.0.0.0:5000',
      :keystone_password => 'octavia-passw0rd',
      :keystone_tenant   => 'services',
      :keystone_user     => 'octavia',
      :package_ensure    => 'latest',
      :port              => '9876',
      :host              => '0.0.0.0',
    }
  end

  shared_examples_for 'octavia-api' do

    context 'without required parameter keystone_password' do
      before { params.delete(:keystone_password) }
      it { expect { is_expected.to raise_error(Puppet::Error) } }
    end

    it { is_expected.to contain_class('octavia::params') }
    it { is_expected.to contain_class('octavia::policy') }

    it 'installs octavia-api package' do
      is_expected.to contain_package('octavia-api').with(
        :ensure => 'latest',
        :name   => platform_params[:api_package_name],
        :tag    => ['openstack', 'octavia-package'],
      )
    end

    it 'configures keystone authentication middleware' do
      is_expected.to contain_octavia_config('keystone_authtoken/auth_uri').with_value( params[:keystone_auth_uri] )
      is_expected.to contain_octavia_config('keystone_authtoken/admin_tenant_name').with_value( params[:keystone_tenant] )
      is_expected.to contain_octavia_config('keystone_authtoken/admin_user').with_value( params[:keystone_user] )
      is_expected.to contain_octavia_config('keystone_authtoken/admin_password').with_value( params[:keystone_password] )
      is_expected.to contain_octavia_config('keystone_authtoken/admin_password').with_value( params[:keystone_password] ).with_secret(true)
      is_expected.to contain_octavia_config('api/host').with_value( params[:host] )
      is_expected.to contain_octavia_config('api/port').with_value( params[:port] )
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
            :require    => 'Class[Octavia::Db]',
            :tag        => ['octavia-service', 'octavia-db-sync-service'],
          )
        end
      end
    end

    context 'with sync_db set to true' do
      before do
        params.merge!({
          :sync_db => true})
      end
      it { is_expected.to contain_class('octavia::db::sync') }
    end

    context 'with disabled service managing' do
      before do
        params.merge!({
          :manage_service => false,
          :enabled        => false })
      end

      it 'configures octavia-api service' do
        is_expected.to contain_service('octavia-api').with(
          :ensure     => nil,
          :name       => platform_params[:api_service_name],
          :enable     => false,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => ['octavia-service', 'octavia-db-sync-service'],
        )
      end
    end

    context 'with custom identity_uri' do
      before do
        params.merge!({
          :keystone_identity_uri => 'https://foo.bar:1234/',
        })
      end
      it 'should configure custom identity_uri correctly' do
        is_expected.to contain_octavia_config('keystone_authtoken/identity_uri').with_value( 'https://foo.bar:1234/' )
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
          { :api_package_name => 'octavia-api',
            :api_service_name => 'octavia-api' }
        when 'RedHat'
          { :api_package_name => 'openstack-octavia-api',
            :api_service_name => 'octavia-api' }
        end
      end
      it_behaves_like 'octavia-api'
    end
  end

end
