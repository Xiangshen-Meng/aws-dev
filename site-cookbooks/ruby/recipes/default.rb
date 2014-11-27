# Basic package

package "openssl-devel"
package "zlib-devel"
package "readline-devel"
package "libxml2-devel"
package "libxslt-devel"

git "/home/#{node['ruby']['user']}/.rbenv" do
  action :sync
  repository node['ruby']['rbenv_url']
  user node['ruby']['user']
  group node['ruby']['group']
end

template ".bash_profile" do
  source "bash_profile.erb"
  path "/home/#{node['ruby']['user']}/.bash_profile"
  mode 0644
  owner node['ruby']['user']
  group node['ruby']['group']
  not_if "grep rbenv /home/#{node['ruby']['user']}/.bash_profile"
end

directory "/home/#{node['ruby']['user']}/.rbenv/plugins" do
  owner node['ruby']['user']
  group node['ruby']['group']
  mode 0755
  action :create
end

git "/home/#{node['ruby']['user']}/.rbenv/plugins/ruby-build" do
  repository node['ruby']['ruby_build_url']
  action :sync
  user node['ruby']['user']
  group node['ruby']['group']
end

execute "rbenv install #{node['ruby']['version']}" do
  command "/home/#{node['ruby']['user']}/.rbenv/bin/rbenv install #{node['ruby']['version']} && /home/#{node['ruby']['user']}/.rbenv/bin/rbenv global #{node['ruby']['version']}"
  user node['ruby']['user']
  group node['ruby']['group']
  environment 'HOME' => "/home/#{node['ruby']['user']}"
  not_if { File.exists? "/home/#{node['ruby']['user']}/.rbenv/versions/#{node['ruby']['version']}" }
end

bash "gem install bundle" do
  user node['ruby']['user']
  group node['ruby']['group']
  cwd "/home/#{node['ruby']['user']}"
  code <<-EOC
    /home/#{node['ruby']['user']}/.rbenv/shims/gem install bundle
  EOC
end
