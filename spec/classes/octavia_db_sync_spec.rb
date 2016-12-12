require 'spec_helper'

describe 'octavia::db::sync' do

  shared_examples_for 'octavia-dbsync' do

    it 'runs octavia-manage db upgrade' do
      is_expected.to contain_exec('octavia-db-sync').with(
        :command     => 'octavia-db-manage upgrade head ',
        :user        => 'octavia',
        :path        => '/usr/bin',
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :subscribe   => ['Anchor[octavia::install::end]',
                         'Anchor[octavia::config::end]',
                         'Anchor[octavia::dbsync::begin]'],
        :notify      => 'Anchor[octavia::dbsync::end]',
      )
    end

    describe "overriding extra_params" do
      let :params do
        {
          :extra_params => '--config-file /etc/octavia/octavia.conf',
        }
      end

      it {
        is_expected.to contain_exec('octavia-db-sync').with(
          :command     => 'octavia-db-manage upgrade head --config-file /etc/octavia/octavia.conf',
          :user        => 'octavia',
          :path        => '/usr/bin',
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :subscribe   => ['Anchor[octavia::install::end]',
                         'Anchor[octavia::config::end]',
                         'Anchor[octavia::dbsync::begin]'],
          :notify      => 'Anchor[octavia::dbsync::end]',
        )
      }
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'octavia-dbsync'
    end
  end

end
