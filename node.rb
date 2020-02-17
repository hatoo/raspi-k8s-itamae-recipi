execute "hostnamectl set-hostname #{node["hostname"]}" do
  not_if "test $(hostname) = #{node["hostname"]}"
end

template "/etc/dhcpcd.conf" do
  source "./dhcpcd.conf.erb"
  variables(node: node)
end

execute "Add my host to /etc/hosts" do
  not_if "grep #{node["hostname"]} /etc/hosts"
  user "root"
  command "echo 127.0.1.1 #{node["hostname"]} >> /etc/hosts"
end

include_recipe "./kubeadm.rb"
