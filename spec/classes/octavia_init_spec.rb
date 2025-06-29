require 'spec_helper'

describe 'octavia' do

  shared_examples 'octavia' do

    context 'with default parameters' do
      let :params do
        { :purge_config => false  }
      end

      it 'contains the deps class' do
        is_expected.to contain_class('octavia::deps')
      end

      it 'installs packages' do
        is_expected.to contain_package('octavia').with(
          :name   => platform_params[:octavia_common_package],
          :ensure => 'present',
          :tag    => ['openstack', 'octavia-package']
        )
      end

      it 'passes purge to resource' do
        is_expected.to contain_resources('octavia_config').with({
          :purge => false
        })
      end

      it 'configures rabbit' do
        should contain_oslo__messaging__default('octavia_config').with(
          :executor_thread_pool_size => '<SERVICE DEFAULT>',
          :transport_url             => '<SERVICE DEFAULT>',
          :rpc_response_timeout      => '<SERVICE DEFAULT>',
          :control_exchange          => '<SERVICE DEFAULT>',
        )
        should contain_oslo__messaging__rabbit('octavia_config').with(
          :rabbit_ha_queues                => '<SERVICE DEFAULT>',
          :heartbeat_timeout_threshold     => '<SERVICE DEFAULT>',
          :heartbeat_rate                  => '<SERVICE DEFAULT>',
          :heartbeat_in_pthread            => nil,
          :rabbit_qos_prefetch_count       => '<SERVICE DEFAULT>',
          :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
          :kombu_reconnect_delay           => '<SERVICE DEFAULT>',
          :kombu_failover_strategy         => '<SERVICE DEFAULT>',
          :kombu_ssl_version               => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile               => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile              => '<SERVICE DEFAULT>',
          :kombu_ssl_ca_certs              => '<SERVICE DEFAULT>',
          :kombu_compression               => '<SERVICE DEFAULT>',
          :amqp_durable_queues             => '<SERVICE DEFAULT>',
          :amqp_auto_delete                => '<SERVICE DEFAULT>',
          :rabbit_quorum_queue             => '<SERVICE DEFAULT>',
          :rabbit_transient_quorum_queue   => '<SERVICE DEFAULT>',
          :rabbit_transient_queues_ttl     => '<SERVICE DEFAULT>',
          :rabbit_quorum_delivery_limit    => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_length => '<SERVICE DEFAULT>',
          :rabbit_quorum_max_memory_bytes  => '<SERVICE DEFAULT>',
          :use_queue_manager               => '<SERVICE DEFAULT>',
          :rabbit_stream_fanout            => '<SERVICE DEFAULT>',
          :enable_cancel_on_failover       => '<SERVICE DEFAULT>',
        )
        should contain_oslo__messaging__notifications('octavia_config').with(
          :transport_url => '<SERVICE DEFAULT>',
          :driver        => '<SERVICE DEFAULT>',
          :topics        => '<SERVICE DEFAULT>',
          :retry         => '<SERVICE DEFAULT>',
        )
      end
    end

    it 'has default RPC topic' do
      is_expected.to contain_octavia_config('oslo_messaging/topic').with_value('octavia-rpc')
    end

    context 'with overridden parameters' do
      let :params do
        {
          :default_transport_url              => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout               => '120',
          :control_exchange                   => 'octavia',
          :executor_thread_pool_size          => 64,
          :rabbit_ha_queues                   => true,
          :rabbit_heartbeat_timeout_threshold => '60',
          :rabbit_heartbeat_rate              => '10',
          :rabbit_heartbeat_in_pthread        => true,
          :rabbit_qos_prefetch_count          => 0,
          :rabbit_quorum_queue                => true,
          :rabbit_transient_quorum_queue      => true,
          :rabbit_transient_queues_ttl        => 60,
          :rabbit_quorum_delivery_limit       => 3,
          :rabbit_quorum_max_memory_length    => 5,
          :rabbit_quorum_max_memory_bytes     => 1073741824,
          :rabbit_use_queue_manager           => true,
          :rabbit_stream_fanout               => true,
          :rabbit_enable_cancel_on_failover   => false,
          :kombu_compression                  => 'gzip',
          :kombu_reconnect_delay              => '5.0',
          :kombu_failover_strategy            => 'shuffle',
          :amqp_durable_queues                => true,
          :amqp_auto_delete                   => true,
          :package_ensure                     => '2012.1.1-15.el6',
          :notification_transport_url         => 'rabbit://rabbit_user:password@localhost:5673',
          :notification_driver                => 'ceilometer.compute.octavia_notifier',
          :notification_topics                => 'openstack',
          :notification_retry                 => 10,
          :topic                              => 'oct-rpc',
        }
      end

      it 'configures rabbit' do
        should contain_oslo__messaging__default('octavia_config').with(
          :executor_thread_pool_size => 64,
          :transport_url             => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout      => '120',
          :control_exchange          => 'octavia',
        )
        should contain_oslo__messaging__rabbit('octavia_config').with(
          :rabbit_ha_queues                => true,
          :heartbeat_timeout_threshold     => '60',
          :heartbeat_rate                  => '10',
          :heartbeat_in_pthread            => true,
          :rabbit_qos_prefetch_count       => 0,
          :rabbit_use_ssl                  => '<SERVICE DEFAULT>',
          :kombu_reconnect_delay           => '5.0',
          :kombu_failover_strategy         => 'shuffle',
          :kombu_ssl_version               => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile               => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile              => '<SERVICE DEFAULT>',
          :kombu_ssl_ca_certs              => '<SERVICE DEFAULT>',
          :kombu_compression               => 'gzip',
          :amqp_durable_queues             => true,
          :amqp_auto_delete                => true,
          :rabbit_quorum_queue             => true,
          :rabbit_transient_quorum_queue   => true,
          :rabbit_transient_queues_ttl     => 60,
          :rabbit_quorum_delivery_limit    => 3,
          :rabbit_quorum_max_memory_length => 5,
          :rabbit_quorum_max_memory_bytes  => 1073741824,
          :use_queue_manager               => true,
          :rabbit_stream_fanout            => true,
          :enable_cancel_on_failover       => false,
        )
        should contain_oslo__messaging__notifications('octavia_config').with(
          :transport_url => 'rabbit://rabbit_user:password@localhost:5673',
          :driver        => 'ceilometer.compute.octavia_notifier',
          :topics        => 'openstack',
          :retry         => 10,
        )
      end

      it 'configures various things' do
        is_expected.to contain_octavia_config('oslo_messaging/topic').with_value('oct-rpc')
      end
    end

    context 'with default parameters' do
      it { is_expected.to contain_class('octavia::db') }
      it { is_expected.to contain_oslo__db('octavia_config').with(
        :db_max_retries => '<SERVICE DEFAULT>',
        :connection     => 'sqlite:////var/lib/octavia/octavia.sqlite',
        :max_pool_size  => '<SERVICE DEFAULT>',
        :max_retries    => '<SERVICE DEFAULT>',
        :retry_interval => '<SERVICE DEFAULT>',
        :max_overflow   => '<SERVICE DEFAULT>',
        :pool_timeout   => '<SERVICE DEFAULT>',
      )}
    end

    context 'with rabbit ssl enabled with kombu' do
      let :params do
        { :default_transport_url => 'rabbit://rabbit:5673/',
          :rabbit_use_ssl        => true,
          :kombu_ssl_ca_certs    => '/etc/ca.cert',
          :kombu_ssl_certfile    => '/etc/certfile',
          :kombu_ssl_keyfile     => '/etc/key',
          :kombu_ssl_version     => 'TLSv1', }
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__rabbit('octavia_config').with(
          :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '/etc/ca.cert',
          :kombu_ssl_certfile => '/etc/certfile',
          :kombu_ssl_keyfile  => '/etc/key',
          :kombu_ssl_version  => 'TLSv1',
        )
      end
    end

    context 'with rabbit ssl enabled without kombu' do
      let :params do
        { :rabbit_use_ssl => true, }
      end

      it 'configures rabbit' do
        is_expected.to contain_oslo__messaging__rabbit('octavia_config').with(
          :rabbit_use_ssl     => true,
          :kombu_ssl_ca_certs => '<SERVICE DEFAULT>',
          :kombu_ssl_certfile => '<SERVICE DEFAULT>',
          :kombu_ssl_keyfile  => '<SERVICE DEFAULT>',
          :kombu_ssl_version  => '<SERVICE DEFAULT>',
        )
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :octavia_common_package => 'octavia-common' }
        when 'RedHat'
          { :octavia_common_package => 'openstack-octavia-common' }
        end
      end
      it_behaves_like 'octavia'
    end
  end


end
