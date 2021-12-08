require 'spec_helper'

describe 'octavia::wsgi::apache' do

  shared_examples_for 'apache serving octavia with mod_wsgi' do
    context 'with default parameters' do
      it { is_expected.to contain_class('octavia::params') }
      it { is_expected.to contain_openstacklib__wsgi__apache('octavia_wsgi').with(
        :bind_port                   => 9876,
        :group                       => 'octavia',
        :path                        => '/',
        :servername                  => facts[:fqdn],
        :ssl                         => false,
        :threads                     => 1,
        :user                        => 'octavia',
        :workers                     => facts[:os_workers],
        :wsgi_daemon_process         => 'octavia',
        :wsgi_process_group          => 'octavia',
        :wsgi_script_dir             => platform_params[:wsgi_script_path],
        :wsgi_script_file            => 'app',
        :wsgi_script_source          => platform_params[:wsgi_script_source],
        :custom_wsgi_process_options => {},
        :access_log_file             => false,
        :access_log_format           => false,
      )}
    end

    context 'when overriding parameters using different ports' do
      let :params do
        {
          :servername                  => 'dummy.host',
          :bind_host                   => '10.42.51.1',
          :port                        => 12345,
          :ssl                         => true,
          :wsgi_process_display_name   => 'octavia',
          :workers                     => 37,
          :custom_wsgi_process_options => {
            'python_path' => '/my/python/path',
          },
          :access_log_file             => '/var/log/httpd/access_log',
          :access_log_format           => 'some format',
          :error_log_file              => '/var/log/httpd/error_log',
          :vhost_custom_fragment       => 'Timeout 99'
        }
      end
      it { is_expected.to contain_class('octavia::params') }
      it { is_expected.to contain_openstacklib__wsgi__apache('octavia_wsgi').with(
        :bind_host                 => '10.42.51.1',
        :bind_port                 => 12345,
        :group                     => 'octavia',
        :path                      => '/',
        :servername                => 'dummy.host',
        :ssl                       => true,
        :threads                   => 1,
        :user                      => 'octavia',
        :workers                   => 37,
        :vhost_custom_fragment     => 'Timeout 99',
        :wsgi_daemon_process       => 'octavia',
        :wsgi_process_display_name => 'octavia',
        :wsgi_process_group        => 'octavia',
        :wsgi_script_file          => 'app',
        :custom_wsgi_process_options => {
          'python_path' => '/my/python/path',
        },
        :access_log_file           => '/var/log/httpd/access_log',
        :access_log_format         => 'some format',
        :error_log_file            => '/var/log/httpd/error_log'
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers     => 42,
          :concat_basedir => '/var/lib/puppet/concat',
          :fqdn           => 'some.host.tld',
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          {
            :httpd_service_name => 'apache2',
            :httpd_ports_file   => '/etc/apache2/ports.conf',
            :wsgi_script_path   => '/usr/lib/cgi-bin/octavia',
            :wsgi_script_source => '/usr/bin/octavia-wsgi',
          }
        when 'RedHat'
          {
            :httpd_service_name => 'httpd',
            :httpd_ports_file   => '/etc/httpd/conf/ports.conf',
            :wsgi_script_path   => '/var/www/cgi-bin/octavia',
            :wsgi_script_source => '/usr/bin/octavia-wsgi',
          }
        end
      end

      it_behaves_like 'apache serving octavia with mod_wsgi'
    end
  end
end
