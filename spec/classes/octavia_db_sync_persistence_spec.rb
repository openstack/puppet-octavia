require 'spec_helper'

describe 'octavia::db::sync_persistence' do

  shared_examples_for 'octavia::db::sync_persistence' do

    it { is_expected.to contain_class('octavia::deps') }

    it 'runs octavia-manage db upgrade' do
      is_expected.to contain_exec('octavia-db-sync').with(
        :command     => 'octavia-db-manage upgrade_persistence ',
        :user        => 'octavia',
        :path        => '/usr/bin',
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :timeout     => 300,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[octavia::install::end]',
                         'Anchor[octavia::config::end]',
                         'Anchor[octavia::dbsync::begin]'],
        :notify      => 'Anchor[octavia::dbsync::end]',
        :tag         => 'openstack-db',
      )
    end

    describe "overriding params" do
      let :params do
        {
          :extra_params    => '--config-file /etc/octavia/octavia.conf',
          :db_sync_timeout => 750,
        }
      end

      it {
        is_expected.to contain_exec('octavia-db-sync').with(
          :command     => 'octavia-db-manage upgrade_persistence --config-file /etc/octavia/octavia.conf',
          :user        => 'octavia',
          :path        => '/usr/bin',
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :timeout     => 750,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[octavia::install::end]',
                           'Anchor[octavia::config::end]',
                           'Anchor[octavia::dbsync::begin]'],
          :notify      => 'Anchor[octavia::dbsync::end]',
          :tag         => 'openstack-db',
        )
      }
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_configures 'octavia::db::sync_persistence'
    end
  end

end
