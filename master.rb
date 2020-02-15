include_recipe "./kubeadm.rb"

execute "hostnamectl set-hostname #{node["hostname"]}" do
  not_if "test $(hostname) = #{node["hostname"]}"
end
