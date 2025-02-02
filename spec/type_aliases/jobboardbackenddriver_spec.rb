require 'spec_helper'

describe 'Octavia::JobboardBackendDriver' do
  describe 'valid types' do
    context 'with valid types' do
      [
        'etcd_taskflow_driver',
        'redis_taskflow_driver',
        'zookeeper_taskflow_driver'
      ].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end
  end

  describe 'invalid types' do
    context 'with garbage inputs' do
      [
        'bad_taskflow_driver',
        'bad',
        ''
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end

