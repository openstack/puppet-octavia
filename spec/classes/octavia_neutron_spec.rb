require 'spec_helper'

describe 'octavia::neutron' do
  shared_examples 'octavia::neutron' do
    let :params do
      {
        :password => 'secret',
      }
    end

    context 'with default parameters' do
      it {
        is_expected.to contain_octavia_config('neutron/auth_url').with_value('http://localhost:5000')
        is_expected.to contain_octavia_config('neutron/username').with_value('neutron')
        is_expected.to contain_octavia_config('neutron/password').with_value('secret').with_secret(true)
        is_expected.to contain_octavia_config('neutron/project_name').with_value('services')
        is_expected.to contain_octavia_config('neutron/user_domain_name').with_value('Default')
        is_expected.to contain_octavia_config('neutron/project_domain_name').with_value('Default')
        is_expected.to contain_octavia_config('neutron/system_scope').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('neutron/auth_type').with_value('password')
        is_expected.to contain_octavia_config('neutron/region_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('neutron/service_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('neutron/endpoint_override').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('neutron/valid_interfaces').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'with specified parameters' do
      before do
        params.merge!({
          :auth_url             => 'http://127.0.0.1:5000',
          :username             => 'some_user',
          :password             => 'secrete',
          :project_name         => 'some_project_name',
          :user_domain_name     => 'my_domain_name',
          :project_domain_name  => 'our_domain_name',
          :auth_type            => 'v3password',
          :region_name          => 'regionOne',
          :service_name         => 'networking',
          :endpoint_override    => 'http://127.0.0.1:9696',
          :valid_interfaces     => ['internal', 'public'],
        })
      end

      it {
        is_expected.to contain_octavia_config('neutron/auth_url').with_value('http://127.0.0.1:5000')
        is_expected.to contain_octavia_config('neutron/username').with_value('some_user')
        is_expected.to contain_octavia_config('neutron/project_name').with_value('some_project_name')
        is_expected.to contain_octavia_config('neutron/password').with_value('secrete').with_secret(true)
        is_expected.to contain_octavia_config('neutron/user_domain_name').with_value('my_domain_name')
        is_expected.to contain_octavia_config('neutron/project_domain_name').with_value('our_domain_name')
        is_expected.to contain_octavia_config('neutron/system_scope').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('neutron/auth_type').with_value('v3password')
        is_expected.to contain_octavia_config('neutron/region_name').with_value('regionOne')
        is_expected.to contain_octavia_config('neutron/service_name').with_value('networking')
        is_expected.to contain_octavia_config('neutron/endpoint_override').with_value('http://127.0.0.1:9696')
        is_expected.to contain_octavia_config('neutron/valid_interfaces').with_value('internal,public')
      }
    end

    context 'when system_scope is set' do
      before do
        params.merge!({
          :system_scope => 'all'
        })
      end
      it 'configures system-scoped credential' do
        is_expected.to contain_octavia_config('neutron/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('neutron/project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('neutron/system_scope').with_value('all')
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'octavia::neutron'
    end
  end

end
