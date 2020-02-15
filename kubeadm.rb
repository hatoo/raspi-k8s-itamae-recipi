execute "install docker" do
  not_if "which docker"
  user "root"
  command "curl -fsSL https://get.docker.com | sh"
end

service "dphys-swapfile.service" do
  action [:stop, :disable]
end

["iptables", "arptables", "ebtables"].each do |package_name|
  package package_name
end

[
  ["iptables", "/usr/sbin/iptables-legacy"],
  ["ip6tables", "/usr/sbin/ip6tables-legacy"],
  ["arptables", "/usr/sbin/arptables-legacy"],
  ["ebtables", "/usr/sbin/ebtables-legacy"],
].each do |name, p|
  alternatives name do
    path p
  end
end

["apt-transport-https", "curl"].each do |p|
  package p
end

execute "apt update" do
  subscribes :run, "remote_file[/etc/apt/sources.list.d/kubernetes.list]", :immediately
  action :nothing
end

execute "apt-key add for k8s" do
  not_if "apt-key list | grep 'Google Cloud Packages Automatic Signing Key'"
  user "root"
  command "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -"
end

remote_file "/etc/apt/sources.list.d/kubernetes.list" do
  owner "root"
  group "root"
  mode "644"
  source "./kubernetes.list"
end

["kubelet", "kubeadm", "kubectl"].each do |package_name|
  package package_name
end
