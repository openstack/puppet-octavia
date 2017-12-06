require 'spec_helper'

describe 'octavia::certificates' do
  shared_examples_for 'certificates' do

    context 'with default params' do
      it 'configures octavia certificate manager' do
        is_expected.to contain_octavia_config('certificates/ca_certificate').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('certificates/ca_private_key').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('certificates/ca_private_key_passphrase').with_value('<SERVICE DEFAULT>')
      end

      it 'configures octavia authentication credentials' do
        is_expected.to contain_octavia_config('controller_worker/client_ca').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/client_cert').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/server_ca').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'when certificates are configured' do
      let :params do
        { :ca_certificate            => '/etc/octavia/ca.pem',
          :ca_private_key            => '/etc/octavia/key.pem',
          :ca_private_key_passphrase => 'secure123',
          :client_cert               => '/etc/octavia/client.pem'
        }
      end

      it 'configures octavia certificate manager' do
        is_expected.to contain_octavia_config('certificates/ca_certificate').with_value('/etc/octavia/ca.pem')
        is_expected.to contain_octavia_config('certificates/ca_private_key').with_value('/etc/octavia/key.pem')
        is_expected.to contain_octavia_config('certificates/ca_private_key_passphrase').with_value('secure123')
      end

      it 'configures octavia authentication credentials' do
        is_expected.to contain_octavia_config('controller_worker/client_ca').with_value('/etc/octavia/ca.pem')
        is_expected.to contain_octavia_config('haproxy_amphora/client_cert').with_value('/etc/octavia/client.pem')
        is_expected.to contain_octavia_config('haproxy_amphora/server_ca').with_value('/etc/octavia/ca.pem')
      end
    end

    context 'when certificates are configured with data provided' do
      let :params do
        { :ca_certificate            => '/etc/octavia/ca.pem',
          :ca_private_key            => '/etc/octavia/key.pem',
          :ca_private_key_passphrase => 'secure123',
          :client_cert               => '/etc/octavia/client.pem',
          :ca_certificate_data       => 'on_my_authority_this_is_a_certificate',
          :ca_private_key_data       => 'this_is_my_private_key_woot_woot',
          :client_cert_data          => 'certainly_for_the_client',
        }
      end

      it 'configures octavia certificate manager' do
        is_expected.to contain_octavia_config('certificates/ca_certificate').with_value('/etc/octavia/ca.pem')
        is_expected.to contain_octavia_config('certificates/ca_private_key').with_value('/etc/octavia/key.pem')
        is_expected.to contain_octavia_config('certificates/ca_private_key_passphrase').with_value('secure123')
      end

      it 'configures octavia authentication credentials' do
        is_expected.to contain_octavia_config('controller_worker/client_ca').with_value('/etc/octavia/ca.pem')
        is_expected.to contain_octavia_config('haproxy_amphora/client_cert').with_value('/etc/octavia/client.pem')
        is_expected.to contain_octavia_config('haproxy_amphora/server_ca').with_value('/etc/octavia/ca.pem')
      end

      it 'populates certificate files' do
        is_expected.to contain_file('/etc/octavia/ca.pem').with({
          'ensure' => 'file',
          'owner'  => 'octavia',
          'group'  => 'octavia',
          'mode'   => '0755',
        })
        is_expected.to contain_file('/etc/octavia/ca.pem').with_content('on_my_authority_this_is_a_certificate')
        is_expected.to contain_file('/etc/octavia/key.pem').with({
          'ensure' => 'file',
          'owner'  => 'octavia',
          'group'  => 'octavia',
          'mode'   => '0755',
        })
        is_expected.to contain_file('/etc/octavia/key.pem').with_content('this_is_my_private_key_woot_woot')
        is_expected.to contain_file('/etc/octavia/client.pem').with({
          'ensure' => 'file',
          'owner'  => 'octavia',
          'group'  => 'octavia',
          'mode'   => '0755',
        })
        is_expected.to contain_file('/etc/octavia/client.pem').with_content('certainly_for_the_client')
        is_expected.to contain_file('/etc/octavia').with({
          'ensure' => 'directory',
          'owner'  => 'octavia',
          'group'  => 'octavia',
          'mode'   => '0755',
        })
      end
    end

    context 'when certificates are configured with data provided but different paths' do
      let :params do
        { :ca_certificate            => '/etc/octavia/ca.pem',
          :ca_private_key            => '/etc/octavia1/key.pem',
          :ca_private_key_passphrase => 'secure123',
          :client_cert               => '/etc/octavia2/client.pem',
          :ca_certificate_data       => 'on_my_authority_this_is_a_certificate',
          :ca_private_key_data       => 'this_is_my_private_key_woot_woot',
          :client_cert_data          => 'certainly_for_the_client',
        }
      end

      it 'configures octavia certificate manager' do
        is_expected.to contain_octavia_config('certificates/ca_certificate').with_value('/etc/octavia/ca.pem')
        is_expected.to contain_octavia_config('certificates/ca_private_key').with_value('/etc/octavia1/key.pem')
        is_expected.to contain_octavia_config('certificates/ca_private_key_passphrase').with_value('secure123')
      end

      it 'configures octavia authentication credentials' do
        is_expected.to contain_octavia_config('controller_worker/client_ca').with_value('/etc/octavia/ca.pem')
        is_expected.to contain_octavia_config('haproxy_amphora/client_cert').with_value('/etc/octavia2/client.pem')
        is_expected.to contain_octavia_config('haproxy_amphora/server_ca').with_value('/etc/octavia/ca.pem')
      end

      it 'populates certificate files' do
        is_expected.to contain_file('/etc/octavia/ca.pem').with({
          'ensure' => 'file',
          'owner'  => 'octavia',
          'group'  => 'octavia',
          'mode'   => '0755',
        })
        is_expected.to contain_file('/etc/octavia/ca.pem').with_content('on_my_authority_this_is_a_certificate')
        is_expected.to contain_file('/etc/octavia1/key.pem').with({
          'ensure' => 'file',
          'owner'  => 'octavia',
          'group'  => 'octavia',
          'mode'   => '0755',
        })
        is_expected.to contain_file('/etc/octavia1/key.pem').with_content('this_is_my_private_key_woot_woot')
        is_expected.to contain_file('/etc/octavia2/client.pem').with({
          'ensure' => 'file',
          'owner'  => 'octavia',
          'group'  => 'octavia',
          'mode'   => '0755',
        })
        is_expected.to contain_file('/etc/octavia2/client.pem').with_content('certainly_for_the_client')
        is_expected.to contain_file('/etc/octavia').with({
          'ensure' => 'directory',
          'owner'  => 'octavia',
          'group'  => 'octavia',
          'mode'   => '0755',
        })
        is_expected.to contain_file('/etc/octavia1').with({
          'ensure' => 'directory',
          'owner'  => 'octavia',
          'group'  => 'octavia',
          'mode'   => '0755',
        })
        is_expected.to contain_file('/etc/octavia2').with({
          'ensure' => 'directory',
          'owner'  => 'octavia',
          'group'  => 'octavia',
          'mode'   => '0755',
        })
      end
    end

    context 'when CA file name is missing with data provided' do
      let :params do
        { :ca_certificate_data       => 'dummy_data'
        }
      end

      it 'fails without a filename' do
        is_expected.to raise_error(Puppet::Error)
      end
    end

    context 'when CA key file name is missing with data provided' do
      let :params do
        { :ca_private_key_data       => 'dummy_data'
        }
      end

      it 'fails without a filename' do
        is_expected.to raise_error(Puppet::Error)
      end
    end

    context 'when client cert file name is missing with data provided' do
      let :params do
        { :client_cert_data       => 'dummy_data'
        }
      end

      it 'fails without a filename' do
        is_expected.to raise_error(Puppet::Error)
      end
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end
      it_behaves_like 'certificates'
    end
  end
end
