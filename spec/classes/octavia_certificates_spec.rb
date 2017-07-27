require 'spec_helper'

describe 'octavia::certificates' do

  let :default_params do
    { :ca_certificate            => '<SERVICE DEFAULT>',
      :ca_private_key            => '<SERVICE DEFAULT>',
      :ca_private_key_passphrase => '<SERVICE DEFAULT>',
      :client_cert               => '<SERVICE DEFAULT>' }
  end

  context 'with default params' do
    let :params do
      default_params
    end

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
      default_params.merge(
        { :ca_certificate            => '/etc/octavia/ca.pem',
          :ca_private_key            => '/etc/octavia/key.pem',
          :ca_private_key_passphrase => 'secure123',
          :client_cert               => '/etc/octavia/client.pem'
        }
      )
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
end
