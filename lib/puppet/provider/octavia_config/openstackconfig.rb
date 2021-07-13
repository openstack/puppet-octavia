Puppet::Type.type(:octavia_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/octavia/octavia.conf'
  end

end
