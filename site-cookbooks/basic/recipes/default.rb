# Update all
execute "yum-update" do
  user "root"
  command "yum -y update"
  action :run
end

# Timezone
bash "Unzip wordpress" do
  user "root"
  cwd "/tmp"
  code <<-EOC
    mv /etc/localtime /etc/localtime.bak
    ln -s /usr/share/zoneinfo/Japan /etc/localtime
  EOC
end

service "ntpd" do
  action [ :enable, :start ]
end

# Basic build package for AWS EC2
package 'autoconf'
package 'bison'
package 'flex'
package 'gcc'
package 'gcc-c++'
package 'kernel-devel'
package 'make'
package 'm4'
package 'patch'

package 'git'
package 'curl'
package 'mysql-devel'

# Change permission
directory "/home/ec2-user" do
  mode      "0755"
end