require 'spec_helper'

describe 'octavia::task_flow' do
  shared_examples 'octavia::task_flow' do
    context 'with default parameters' do
      it 'configures the default values' do
        should contain_octavia_config('task_flow/engine').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/max_workers').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/disable_revert').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/jobboard_backend_driver').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/jobboard_enabled').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/jobboard_backend_hosts').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/jobboard_backend_port').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/jobboard_backend_username').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/jobboard_backend_password').with_value('<SERVICE DEFAULT>').with_secret(true)
        should contain_octavia_config('task_flow/jobboard_backend_namespace').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/jobboard_redis_backend_db').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/jobboard_redis_sentinel').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/jobboard_redis_sentinel_username').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/jobboard_redis_sentinel_password').with_value('<SERVICE DEFAULT>').with_secret(true)
        should contain_octavia_config('task_flow/jobboard_redis_backend_ssl_options').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/jobboard_redis_sentinel_ssl_options').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/jobboard_zookeeper_ssl_options').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/jobboard_etcd_ssl_options').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/jobboard_etcd_timeout').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/jobboard_etcd_api_path').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/jobboard_expiration_time').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/jobboard_save_logbook').with_value('<SERVICE DEFAULT>')
        should contain_octavia_config('task_flow/persistence_connection').with_value('<SERVICE DEFAULT>')
      end

      it 'should install python-redis' do
        should contain_package('python-redis').with(
          :ensure => 'installed',
          :name   => platform_params[:python_redis_package_name],
          :tag    => ['openstack'],
        )
      end

      it 'should not install python-kazoo' do
        should_not contain_package('python-kazoo')
      end
      it 'should not install python-etcd3gw' do
        should_not contain_package('python-etcd3gw')
      end
    end

    context 'with specified parameters' do
      let :params do
        {
          :engine                              => 'parallel',
          :max_workers                         => 5,
          :disable_revert                      => false,
          :jobboard_backend_driver             => 'redis_taskflow_driver',
          :jobboard_enabled                    => true,
          :jobboard_backend_hosts              => ['192.168.0.2', '192.168.0.3'],
          :jobboard_backend_port               => 6379,
          :jobboard_backend_username           => 'user',
          :jobboard_backend_password           => 'secret',
          :jobboard_backend_namespace          => 'octavia_jobboard',
          :jobboard_redis_backend_db           => 0,
          :jobboard_redis_sentinel             => 'sentinel',
          :jobboard_redis_sentinel_username    => 'sentinel_user',
          :jobboard_redis_sentinel_password    => 'sentinel_secret',
          :jobboard_redis_backend_ssl_options  => ['ssl:false', 'ssl_keyfile:None'],
          :jobboard_redis_sentinel_ssl_options => ['ssl:false', 'ssl_keyfile:None'],
          :jobboard_zookeeper_ssl_options      => ['use_ssl:false', 'keyfile:None'],
          :jobboard_etcd_ssl_options           => ['use_ssl:false', 'cert_key:None'],
          :jobboard_etcd_timeout               => 60,
          :jobboard_etcd_api_path              => '/v1',
          :jobboard_expiration_time            => 30,
          :jobboard_save_logbook               => false,
          :persistence_connection              => 'sqlite://',
        }
      end

      it 'configures the given values' do
        should contain_octavia_config('task_flow/engine').with_value('parallel')
        should contain_octavia_config('task_flow/max_workers').with_value(5)
        should contain_octavia_config('task_flow/disable_revert').with_value(false)
        should contain_octavia_config('task_flow/jobboard_backend_driver').with_value('redis_taskflow_driver')
        should contain_octavia_config('task_flow/jobboard_enabled').with_value(true)
        should contain_octavia_config('task_flow/jobboard_backend_hosts').with_value('192.168.0.2,192.168.0.3')
        should contain_octavia_config('task_flow/jobboard_backend_port').with_value(6379)
        should contain_octavia_config('task_flow/jobboard_backend_username').with_value('user')
        should contain_octavia_config('task_flow/jobboard_backend_password').with_value('secret').with_secret(true)
        should contain_octavia_config('task_flow/jobboard_backend_namespace').with_value('octavia_jobboard')
        should contain_octavia_config('task_flow/jobboard_redis_backend_db').with_value(0)
        should contain_octavia_config('task_flow/jobboard_redis_sentinel').with_value('sentinel')
        should contain_octavia_config('task_flow/jobboard_redis_sentinel_username').with_value('sentinel_user')
        should contain_octavia_config('task_flow/jobboard_redis_sentinel_password').with_value('sentinel_secret').with_secret(true)
        should contain_octavia_config('task_flow/jobboard_redis_backend_ssl_options').with_value('ssl:false,ssl_keyfile:None')
        should contain_octavia_config('task_flow/jobboard_redis_sentinel_ssl_options').with_value('ssl:false,ssl_keyfile:None')
        should contain_octavia_config('task_flow/jobboard_zookeeper_ssl_options').with_value('use_ssl:false,keyfile:None')
        should contain_octavia_config('task_flow/jobboard_etcd_ssl_options').with_value('use_ssl:false,cert_key:None')
        should contain_octavia_config('task_flow/jobboard_etcd_timeout').with_value(60)
        should contain_octavia_config('task_flow/jobboard_etcd_api_path').with_value('/v1')
        should contain_octavia_config('task_flow/jobboard_expiration_time').with_value(30)
        should contain_octavia_config('task_flow/jobboard_save_logbook').with_value(false)
        should contain_octavia_config('task_flow/persistence_connection').with_value('sqlite://')
      end

      it 'should install python-redis' do
        should contain_package('python-redis').with(
          :ensure => 'installed',
          :name   => platform_params[:python_redis_package_name],
          :tag    => ['openstack'],
        )
      end

      it 'should not install python-kazoo' do
        should_not contain_package('python-kazoo')
      end
      it 'should not install python-etcd3gw' do
        should_not contain_package('python-etcd3gw')
      end
    end

    context 'with zookeeper driver' do
      let :params do
        {
          :jobboard_backend_driver => 'zookeeper_taskflow_driver',
        }
      end

      it 'should not install python-redis' do
        should_not contain_package('python-redis')
      end

      it 'should install python-kazoo' do
        should contain_package('python-kazoo').with(
          :ensure => 'installed',
          :name   => platform_params[:python_kazoo_package_name],
          :tag    => ['openstack'],
        )
      end

      it 'should not install python-etcd3gw' do
        should_not contain_package('python-etcd3gw')
      end
    end

    context 'with etcd driver' do
      let :params do
        {
          :jobboard_backend_driver => 'etcd_taskflow_driver',
        }
      end

      it 'should not install python-redis' do
        should_not contain_package('python-redis')
      end

      it 'should install python-kazoo' do
        should_not contain_package('python-kazoo')
      end

      it 'should install python-etcd3gw' do
        should contain_package('python-etcd3gw').with(
          :ensure => 'installed',
          :name   => platform_params[:python_etcd3gw_package_name],
          :tag    => ['openstack'],
        )
      end
    end

    context 'with ssl options set to dict' do
      let :params do
        {
          :jobboard_redis_backend_ssl_options => {
            'ssl'         => 'false',
            'ssl_keyfile' => 'None'
          },
          :jobboard_redis_sentinel_ssl_options => {
            'ssl'         => 'false',
            'ssl_keyfile' => 'None'
          },
          :jobboard_zookeeper_ssl_options     => {
            'use_ssl' => 'false',
            'keyfile' => 'None'
          },
          :jobboard_etcd_ssl_options          => {
            'use_ssl'  => 'false',
            'cert_key' => 'None',
          },
        }
      end

      it {
        should contain_octavia_config('task_flow/jobboard_redis_backend_ssl_options').with_value('ssl:false,ssl_keyfile:None')
        should contain_octavia_config('task_flow/jobboard_redis_sentinel_ssl_options').with_value('ssl:false,ssl_keyfile:None')
        should contain_octavia_config('task_flow/jobboard_zookeeper_ssl_options').with_value('use_ssl:false,keyfile:None')
        should contain_octavia_config('task_flow/jobboard_etcd_ssl_options').with_value('use_ssl:false,cert_key:None')
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

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          {
            :python_redis_package_name   => 'python3-redis',
            :python_kazoo_package_name   => 'python3-kazoo',
            :python_etcd3gw_package_name => 'python3-etcd3gw'
          }
        when 'RedHat'
          {
            :python_redis_package_name   => 'python3-redis',
            :python_kazoo_package_name   => 'python3-kazoo',
            :python_etcd3gw_package_name => 'python3-etcd3gw'
          }
        end
      end

      it_behaves_like 'octavia::task_flow'
    end
  end

end
