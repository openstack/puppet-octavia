#
# Unit tests for octavia::keystone::auth
#

require 'spec_helper'

describe 'octavia::keystone::auth' do
  shared_examples_for 'octavia::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'octavia_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('octavia').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :service_name        => 'octavia',
        :service_type        => 'load-balancer',
        :service_description => 'Octavia Service',
        :region              => 'RegionOne',
        :auth_name           => 'octavia',
        :password            => 'octavia_password',
        :email               => 'octavia@localhost',
        :tenant              => 'services',
        :public_url          => 'http://127.0.0.1:9876',
        :internal_url        => 'http://127.0.0.1:9876',
        :admin_url           => 'http://127.0.0.1:9876',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'octavia_password',
          :auth_name           => 'alt_octavia',
          :email               => 'alt_octavia@alt_localhost',
          :tenant              => 'alt_service',
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :service_description => 'Alternative Octavia Service',
          :service_name        => 'alt_service',
          :service_type        => 'alt_load-balancer',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('octavia').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_load-balancer',
        :service_description => 'Alternative Octavia Service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_octavia',
        :password            => 'octavia_password',
        :email               => 'alt_octavia@alt_localhost',
        :tenant              => 'alt_service',
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }
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
