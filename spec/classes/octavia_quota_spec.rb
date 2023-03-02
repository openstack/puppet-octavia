require 'spec_helper'

describe 'octavia::quota' do
  let :default_params do
    {
      :default_load_balancer_quota  => '<SERVICE DEFAULT>',
      :default_listener_quota       => '<SERVICE DEFAULT>',
      :default_member_quota         => '<SERVICE DEFAULT>',
      :default_pool_quota           => '<SERVICE DEFAULT>',
      :default_health_monitor_quota => '<SERVICE DEFAULT>',
      :default_l7policy_quota       => '<SERVICE DEFAULT>',
      :default_l7rule_quota         => '<SERVICE DEFAULT>',
    }
  end

  let :params do
    {}
  end

  shared_examples_for 'octavia quota' do

    let :p do
      default_params.merge(params)
    end

    it 'contains default values' do
      is_expected.to contain_octavia_config('quotas/default_load_balancer_quota').with_value(p[:default_load_balancer_quota])
      is_expected.to contain_octavia_config('quotas/default_listener_quota').with_value(p[:default_listener_quota])
      is_expected.to contain_octavia_config('quotas/default_member_quota').with_value(p[:default_member_quota])
      is_expected.to contain_octavia_config('quotas/default_pool_quota').with_value(p[:default_pool_quota])
      is_expected.to contain_octavia_config('quotas/default_health_monitor_quota').with_value(p[:default_health_monitor_quota])
      is_expected.to contain_octavia_config('quotas/default_l7policy_quota').with_value(p[:default_l7policy_quota])
      is_expected.to contain_octavia_config('quotas/default_l7rule_quota').with_value(p[:default_l7rule_quota])
    end

    context 'configure quota with parameters' do
      before :each do
        params.merge!({
          :default_load_balancer_quota  => 10,
          :default_listener_quota       => 20,
          :default_member_quota         => 30,
          :default_pool_quota           => 40,
          :default_health_monitor_quota => 50,
          :default_l7policy_quota       => 60,
          :default_l7rule_quota         => 70,
        })
      end

      it 'contains the defined values' do
        is_expected.to contain_octavia_config('quotas/default_load_balancer_quota').with_value(p[:default_load_balancer_quota])
        is_expected.to contain_octavia_config('quotas/default_listener_quota').with_value(p[:default_listener_quota])
        is_expected.to contain_octavia_config('quotas/default_member_quota').with_value(p[:default_member_quota])
        is_expected.to contain_octavia_config('quotas/default_pool_quota').with_value(p[:default_pool_quota])
        is_expected.to contain_octavia_config('quotas/default_health_monitor_quota').with_value(p[:default_health_monitor_quota])
        is_expected.to contain_octavia_config('quotas/default_l7policy_quota').with_value(p[:default_l7policy_quota])
        is_expected.to contain_octavia_config('quotas/default_l7rule_quota').with_value(p[:default_l7rule_quota])
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_configures 'octavia quota'
    end
  end

end
