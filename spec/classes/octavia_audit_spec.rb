require 'spec_helper'

describe 'octavia::audit' do

  shared_examples_for 'octavia::audit' do

    context 'with default parameters' do
      let :params do
        {}
      end

      it 'configures default values' do
        is_expected.to contain_octavia_config('audit/enabled').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_oslo__audit('octavia_config').with(
          :audit_map_file  => '<SERVICE DEFAULT>',
          :ignore_req_list => '<SERVICE DEFAULT>',
        )
      end
    end

    context 'with specific parameters' do
      let :params do
        {
          :enabled         => true,
          :audit_map_file  => '/etc/octavia/api_audit_map.conf',
          :ignore_req_list => ['GET', 'POST'],
        }
      end

      it 'configures specified values' do
        is_expected.to contain_octavia_config('audit/enabled').with_value(true)
        is_expected.to contain_oslo__audit('octavia_config').with(
          :audit_map_file  => '/etc/octavia/api_audit_map.conf',
          :ignore_req_list => ['GET', 'POST'],
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

      it_configures 'octavia::audit'
    end
  end

end
