require 'spec_helper'

describe 'octavia::controller' do

  shared_examples_for 'octavia-controller' do

    let :req_params do
      { :heartbeat_key => 'abcdefghi' }
    end

    context 'with invalid lb topology' do
      let :params do
        req_params.merge({
          :loadbalancer_topology => 'foo'
        })
      end
      it { is_expected.to raise_error(Puppet::Error) }
    end

    context 'configured with specific parameters' do
      let :params do
        req_params.merge({
          :amp_active_retries                 => '30',
          :amp_active_wait_sec                => '10',
          :amp_flavor_id                      => '42',
          :amp_image_tag                      => 'amphorae1',
          :amp_image_owner_id                 => 'customowner',
          :amp_secgroup_list                  => ['lb-mgmt-sec-grp'],
          :amp_boot_network_list              => ['lbnet1', 'lbnet2'],
          :loadbalancer_topology              => 'SINGLE',
          :amphora_driver                     => 'sample_amphora_driver',
          :compute_driver                     => 'sample_compute_driver',
          :network_driver                     => 'sample_network_driver',
          :volume_driver                      => 'sample_volume_driver',
          :image_driver                       => 'sample_image_driver',
          :amp_ssh_key_name                   => 'custom-amphora-key',
          :amp_timezone                       => 'UTC',
          :amphora_delete_retries             => 5,
          :amphora_delete_retry_interval      => 5,
          :event_notifications                => true,
          :timeout_client_data                => 60,
          :timeout_member_connect             => 5,
          :timeout_member_data                => 60,
          :connection_max_retries             => 240,
          :connection_retry_interval          => 10,
          :active_connection_max_retries      => 15,
          :active_connection_retry_interval   => 2,
          :failover_connection_max_retries    => 2,
          :failover_connection_retry_interval => 5,
          :connection_logging                 => false,
          :build_rate_limit                   => 10,
          :build_active_retries               => 120,
          :build_retry_interval               => 5,
          :default_connection_limit           => 50000,
          :agent_request_read_timeout         => 180,
          :agent_tls_protocol                 => 'TLSv1.2',
          :admin_log_targets                  => ['192.0.2.1:10514', '2001:db8:1::10:10514'],
          :administrative_log_facility        => 2,
          :forward_all_logs                   => true,
          :tenant_log_targets                 => ['192.0.2.1:10514', '2001:db8:1::10:10514'],
          :user_log_facility                  => 3,
          :user_log_format                    => '{{ project_id }} {{ lb_id }}',
          :log_protocol                       => 'TCP',
          :log_retry_count                    => 5,
          :log_retry_interval                 => 2,
          :log_queue_size                     => 10000,
          :logging_template_override          => 'mycustomtemplate',
          :disable_local_log_storage          => true,
          :vrrp_advert_int                    => 1,
          :vrrp_check_interval                => 5,
          :vrrp_fail_count                    => 2,
          :vrrp_success_count                 => 2,
          :vrrp_garp_refresh_interval         => 5,
          :vrrp_garp_refresh_count            => 2,
          :controller_ip_port_list            => ['1.2.3.4:5555', '4.3.2.1:5555'],
          :heartbeat_interval                 => 10,
        })
      end

      it 'configures with the specified values' do
        is_expected.to contain_octavia_config('controller_worker/amp_active_retries').with_value('30')
        is_expected.to contain_octavia_config('controller_worker/amp_active_wait_sec').with_value('10')
        is_expected.to contain_octavia_config('controller_worker/amp_flavor_id').with_value('42')
        is_expected.to contain_octavia_config('controller_worker/amp_image_tag').with_value('amphorae1')
        is_expected.to contain_octavia_config('controller_worker/amp_image_owner_id').with_value('customowner')
        is_expected.to contain_octavia_config('controller_worker/amp_secgroup_list').with_value('lb-mgmt-sec-grp')
        is_expected.to contain_octavia_config('controller_worker/amp_boot_network_list').with_value('lbnet1,lbnet2')
        is_expected.to contain_octavia_config('controller_worker/loadbalancer_topology').with_value('SINGLE')
        is_expected.to contain_octavia_config('controller_worker/amphora_driver').with_value('sample_amphora_driver')
        is_expected.to contain_octavia_config('controller_worker/compute_driver').with_value('sample_compute_driver')
        is_expected.to contain_octavia_config('controller_worker/network_driver').with_value('sample_network_driver')
        is_expected.to contain_octavia_config('controller_worker/volume_driver').with_value('sample_volume_driver')
        is_expected.to contain_octavia_config('controller_worker/image_driver').with_value('sample_image_driver')
        is_expected.to contain_octavia_config('controller_worker/amp_ssh_key_name').with_value('custom-amphora-key')
        is_expected.to contain_octavia_config('controller_worker/amp_timezone').with_value('UTC')
        is_expected.to contain_octavia_config('controller_worker/amphora_delete_retries').with_value(5)
        is_expected.to contain_octavia_config('controller_worker/amphora_delete_retry_interval').with_value(5)
        is_expected.to contain_octavia_config('controller_worker/event_notifications').with_value(true)
        is_expected.to contain_octavia_config('haproxy_amphora/timeout_client_data').with_value(60)
        is_expected.to contain_octavia_config('haproxy_amphora/timeout_member_connect').with_value(5)
        is_expected.to contain_octavia_config('haproxy_amphora/timeout_member_data').with_value(60)
        is_expected.to contain_octavia_config('haproxy_amphora/connection_max_retries').with_value(240)
        is_expected.to contain_octavia_config('haproxy_amphora/connection_retry_interval').with_value(10)
        is_expected.to contain_octavia_config('haproxy_amphora/connection_logging').with_value(false)
        is_expected.to contain_octavia_config('haproxy_amphora/active_connection_max_retries').with_value(15)
        is_expected.to contain_octavia_config('haproxy_amphora/active_connection_retry_interval').with_value(2)
        is_expected.to contain_octavia_config('haproxy_amphora/failover_connection_max_retries').with_value(2)
        is_expected.to contain_octavia_config('haproxy_amphora/failover_connection_retry_interval').with_value(5)
        is_expected.to contain_octavia_config('haproxy_amphora/build_rate_limit').with_value(10)
        is_expected.to contain_octavia_config('haproxy_amphora/build_active_retries').with_value(120)
        is_expected.to contain_octavia_config('haproxy_amphora/build_retry_interval').with_value(5)
        is_expected.to contain_octavia_config('haproxy_amphora/default_connection_limit').with_value(50000)
        is_expected.to contain_octavia_config('amphora_agent/agent_request_read_timeout').with_value(180)
        is_expected.to contain_octavia_config('amphora_agent/agent_tls_protocol').with_value('TLSv1.2')
        is_expected.to contain_octavia_config('amphora_agent/admin_log_targets').with_value('192.0.2.1:10514,2001:db8:1::10:10514')
        is_expected.to contain_octavia_config('amphora_agent/administrative_log_facility').with_value(2)
        is_expected.to contain_octavia_config('amphora_agent/forward_all_logs').with_value(true)
        is_expected.to contain_octavia_config('amphora_agent/tenant_log_targets').with_value('192.0.2.1:10514,2001:db8:1::10:10514')
        is_expected.to contain_octavia_config('amphora_agent/user_log_facility').with_value(3)
        is_expected.to contain_octavia_config('haproxy_amphora/user_log_format').with_value('{{ project_id }} {{ lb_id }}')
        is_expected.to contain_octavia_config('amphora_agent/log_protocol').with_value('TCP')
        is_expected.to contain_octavia_config('amphora_agent/log_retry_count').with_value(5)
        is_expected.to contain_octavia_config('amphora_agent/log_retry_interval').with_value(2)
        is_expected.to contain_octavia_config('amphora_agent/log_queue_size').with_value(10000)
        is_expected.to contain_octavia_config('amphora_agent/logging_template_override').with_value('mycustomtemplate')
        is_expected.to contain_octavia_config('amphora_agent/disable_local_log_storage').with_value(true)
        is_expected.to contain_octavia_config('keepalived_vrrp/vrrp_advert_int').with_value(1)
        is_expected.to contain_octavia_config('keepalived_vrrp/vrrp_check_interval').with_value(5)
        is_expected.to contain_octavia_config('keepalived_vrrp/vrrp_fail_count').with_value(2)
        is_expected.to contain_octavia_config('keepalived_vrrp/vrrp_success_count').with_value(2)
        is_expected.to contain_octavia_config('keepalived_vrrp/vrrp_garp_refresh_interval').with_value(5)
        is_expected.to contain_octavia_config('keepalived_vrrp/vrrp_garp_refresh_count').with_value(2)
        is_expected.to contain_octavia_config('health_manager/controller_ip_port_list').with_value('1.2.3.4:5555,4.3.2.1:5555')
        is_expected.to contain_octavia_config('health_manager/heartbeat_interval').with_value(10)
      end
    end

    context 'configured with defaults' do
      let :params do
        req_params
      end

      it 'configures with the default values' do
        is_expected.to contain_octavia_config('controller_worker/amp_active_retries').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('controller_worker/amp_active_wait_sec').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('controller_worker/amp_flavor_id').with_value('65')
        is_expected.to contain_octavia_config('controller_worker/amp_image_tag').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('controller_worker/amp_image_owner_id').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('controller_worker/amp_secgroup_list').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('controller_worker/amp_boot_network_list').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('controller_worker/loadbalancer_topology').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('controller_worker/amphora_driver').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('controller_worker/compute_driver').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('controller_worker/network_driver').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('controller_worker/volume_driver').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('controller_worker/image_driver').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('controller_worker/amp_ssh_key_name').with_value('octavia-ssh-key')
        is_expected.to contain_octavia_config('controller_worker/amp_timezone').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('controller_worker/amphora_delete_retries').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('controller_worker/amphora_delete_retry_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('controller_worker/event_notifications').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/timeout_client_data').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/timeout_member_connect').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/timeout_member_data').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/timeout_tcp_inspect').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/connection_max_retries').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/connection_retry_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/connection_logging').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/active_connection_max_retries').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/active_connection_retry_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/failover_connection_max_retries').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/failover_connection_retry_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/build_rate_limit').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/build_active_retries').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/build_retry_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/default_connection_limit').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('amphora_agent/agent_request_read_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('amphora_agent/agent_tls_protocol').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('amphora_agent/admin_log_targets').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('amphora_agent/administrative_log_facility').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('amphora_agent/forward_all_logs').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('amphora_agent/tenant_log_targets').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('amphora_agent/user_log_facility').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('haproxy_amphora/user_log_format').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('amphora_agent/log_protocol').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('amphora_agent/log_retry_count').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('amphora_agent/log_retry_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('amphora_agent/log_queue_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('amphora_agent/logging_template_override').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('amphora_agent/disable_local_log_storage').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('keepalived_vrrp/vrrp_advert_int').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('keepalived_vrrp/vrrp_check_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('keepalived_vrrp/vrrp_fail_count').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('keepalived_vrrp/vrrp_success_count').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('keepalived_vrrp/vrrp_garp_refresh_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('keepalived_vrrp/vrrp_garp_refresh_count').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('health_manager/controller_ip_port_list').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('health_manager/heartbeat_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_octavia_config('health_manager/heartbeat_key').with_value('abcdefghi')
      end
    end

    context 'with ssh key access disabled' do
      let :params do
        req_params.merge({
          :enable_ssh_access => false
        })
      end

      it 'disables configuration of SSH key properties' do
        is_expected.to contain_octavia_config('controller_worker/amp_ssh_key_name').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with an invalid value for heartbeat key' do
      let :params do
        req_params.merge({
          :heartbeat_key => 0,
        })
      end
      it { expect { is_expected.to raise_error(Puppet::Error) } }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end
      it_behaves_like 'octavia-controller'
    end
  end

end
