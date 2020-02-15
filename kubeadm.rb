execute "install docker" do
  not_if "which docker"
  user "root"
  command "curl -fsSL https://get.docker.com | sh"
end

service "dphys-swapfile.service" do
  action :disable
end

["iptables", "arptables", "ebtables"].each do |package_name|
  package package_name do
  end
end
