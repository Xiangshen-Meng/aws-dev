remote_file "/tmp/#{node['nodejs']['filename']}" do
  source "#{node['nodejs']['remote_uri']}"
  not_if { File.exists? "/usr/local/bin/node" }
end

bash "install nodejs" do
  user "root"
  cwd "/tmp"
  code <<-EOC
    tar xvzf #{node['nodejs']['filename']}
    cd #{node['nodejs']['dirname']}
    make
    make install
  EOC
  not_if { File.exists? "/usr/local/bin/node" }
end

directory "/tmp/#{node['nodejs']['dirname']}" do
  recursive true
  action :delete
end

file "/tmp/#{node['nodejs']['filename']}" do
  action :delete
end
