require 'spec_helper'

describe 'octavia::glance' do
  shared_examples 'octavia::glance' do
    context 'with default parameters' do
      it {
        should contain_octavia_config('glance/service_name').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('glance/endpoint').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('glance/region_name').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('glance/endpoint_type').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'with specified parameters' do
      let :params do
        {
          :service_name         => 'image',
          :endpoint             => 'http://127.0.0.1:9292',
          :region_name          => 'RegionOne',
          :endpoint_type        => 'internalURL',
        }
      end

      it {
        should contain_octavia_config('glance/service_name').with_value('image')
        should contain_octavia_config('glance/endpoint').with_value('http://127.0.0.1:9292')
        should contain_octavia_config('glance/region_name').with_value('RegionOne')
        should contain_octavia_config('glance/endpoint_type').with_value('internalURL')
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

      it_behaves_like 'octavia::glance'
    end
  end

end
