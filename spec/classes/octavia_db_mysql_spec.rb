require 'spec_helper'

describe 'octavia::db::mysql' do
  let :pre_condition do
    "include mysql::server
     include octavia::db::sync"
  end

  let :params do
    {
      :password => 'octaviapass',
    }
  end

  shared_examples 'octavia::db::mysql' do
    it { is_expected.to contain_class('octavia::deps') }

    context 'with only required params' do
      it { should contain_openstacklib__db__mysql('octavia').with(
        :user     => 'octavia',
        :password => 'octaviapass',
        :dbname   => 'octavia',
        :host     => '127.0.0.1',
        :charset  => 'utf8',
        :collate  => 'utf8_general_ci',
      )}
      it { should_not contain_openstacklib__db__mysql('octavia_persistence') }
    end

    context 'overriding allowed_hosts param to array' do
      before do
        params.merge!( :allowed_hosts  => ['127.0.0.1','%'] )
      end

      it { should contain_openstacklib__db__mysql('octavia').with(
        :user          => 'octavia',
        :password      => 'octaviapass',
        :dbname        => 'octavia',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => ['127.0.0.1','%']
      )}
    end

    context 'overriding allowed_hosts param to string' do
      before do
        params.merge!( :allowed_hosts  => '192.168.1.1' )
      end

      it { should contain_openstacklib__db__mysql('octavia').with(
        :user          => 'octavia',
        :password      => 'octaviapass',
        :dbname        => 'octavia',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => '192.168.1.1'
      )}
    end

    context 'with persistence database enabled' do
      before do
        params.merge!( :persistence_dbname => 'octavia_persistence'  )
      end

      it { should contain_openstacklib__db__mysql('octavia').with(
        :user     => 'octavia',
        :password => 'octaviapass',
        :dbname   => 'octavia',
        :host     => '127.0.0.1',
        :charset  => 'utf8',
        :collate  => 'utf8_general_ci',
      )}
      it { should contain_openstacklib__db__mysql('octavia_persistence').with(
        :user        => 'octavia',
        :password    => 'octaviapass',
        :dbname      => 'octavia_persistence',
        :host        => '127.0.0.1',
        :charset     => 'utf8',
        :collate     => 'utf8_general_ci',
        :create_user => false,
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'octavia::db::mysql'
    end
  end
end
