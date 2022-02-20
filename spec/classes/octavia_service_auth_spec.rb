require 'spec_helper'

describe 'octavia::service_auth' do

  shared_examples_for 'service-auth' do

    let :params do
      {
        :password => 'secrete'
      }
    end

    context 'with default params' do
      it 'configures default auth' do
        is_expected.to contain_octavia_config('service_auth/auth_url').with_value('http://localhost:5000')
        is_expected.to contain_octavia_config('service_auth/username').with_value('octavia')
        is_expected.to contain_octavia_config('service_auth/project_name').with_value('services')
        is_expected.to contain_octavia_config('service_auth/password').with_value('secrete').with_secret(true)
        is_expected.to contain_octavia_config('service_auth/user_domain_name').with_value('Default')
        is_expected.to contain_octavia_config('service_auth/project_domain_name').with_value('Default')
        is_expected.to contain_octavia_config('service_auth/auth_type').with_value('password')
        is_expected.to contain_octavia_config('service_auth/region_name').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'when credentials are configured' do
      before do
        params.merge!({
          :auth_url            => 'http://199.199.199.199:64371',
          :username            => 'some_user',
          :project_name        => 'some_project_name',
          :user_domain_name    => 'my_domain_name',
          :project_domain_name => 'our_domain_name',
          :auth_type           => 'v3password',
          :region_name         => 'regionOne',
        })
      end

      it 'configures credentials' do
        is_expected.to contain_octavia_config('service_auth/auth_url').with_value('http://199.199.199.199:64371')
        is_expected.to contain_octavia_config('service_auth/username').with_value('some_user')
        is_expected.to contain_octavia_config('service_auth/project_name').with_value('some_project_name')
        is_expected.to contain_octavia_config('service_auth/password').with_value('secrete').with_secret(true)
        is_expected.to contain_octavia_config('service_auth/user_domain_name').with_value('my_domain_name')
        is_expected.to contain_octavia_config('service_auth/project_domain_name').with_value('our_domain_name')
        is_expected.to contain_octavia_config('service_auth/auth_type').with_value('v3password')
        is_expected.to contain_octavia_config('service_auth/region_name').with_value('regionOne')
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
      it_behaves_like 'service-auth'
    end
  end
end
