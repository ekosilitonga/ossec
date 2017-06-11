property :name, String, name_property: true
property :package_name, String, default: lazy {
  case node['platform_family']
  when 'debian'
    'ossec-hids-agent'
  else
    'ossec-hids-client'
  end
}

action :install do
  case node['platform_family']
  when %w(centos redhat scientific oracle fedora amazon)
    include_recipe 'yum-atomic'
  when 'debian'
    package 'lsb-release'

    ohai 'reload lsb' do
      plugin 'lsb'
      action :nothing
      subscribes :reload, 'package[lsb-release]', :immediately
    end

    apt_repository 'ossec' do
      uri 'http://ossec.wazuh.com/repos/apt/' + node['platform']
      key 'http://ossec.wazuh.com/repos/apt/conf/ossec-key.gpg.key'
      distribution lazy { node['lsb']['codename'] }
      components ['main']
    end
  end

  package new_resource.package_name.to_s
end