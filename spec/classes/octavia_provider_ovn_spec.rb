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

      it { is_expected.to contain_package('ovn-octavia-provider').with(
        :ensure => 'present',
        :name   => 'python3-ovn-octavia-provider',
        :tag    => ['openstack', 'octavia-package'],
      ) }
    end

    context 'with specific parameters' do
      before do
        params.merge!({
          :ovn_nb_connection  => 'tcp:127.0.0.1:6641',
          :ovn_nb_private_key => '/foo.key',
          :ovn_nb_certificate => '/foo.pem',
          :ovn_nb_ca_cert     => '/ca_foo.pem'
        })
      end

      it { is_expected.to contain_octavia_config('ovn/ovn_nb_connection').with_value('tcp:127.0.0.1:6641') }
      it { is_expected.to contain_octavia_config('ovn/ovn_nb_private_key').with_value('/foo.key') }
      it { is_expected.to contain_octavia_config('ovn/ovn_nb_certificate').with_value('/foo.pem') }
      it { is_expected.to contain_octavia_config('ovn/ovn_nb_ca_cert').with_value('/ca_foo.pem') }
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
