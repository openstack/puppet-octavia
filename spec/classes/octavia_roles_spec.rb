require 'spec_helper'

describe 'octavia::roles' do

  let :params do
    {
    }
  end

  shared_examples_for 'octavia-roles' do

    context 'when using default args' do
      it 'creates keystone roles' do
        is_expected.to contain_keystone_role('load-balancer_observer')
        is_expected.to contain_keystone_role('load-balancer_global_observer')
        is_expected.to contain_keystone_role('load-balancer_member')
        is_expected.to contain_keystone_role('load-balancer_quota_admin')
        is_expected.to contain_keystone_role('load-balancer_admin')
        is_expected.to contain_keystone_role('admin')
      end
    end

    context 'when using custom roles' do
      before do
        params.merge!({
          :role_names => ['foo', 'bar', 'krispy']
        })
      end
      it 'creates custom keystone roles' do
        is_expected.to contain_keystone_role('foo')
        is_expected.to contain_keystone_role('bar')
        is_expected.to contain_keystone_role('krispy')
        is_expected.not_to contain_keystone_role('load-balancer_observer')
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
      it_behaves_like 'octavia-roles'
    end
  end

end
