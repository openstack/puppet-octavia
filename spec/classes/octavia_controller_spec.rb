require 'spec_helper'

describe 'octavia::controller' do

  shared_examples_for 'octavia-controller' do

    context 'with invalid lb topology' do
      let :params do
        { :loadbalancer_topology => 'foo', }
      end
      it { is_expected.to raise_error(Puppet::Error) }
    end

    context 'configured with specific parameters' do
      let :params do
        { :amp_flavor_id         => '42',
          :amp_image_tag         => 'amphorae1',
          :amp_secgroup_list     => ['lb-mgmt-sec-grp'],
          :amp_boot_network_list => ['lbnet1', 'lbnet2'],
          :loadbalancer_topology => 'SINGLE',
          :amp_ssh_key_name      => 'custom-amphora-key',
        }
      end

      it { is_expected.to contain_octavia_config('controller_worker/amp_flavor_id').with_value('42') }
      it { is_expected.to contain_octavia_config('controller_worker/amp_image_tag').with_value('amphorae1') }
      it { is_expected.to contain_octavia_config('controller_worker/amp_secgroup_list').with_value(['lb-mgmt-sec-grp']) }
      it { is_expected.to contain_octavia_config('controller_worker/amp_boot_network_list').with_value(['lbnet1', 'lbnet2']) }
      it { is_expected.to contain_octavia_config('controller_worker/loadbalancer_topology').with_value('SINGLE') }
      it { is_expected.to contain_octavia_config('controller_worker/amp_ssh_key_name').with_value('custom-amphora-key') }
    end

    it 'configures worker parameters' do
      is_expected.to contain_octavia_config('controller_worker/amp_flavor_id').with_value('65')
      is_expected.to contain_octavia_config('controller_worker/amphora_driver').with_value('amphora_haproxy_rest_driver')
      is_expected.to contain_octavia_config('controller_worker/compute_driver').with_value('compute_nova_driver')
      is_expected.to contain_octavia_config('controller_worker/network_driver').with_value('allowed_address_pairs_driver')
      is_expected.to contain_octavia_config('controller_worker/amp_ssh_key_name').with_value('octavia-ssh-key')
      is_expected.to contain_octavia_config('haproxy_amphora/timeout_client_data').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_octavia_config('haproxy_amphora/timeout_member_connect').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_octavia_config('haproxy_amphora/timeout_member_data').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_octavia_config('haproxy_amphora/timeout_tcp_inspect').with_value('<SERVICE DEFAULT>')
    end

    context 'with ssh key access disabled' do
      let :params do
        { :enable_ssh_access => false }
      end

      it 'disables configuration of SSH key properties' do
        is_expected.to contain_octavia_config('controller_worker/amp_ssh_key_name').with_value('<SERVICE DEFAULT>')
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
      it_behaves_like 'octavia-controller'
    end
  end

end
