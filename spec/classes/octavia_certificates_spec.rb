require 'spec_helper'

describe 'octavia::certificates' do
  shared_examples_for 'certificates' do

    context 'with default params' do
      it 'configures octavia certificate manager' do
        is_expected.to contain_octavia_config('certificates/cert_generator').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('certificates/cert_manager').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('certificates/barbican_auth').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('certificates/service_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('certificates/endpoint').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('certificates/region_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('certificates/endpoint_type').with_value('<SERVICE DEFAULT>')
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
        { :cert_generator              => 'local_cert_generator',
          :cert_manager                => 'barbican_cert_manager',
          :barbican_auth               => 'barbican_acl_auth',
          :service_name                => 'barbican',
          :endpoint                    => 'http://localhost:9311',
          :region_name                 => 'RegionOne',
          :endpoint_type               => 'internalURL',
          :ca_certificate              => '/etc/octavia/ca.pem',
          :ca_private_key              => '/etc/octavia/key.pem',
          :server_certs_key_passphrase => 'insecure-key-do-not-use-this-key',
          :ca_private_key_passphrase   => 'secure123',
          :client_cert                 => '/etc/octavia/client.pem'
        }
      end

      it 'configures octavia certificate manager' do
        is_expected.to contain_octavia_config('certificates/cert_generator').with_value('local_cert_generator')
        is_expected.to contain_octavia_config('certificates/cert_manager').with_value('barbican_cert_manager')
        is_expected.to contain_octavia_config('certificates/barbican_auth').with_value('barbican_acl_auth')
        is_expected.to contain_octavia_config('certificates/service_name').with_value('barbican')
        is_expected.to contain_octavia_config('certificates/endpoint').with_value('http://localhost:9311')
        is_expected.to contain_octavia_config('certificates/region_name').with_value('RegionOne')
        is_expected.to contain_octavia_config('certificates/endpoint_type').with_value('internalURL')
        is_expected.to contain_octavia_config('certificates/ca_certificate').with_value('/etc/octavia/ca.pem')
        is_expected.to contain_octavia_config('certificates/ca_private_key').with_value('/etc/octavia/key.pem')
        is_expected.to contain_octavia_config('certificates/server_certs_key_passphrase').with_value('insecure-key-do-not-use-this-key')
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
        { :ca_certificate              => '/etc/octavia/ca.pem',
          :ca_private_key              => '/etc/octavia/key.pem',
          :server_certs_key_passphrase => 'insecure-key-do-not-use-this-key',
          :ca_private_key_passphrase   => 'secure123',
          :client_cert                 => '/etc/octavia/client.pem',
          :ca_certificate_data         => 'on_my_authority_this_is_a_certificate',
          :ca_private_key_data         => 'this_is_my_private_key_woot_woot',
          :client_cert_data            => 'certainly_for_the_client',
        }
      end

      it 'configures octavia certificate manager' do
        is_expected.to contain_octavia_config('certificates/ca_certificate').with_value('/etc/octavia/ca.pem')
        is_expected.to contain_octavia_config('certificates/ca_private_key').with_value('/etc/octavia/key.pem')
        is_expected.to contain_octavia_config('certificates/server_certs_key_passphrase').with_value('insecure-key-do-not-use-this-key')
        is_expected.to contain_octavia_config('certificates/ca_private_key_passphrase').with_value('secure123')
      end

      it 'configures octavia authentication credentials' do
        is_expected.to contain_octavia_config('controller_worker/client_ca').with_value('/etc/octavia/ca.pem')
        is_expected.to contain_octavia_config('haproxy_amphora/client_cert').with_value('/etc/octavia/client.pem')
        is_expected.to contain_octavia_config('haproxy_amphora/server_ca').with_value('/etc/octavia/ca.pem')
      end

      it 'populates certificate files' do
        is_expected.to contain_file('/etc/octavia/ca.pem').with({
          'ensure'    => 'file',
          'content'   => 'on_my_authority_this_is_a_certificate',
          'owner'     => 'octavia',
          'group'     => 'octavia',
          'mode'      => '0755',
          'replace'   => true,
          'show_diff' => false,
          'tag'       => 'octavia-certificate',
        })
        is_expected.to contain_file('/etc/octavia/key.pem').with({
          'ensure'    => 'file',
          'content'   => 'this_is_my_private_key_woot_woot',
          'owner'     => 'octavia',
          'group'     => 'octavia',
          'mode'      => '0755',
          'replace'   => true,
          'show_diff' => false,
          'tag'       => 'octavia-certificate',
        })
        is_expected.to contain_file('/etc/octavia/client.pem').with({
          'ensure'    => 'file',
          'content'   => 'certainly_for_the_client',
          'owner'     => 'octavia',
          'group'     => 'octavia',
          'mode'      => '0755',
          'replace'   => true,
          'show_diff' => false,
          'tag'       => 'octavia-certificate',
        })
        is_expected.to contain_file('/etc/octavia').with({
          'ensure' => 'directory',
          'owner'  => 'octavia',
          'group'  => 'octavia',
          'mode'   => '0755',
          'tag'    => 'octavia-certificate',
        })
      end
    end

    context 'when certificates are configured with data provided but different paths' do
      let :params do
        { :ca_certificate              => '/etc/octavia/ca.pem',
          :ca_private_key              => '/etc/octavia1/key.pem',
          :server_certs_key_passphrase => 'insecure-key-do-not-use-this-key',
          :ca_private_key_passphrase   => 'secure123',
          :client_cert                 => '/etc/octavia2/client.pem',
          :ca_certificate_data         => 'on_my_authority_this_is_a_certificate',
          :ca_private_key_data         => 'this_is_my_private_key_woot_woot',
          :client_cert_data            => 'certainly_for_the_client',
        }
      end

      it 'configures octavia certificate manager' do
        is_expected.to contain_octavia_config('certificates/ca_certificate').with_value('/etc/octavia/ca.pem')
        is_expected.to contain_octavia_config('certificates/ca_private_key').with_value('/etc/octavia1/key.pem')
        is_expected.to contain_octavia_config('certificates/server_certs_key_passphrase').with_value('insecure-key-do-not-use-this-key')
        is_expected.to contain_octavia_config('certificates/ca_private_key_passphrase').with_value('secure123')
      end

      it 'configures octavia authentication credentials' do
        is_expected.to contain_octavia_config('controller_worker/client_ca').with_value('/etc/octavia/ca.pem')
        is_expected.to contain_octavia_config('haproxy_amphora/client_cert').with_value('/etc/octavia2/client.pem')
        is_expected.to contain_octavia_config('haproxy_amphora/server_ca').with_value('/etc/octavia/ca.pem')
      end

      it 'populates certificate files' do
        is_expected.to contain_file('/etc/octavia/ca.pem').with({
          'ensure'    => 'file',
          'content'   => 'on_my_authority_this_is_a_certificate',
          'owner'     => 'octavia',
          'group'     => 'octavia',
          'mode'      => '0755',
          'replace'   => true,
          'show_diff' => false,
          'tag'       => 'octavia-certificate',
        })
        is_expected.to contain_file('/etc/octavia1/key.pem').with({
          'ensure'    => 'file',
          'content'   => 'this_is_my_private_key_woot_woot',
          'owner'     => 'octavia',
          'group'     => 'octavia',
          'mode'      => '0755',
          'replace'   => true,
          'show_diff' => false,
          'tag'       => 'octavia-certificate',
        })
        is_expected.to contain_file('/etc/octavia2/client.pem').with({
          'ensure'    => 'file',
          'content'   => 'certainly_for_the_client',
          'owner'     => 'octavia',
          'group'     => 'octavia',
          'mode'      => '0755',
          'replace'   => true,
          'show_diff' => false,
          'tag'       => 'octavia-certificate',
        })
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

    context 'with ca_certificate and client_ca being different' do
      let :params do
        {
          :ca_certificate => '/etc/octavia/ca.pem',
          :client_ca      => '/etc/octavia/client_ca.pem'
        }
      end

    context 'When invalid non 32 characters server_certs_key_passphrase provided' do
      let :params do
        { :server_certs_key_passphrase => 'non-32-chars-key',
        }
      end

      it 'fails without an invalid server_certs_key_passphrase' do
        is_expected.to raise_error(Puppet::Error)
      end
    end

    context 'When no server_certs_key_passphrase provided' do
      let :params do
        { :server_certs_key_passphrase => '',
        }
      end

      it 'fails without a server_certs_key_passphrase' do
        is_expected.to raise_error(Puppet::Error)
      end
    end

      it 'should configure certificates' do
        is_expected.to contain_octavia_config('certificates/ca_certificate').with_value('/etc/octavia/ca.pem')
        is_expected.to contain_octavia_config('controller_worker/client_ca').with_value('/etc/octavia/client_ca.pem')
      end

      it 'should not populate certificate file' do
        is_expected.not_to contain_file('/etc/octavia/client_ca.pem')
        is_expected.not_to contain_file('/etc/octavia')
      end
    end

    context 'with ca_certificate and client_ca being different and populate files' do
      let :params do
        {
          :ca_certificate      => '/etc/octavia/ca.pem',
          :client_ca           => '/etc/octavia/client_ca.pem',
          :ca_certificate_data => 'my_ca_certificate',
          :client_ca_data      => 'my_client_ca'
        }
      end

      it 'should configure certificates' do
        is_expected.to contain_octavia_config('certificates/ca_certificate').with_value('/etc/octavia/ca.pem')
        is_expected.to contain_octavia_config('controller_worker/client_ca').with_value('/etc/octavia/client_ca.pem')
      end

      it 'populates certificate files' do
        is_expected.to contain_file('/etc/octavia/ca.pem').with({
          'ensure'    => 'file',
          'content'   => 'my_ca_certificate',
          'owner'     => 'octavia',
          'group'     => 'octavia',
          'mode'      => '0755',
          'replace'   => true,
          'show_diff' => false,
          'tag'       => 'octavia-certificate',
        })
        is_expected.to contain_file('/etc/octavia/client_ca.pem').with({
          'ensure'    => 'file',
          'content'   => 'my_client_ca',
          'owner'     => 'octavia',
          'group'     => 'octavia',
          'mode'      => '0755',
          'replace'   => true,
          'show_diff' => false,
          'tag'       => 'octavia-certificate',
        })
        is_expected.to contain_file('/etc/octavia').with({
          'ensure' => 'directory',
          'owner'  => 'octavia',
          'group'  => 'octavia',
          'mode'   => '0755',
        })
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
