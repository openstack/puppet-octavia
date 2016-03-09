Puppet::Type.type(:octavia_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/octavia/octavia.conf'
  end

end
