require 'spec_helper'

describe 'octavia::key_manager::barbican' do
  shared_examples 'octavia::key_manager::barbican' do
    context 'with default parameters' do
      it {
        is_expected.to contain_oslo__key_manager__barbican('octavia_config').with(
          :barbican_endpoint       => '<SERVICE DEFAULT>',
          :barbican_api_version    => '<SERVICE DEFAULT>',
          :auth_endpoint           => '<SERVICE DEFAULT>',
          :retry_delay             => '<SERVICE DEFAULT>',
          :number_of_retries       => '<SERVICE DEFAULT>',
          :barbican_endpoint_type  => '<SERVICE DEFAULT>',
          :barbican_region_name    => '<SERVICE DEFAULT>',
          :send_service_user_token => '<SERVICE DEFAULT>',
        )
      }
    end

    context 'with specified parameters' do
      let :params do
        {
          :barbican_endpoint       => 'http://localhost:9311/',
          :barbican_api_version    => 'v1',
          :auth_endpoint           => 'http://localhost:5000',
          :retry_delay             => 1,
          :number_of_retries       => 60,
          :barbican_endpoint_type  => 'public',
          :barbican_region_name    => 'regionOne',
          :send_service_user_token => true,
        }
      end

      it {
        is_expected.to contain_oslo__key_manager__barbican('octavia_config').with(
          :barbican_endpoint       => 'http://localhost:9311/',
          :barbican_api_version    => 'v1',
          :auth_endpoint           => 'http://localhost:5000',
          :retry_delay             => 1,
          :number_of_retries       => 60,
          :barbican_endpoint_type  => 'public',
          :barbican_region_name    => 'regionOne',
          :send_service_user_token => true,
        )
      }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'octavia::key_manager::barbican'
    end
  end
end
