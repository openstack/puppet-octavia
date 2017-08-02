#
# Unit tests for octavia::keystone::auth
#

require 'spec_helper'

describe 'octavia::keystone::auth' do

  let :facts do
    { :osfamily => 'Debian' }
  end

  describe 'with default class parameters' do
    let :params do
      { :password => 'octavia_password',
        :tenant   => 'foobar' }
    end

    it { is_expected.to contain_keystone_user('octavia').with(
      :ensure   => 'present',
      :password => 'octavia_password',
    ) }

    it { is_expected.to contain_keystone_user_role('octavia@foobar').with(
      :ensure  => 'present',
      :roles   => ['admin']
    )}

    it { is_expected.to contain_keystone_service('octavia::load-balancer').with(
      :ensure      => 'present',
      :description => 'Octavia Service'
    ) }

    it { is_expected.to contain_keystone_endpoint('RegionOne/octavia::load-balancer').with(
      :ensure       => 'present',
      :public_url   => 'http://127.0.0.1:9876',
      :admin_url    => 'http://127.0.0.1:9876',
      :internal_url => 'http://127.0.0.1:9876',
    ) }
  end

  describe 'when overriding URL parameters' do
    let :params do
      { :password     => 'octavia_password',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81', }
    end

    it { is_expected.to contain_keystone_endpoint('RegionOne/octavia::load-balancer').with(
      :ensure       => 'present',
      :public_url   => 'https://10.10.10.10:80',
      :internal_url => 'http://10.10.10.11:81',
      :admin_url    => 'http://10.10.10.12:81',
    ) }
  end

  describe 'when overriding auth name' do
    let :params do
      { :password => 'foo',
        :auth_name => 'octaviay' }
    end

    it { is_expected.to contain_keystone_user('octaviay') }
    it { is_expected.to contain_keystone_user_role('octaviay@services') }
    it { is_expected.to contain_keystone_service('octavia::load-balancer') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/octavia::load-balancer') }
  end

  describe 'when overriding service name' do
    let :params do
      { :service_name => 'octavia_service',
        :auth_name    => 'octavia',
        :password     => 'octavia_password' }
    end

    it { is_expected.to contain_keystone_user('octavia') }
    it { is_expected.to contain_keystone_user_role('octavia@services') }
    it { is_expected.to contain_keystone_service('octavia_service::load-balancer') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/octavia_service::load-balancer') }
  end

  describe 'when disabling user configuration' do

    let :params do
      {
        :password       => 'octavia_password',
        :configure_user => false
      }
    end

    it { is_expected.not_to contain_keystone_user('octavia') }
    it { is_expected.to contain_keystone_user_role('octavia@services') }
    it { is_expected.to contain_keystone_service('octavia::load-balancer').with(
      :ensure      => 'present',
      :description => 'Octavia Service'
    ) }

  end

  describe 'when disabling user and user role configuration' do

    let :params do
      {
        :password            => 'octavia_password',
        :configure_user      => false,
        :configure_user_role => false
      }
    end

    it { is_expected.not_to contain_keystone_user('octavia') }
    it { is_expected.not_to contain_keystone_user_role('octavia@services') }
    it { is_expected.to contain_keystone_service('octavia::load-balancer').with(
      :ensure      => 'present',
      :description => 'Octavia Service'
    ) }

  end

end
