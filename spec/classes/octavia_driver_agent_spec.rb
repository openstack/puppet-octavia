require 'spec_helper'

describe 'octavia::driver_agent' do

  let :params do
    {
    }
  end

  shared_examples_for 'octavia-driver-agent' do

    context 'with default parameters' do
      it { is_expected.to contain_octavia_config('driver_agent/status_socket_path').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('driver_agent/stats_socket_path').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('driver_agent/get_socket_path').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('driver_agent/status_request_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('driver_agent/status_max_processes').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('driver_agent/stats_request_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('driver_agent/stats_max_processes').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('driver_agent/get_request_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('driver_agent/get_max_processes').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('driver_agent/max_process_warning_percent').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('driver_agent/provider_agent_shutdown_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_octavia_config('driver_agent/enabled_provider_agents').with_value('<SERVICE DEFAULT>') }
    end

    context 'with specific parameters' do
      before do
        params.merge!({
          :status_socket_path              => '/var/run/octavia/foo.sck',
          :stats_socket_path               => '/var/run/octavia/bar.sck',
          :get_socket_path                 => '/var/run/octavia/pikachu.sck',
          :status_request_timeout          => 60,
          :status_max_processes            => 10,
          :stats_request_timeout           => 60,
          :stats_max_processes             => 10,
          :get_request_timeout             => 60,
          :get_max_processes               => 10,
          :max_process_warning_percent     => 0.60,
          :provider_agent_shutdown_timeout => 60,
          :enabled_provider_agents         => ['agent-a', 'agent-b'],
        })
      end

      it { is_expected.to contain_octavia_config('driver_agent/status_socket_path').with_value('/var/run/octavia/foo.sck') }
      it { is_expected.to contain_octavia_config('driver_agent/stats_socket_path').with_value('/var/run/octavia/bar.sck') }
      it { is_expected.to contain_octavia_config('driver_agent/get_socket_path').with_value('/var/run/octavia/pikachu.sck') }
      it { is_expected.to contain_octavia_config('driver_agent/status_request_timeout').with_value(60)}
      it { is_expected.to contain_octavia_config('driver_agent/status_max_processes').with_value(10) }
      it { is_expected.to contain_octavia_config('driver_agent/stats_request_timeout').with_value(60) }
      it { is_expected.to contain_octavia_config('driver_agent/stats_max_processes').with_value(10) }
      it { is_expected.to contain_octavia_config('driver_agent/get_request_timeout').with_value(60) }
      it { is_expected.to contain_octavia_config('driver_agent/get_max_processes').with_value(10) }
      it { is_expected.to contain_octavia_config('driver_agent/max_process_warning_percent').with_value(0.60) }
      it { is_expected.to contain_octavia_config('driver_agent/provider_agent_shutdown_timeout').with_value(60) }
      it { is_expected.to contain_octavia_config('driver_agent/enabled_provider_agents').with_value(['agent-a', 'agent-b']) }
    end
  end


  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end
      it_behaves_like 'octavia-driver-agent'
    end
  end

end
