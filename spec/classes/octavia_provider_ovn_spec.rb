require 'spec_helper'

describe 'octavia::provider::ovn' do

  let :params do
    {}
  end

  shared_examples_for 'octavia-ovn-provider' do

    context 'with default parameters' do
      it { is_expected.to contain_octavia_config('ovn/ovn_nb_connection').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('ovn/ovn_nb_private_key').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('ovn/ovn_nb_certificate').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('ovn/ovn_nb_ca_cert').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('ovn/ovn_sb_connection').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('ovn/ovn_sb_private_key').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('ovn/ovn_sb_certificate').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('ovn/ovn_sb_ca_cert').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('ovn/ovsdb_connection_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('ovn/ovsdb_retry_max_interval').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('ovn/ovsdb_probe_interval').with_value('<SERVICE DEFAULT>') }

      it { is_expected.to contain_package('ovn-octavia-provider').with(
        :ensure => 'present',
        :name   => 'python3-ovn-octavia-provider',
        :tag    => ['openstack', 'octavia-package'],
      ) }
    end

    context 'with specific parameters' do
      before do
        params.merge!({
          :ovn_nb_connection        => 'tcp:127.0.0.1:6641',
          :ovn_nb_private_key       => '/foo.key',
          :ovn_nb_certificate       => '/foo.pem',
          :ovn_nb_ca_cert           => '/ca_foo.pem',
          :ovn_sb_connection        => 'tcp:127.0.0.1:6642',
          :ovn_sb_private_key       => '/bar.key',
          :ovn_sb_certificate       => '/bar.pem',
          :ovn_sb_ca_cert           => '/ca_bar.pem',
          :ovsdb_connection_timeout => 180,
          :ovsdb_retry_max_interval => 180,
          :ovsdb_probe_interval     => 60000,
        })
      end

      it { is_expected.to contain_octavia_config('ovn/ovn_nb_connection').with_value('tcp:127.0.0.1:6641') }
      it { is_expected.to contain_octavia_config('ovn/ovn_nb_private_key').with_value('/foo.key') }
      it { is_expected.to contain_octavia_config('ovn/ovn_nb_certificate').with_value('/foo.pem') }
      it { is_expected.to contain_octavia_config('ovn/ovn_nb_ca_cert').with_value('/ca_foo.pem') }
      it { is_expected.to contain_octavia_config('ovn/ovn_sb_connection').with_value('tcp:127.0.0.1:6642') }
      it { is_expected.to contain_octavia_config('ovn/ovn_sb_private_key').with_value('/bar.key') }
      it { is_expected.to contain_octavia_config('ovn/ovn_sb_certificate').with_value('/bar.pem') }
      it { is_expected.to contain_octavia_config('ovn/ovn_sb_ca_cert').with_value('/ca_bar.pem') }
      it { is_expected.to contain_octavia_config('ovn/ovsdb_connection_timeout').with_value(180) }
      it { is_expected.to contain_octavia_config('ovn/ovsdb_retry_max_interval').with_value(180) }
      it { is_expected.to contain_octavia_config('ovn/ovsdb_probe_interval').with_value(60000) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'octavia-ovn-provider'
    end
  end

end
