require 'spec_helper'

describe 'octavia::db::postgresql' do

  shared_examples_for 'octavia::db::postgresql' do
    let :req_params do
      { :password => 'octaviapass' }
    end

    let :pre_condition do
      'include postgresql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_class('octavia::deps') }

      it { is_expected.to contain_openstacklib__db__postgresql('octavia').with(
        :user       => 'octavia',
        :password   => 'octaviapass',
        :dbname     => 'octavia',
        :encoding   => nil,
        :privileges => 'ALL',
      )}
      it { is_expected.to_not contain_openstacklib__db__postgresql('octavia_persistence') }
    end

    context 'with persistence database enabled' do
      let :params do
        req_params.merge!(:persistence_dbname => 'octavia_persistence')
      end

      it { is_expected.to contain_class('octavia::deps') }

      it { is_expected.to contain_openstacklib__db__postgresql('octavia').with(
        :user       => 'octavia',
        :password   => 'octaviapass',
        :dbname     => 'octavia',
        :encoding   => nil,
        :privileges => 'ALL',
      )}
      it { is_expected.to contain_openstacklib__db__postgresql('octavia_persistence').with(
        :user       => 'octavia',
        :password   => 'octaviapass',
        :dbname     => 'octavia_persistence',
        :encoding   => nil,
        :privileges => 'ALL',
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          # puppet-postgresql requires the service_provider fact provided by
          # puppetlabs-postgresql.
          :service_provider => 'systemd'
        }))
      end

      it_configures 'octavia::db::postgresql'
    end
  end

end
