require 'spec_helper'

describe 'octavia::keystone::auth' do
  shared_examples 'octavia::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        {
          :password => 'octavia_password',
          :tenant   => 'foobar'
        }
      end

      it { should contain_keystone_user('octavia').with(
        :ensure   => 'present',
        :password => 'octavia_password',
      )}

      it { should contain_keystone_user_role('octavia@foobar').with(
        :ensure  => 'present',
        :roles   => ['admin']
      )}

      it { should contain_keystone_service('octavia::load-balancer').with(
        :ensure      => 'present',
        :description => 'Octavia Service'
      )}

      it { should contain_keystone_endpoint('RegionOne/octavia::load-balancer').with(
        :ensure       => 'present',
        :public_url   => 'http://127.0.0.1:9876',
        :admin_url    => 'http://127.0.0.1:9876',
        :internal_url => 'http://127.0.0.1:9876',
      )}
    end

    context 'when overriding URL parameters' do
      let :params do
        {
          :password     => 'octavia_password',
          :public_url   => 'https://10.10.10.10:80',
          :internal_url => 'http://10.10.10.11:81',
          :admin_url    => 'http://10.10.10.12:81',
        }
      end

      it { should contain_keystone_endpoint('RegionOne/octavia::load-balancer').with(
        :ensure       => 'present',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81',
      )}
    end

    context 'when overriding auth name' do
      let :params do
        {
          :password => 'foo',
          :auth_name => 'octaviay'
        }
      end

      it { should contain_keystone_user('octaviay') }
      it { should contain_keystone_user_role('octaviay@services') }
      it { should contain_keystone_service('octavia::load-balancer') }
      it { should contain_keystone_endpoint('RegionOne/octavia::load-balancer') }
    end

    context 'when overriding service name' do
      let :params do
        {
          :service_name => 'octavia_service',
          :auth_name    => 'octavia',
          :password     => 'octavia_password'
        }
      end

      it { should contain_keystone_user('octavia') }
      it { should contain_keystone_user_role('octavia@services') }
      it { should contain_keystone_service('octavia_service::load-balancer') }
      it { should contain_keystone_endpoint('RegionOne/octavia_service::load-balancer') }
    end

    context 'when disabling user configuration' do
      let :params do
        {
          :password       => 'octavia_password',
          :configure_user => false
        }
      end

      it { should_not contain_keystone_user('octavia') }
      it { should contain_keystone_user_role('octavia@services') }

      it { should contain_keystone_service('octavia::load-balancer').with(
        :ensure      => 'present',
        :description => 'Octavia Service'
      )}
    end

    context 'when disabling user and user role configuration' do
      let :params do
        {
          :password            => 'octavia_password',
          :configure_user      => false,
          :configure_user_role => false
        }
      end

      it { should_not contain_keystone_user('octavia') }
      it { should_not contain_keystone_user_role('octavia@services') }

      it { should contain_keystone_service('octavia::load-balancer').with(
        :ensure      => 'present',
        :description => 'Octavia Service'
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

      it_behaves_like 'octavia::keystone::auth'
    end
  end
end
