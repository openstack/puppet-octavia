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
        :name   => 'python-octaviaclient',
        :ensure => p[:package_ensure],
        :tag    => 'openstack'
      )
    end

  end

  on_supported_os({
    :supported_os   =>
      [
        { 'operatingsystem'        => 'Ubuntu',
          'operatingsystemrelease' => [ '16.04' ] },
        { 'operatingsystem'        => 'Debian',
          'operatingsystemrelease' => [ '8' ] }
      ]
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'octavia client'
    end
  end

end
