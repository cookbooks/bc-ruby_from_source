#
# Cookbook Name:: ruby_from_source
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "build-essential"
package "openssl-devel"
package "libxml2-devel"
package "libxslt-devel"
package "libffi-devel"
package "openssl-devel"
package "mysql-devel"


directory "/var/builder"

remote_file "/var/builder/#{node.ruby_from_source.ruby_version}.tar.gz" do
  source "http://ftp.ruby-lang.org/pub/ruby/1.9/#{node.ruby_from_source.ruby_version}.tar.gz"
  action :create_if_missing
  checksum node.ruby_from_source.ruby_tarball_checksum
end

remote_file "/var/builder/#{node.ruby_from_source.yaml_version}.tar.gz" do
  source "http://pyyaml.org/download/libyaml/#{node.ruby_from_source.yaml_version}.tar.gz"
  action :create_if_missing
  checksum node.ruby_from_source.yaml_tarball_checksum
end

script "Install #{node.ruby_from_source.yaml_version} from source" do
  not_if "test -f /var/builder/#{node.ruby_from_source.yaml_version}/install_complete"
  interpreter "bash"
  user "root"
  cwd "/var/builder"
  code <<-EOH
  tar xzf /var/builder/#{node.ruby_from_source.yaml_version}.tar.gz || exit 1
  cd #{node.ruby_from_source.yaml_version} || exit 1
  ./configure --prefix=#{node.ruby_from_source.prefix}
  make
  make install || exit 1
  touch install_complete
  EOH
end

script "Install #{node.ruby_from_source.ruby_version} from source" do
  not_if "test -f /var/builder/#{node.ruby_from_source.ruby_version}/install_complete"
  interpreter "bash"
  user "root"
  cwd "/var/builder"
  code <<-EOH
  tar xzf /var/builder/#{node.ruby_from_source.ruby_version}.tar.gz || exit 1
  cd #{node.ruby_from_source.ruby_version} || exit 1
  ./configure --prefix=#{node.ruby_from_source.prefix} --enable-shared --disable-install-doc --with-opt-dir=#{node.ruby_from_source.prefix}
  make
  make install || exit 1
  #{node.ruby_from_source.prefix}/bin/gem install bundler mysql right_aws || exit 1
  touch install_complete
  EOH
end