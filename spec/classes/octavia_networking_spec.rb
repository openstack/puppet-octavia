require 'spec_helper'

describe 'octavia::networking' do
  shared_examples 'octavia::networking' do
    context 'with default parameters' do
      it {
        should contain_octavia_config('networking/max_retries').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('networking/retry_interval').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('networking/retry_backoff').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('networking/retry_max').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('networking/port_detach_timeout').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('networking/allow_vip_network_id').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('networking/allow_vip_subnet_id').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('networking/allow_vip_port_id').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('networking/valid_vip_networks').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('networking/reserved_ips').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('networking/allow_invisible_resource_usage').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'with parameters set' do
      let :params do
        {
          :max_retries                    => 15,
          :retry_interval                 => 1,
          :retry_backoff                  => 2,
          :retry_max                      => 10,
          :port_detach_timeout            => 300,
          :allow_vip_network_id           => true,
          :allow_vip_subnet_id            => true,
          :allow_vip_port_id              => true,
          :valid_vip_networks             => 'net1,net2',
          :reserved_ips                   => '169.254.169.254',
          :allow_invisible_resource_usage => false
        }
      end

      it {
        should contain_octavia_config('networking/max_retries').with_value(15)
        should contain_octavia_config('networking/retry_interval').with_value(1)
        should contain_octavia_config('networking/retry_backoff').with_value(2)
        should contain_octavia_config('networking/retry_max').with_value(10)
        should contain_octavia_config('networking/port_detach_timeout').with_value(300)
        should contain_octavia_config('networking/allow_vip_network_id').with_value(true)
        should contain_octavia_config('networking/allow_vip_subnet_id').with_value(true)
        should contain_octavia_config('networking/allow_vip_port_id').with_value(true)
        should contain_octavia_config('networking/valid_vip_networks').with_value('net1,net2')
        should contain_octavia_config('networking/reserved_ips').with_value('169.254.169.254')
        should contain_octavia_config('networking/allow_invisible_resource_usage').with_value(false)
      }
    end

    context 'with array values' do
      let :params do
        {
          :valid_vip_networks => ['net1', 'net2'],
          :reserved_ips       => ['169.254.169.254', '192.168.0.1'],
        }
      end

      it {
        should contain_octavia_config('networking/valid_vip_networks').with_value('net1,net2')
        should contain_octavia_config('networking/reserved_ips').with_value('169.254.169.254,192.168.0.1')
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

      it_behaves_like 'octavia::networking'
    end
  end

end
