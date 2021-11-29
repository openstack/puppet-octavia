require 'spec_helper'

describe 'octavia::compute' do
  shared_examples 'octavia::compute' do
    context 'with default parameters' do
      it {
        should contain_octavia_config('compute/max_retries').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('compute/retry_interval').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('compute/retry_backoff').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('compute/retry_max').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'with parameters set' do
      let :params do
        {
          :max_retries    => 15,
          :retry_interval => 1,
          :retry_backoff  => 2,
          :retry_max      => 10,
        }
      end

      it {
        should contain_octavia_config('compute/max_retries').with_value(15)
        should contain_octavia_config('compute/retry_interval').with_value(1)
        should contain_octavia_config('compute/retry_backoff').with_value(2)
        should contain_octavia_config('compute/retry_max').with_value(10)
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

      it_behaves_like 'octavia::compute'
    end
  end

end
