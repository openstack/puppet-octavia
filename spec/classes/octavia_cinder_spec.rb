require 'spec_helper'

describe 'octavia::cinder' do
  shared_examples 'octavia::cinder' do
    context 'with default parameters' do
      it {
        should contain_octavia_config('cinder/service_name').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('cinder/endpoint').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('cinder/region_name').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('cinder/endpoint_type').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('cinder/availability_zone').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('cinder/volume_size').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('cinder/volume_type').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('cinder/volume_create_retry_interval').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('cinder/volume_create_timeout').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('cinder/volume_create_max_retries').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'with specified parameters' do
      let :params do
        {
          :service_name                 => 'compute',
          :endpoint                     => 'http://127.0.0.1:8776',
          :region_name                  => 'RegionOne',
          :endpoint_type                => 'internalURL',
          :availability_zone            => 'nova',
          :volume_size                  => 16,
          :volume_type                  => 'default',
          :volume_create_retry_interval => 5,
          :volume_create_timeout        => 300,
          :volume_create_max_retries    => 5,
        }
      end

      it {
        should contain_octavia_config('cinder/service_name').with_value('compute')
        should contain_octavia_config('cinder/endpoint').with_value('http://127.0.0.1:8776')
        should contain_octavia_config('cinder/region_name').with_value('RegionOne')
        should contain_octavia_config('cinder/endpoint_type').with_value('internalURL')
        should contain_octavia_config('cinder/availability_zone').with_value('nova')
        should contain_octavia_config('cinder/volume_size').with_value(16)
        should contain_octavia_config('cinder/volume_type').with_value('default')
        should contain_octavia_config('cinder/volume_create_retry_interval').with_value(5)
        should contain_octavia_config('cinder/volume_create_timeout').with_value(300)
        should contain_octavia_config('cinder/volume_create_max_retries').with_value(5)
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

      it_behaves_like 'octavia::cinder'
    end
  end

end
