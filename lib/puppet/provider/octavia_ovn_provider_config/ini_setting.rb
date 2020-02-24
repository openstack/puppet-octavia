Puppet::Type.type(:octavia_ovn_provider_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/octavia/conf.d/ovn.conf'
  end

end
