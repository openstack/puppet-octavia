require 'spec_helper'

describe 'octavia::client' do

  let :params do
    {}
  end

  let :default_params do
    { :package_ensure   => 'present' }
  end

  shared_examples_for 'octavia client' do
    let :p do
      default_params.merge(params)
    end

    it { is_expected.to contain_class('octavia::params') }

    it 'installs octavia client package' do
      is_expected.to contain_package('python-octaviaclient').with(
        :name   => platform_params[:client_package_name],
        :ensure => p[:package_ensure],
        :tag    => 'openstack'
      )
    end

    it { is_expected.to contain_class('openstacklib::openstackclient') }
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
          { :client_package_name => 'python3-octaviaclient' }
        when 'RedHat'
          { :client_package_name => 'python-octaviaclient' }
        end
      end

      it_behaves_like 'octavia client'
    end
  end

end
