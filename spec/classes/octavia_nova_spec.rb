require 'spec_helper'

describe 'octavia::nova' do
  shared_examples 'octavia::nova' do
    context 'with default parameters' do
      it {
        should contain_octavia_config('nova/service_name').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('nova/endpoint').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('nova/region_name').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('nova/endpoint_type').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('nova/availability_zone').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('nova/enable_anti_affinity').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('nova/anti_affinity_policy').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'with specified parameters' do
      let :params do
        {
          :service_name         => 'compute',
          :endpoint             => 'http://127.0.0.1:8774',
          :region_name          => 'RegionOne',
          :endpoint_type        => 'internalURL',
          :availability_zone    => 'nova',
          :enable_anti_affinity => true,
          :anti_affinity_policy => 'anti-affinity',
        }
      end

      it {
        should contain_octavia_config('nova/service_name').with_value('compute')
        should contain_octavia_config('nova/endpoint').with_value('http://127.0.0.1:8774')
        should contain_octavia_config('nova/region_name').with_value('RegionOne')
        should contain_octavia_config('nova/endpoint_type').with_value('internalURL')
        should contain_octavia_config('nova/availability_zone').with_value('nova')
        should contain_octavia_config('nova/enable_anti_affinity').with_value(true)
        should contain_octavia_config('nova/anti_affinity_policy').with_value('anti-affinity')
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

      it_behaves_like 'octavia::nova'
    end
  end

end
