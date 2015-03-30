require 'spec_helper'

require 'serverspec'
require 'net/ssh'
require 'tempfile'
require 'puppet_vagrant'

PuppetVagrant.module_path = 'spec/functional/modules/'
PuppetVagrant.site_pp = "notify {'This is my site.pp':}"

set :backend, :ssh

host = 'default'

`vagrant up #{host}`

config = Tempfile.new('', Dir.tmpdir)
config.write(`vagrant ssh-config #{host}`)
config.close

options = Net::SSH::Config.for(host, [config.path])

options[:user] ||= Etc.getlogin

set :host,        options[:host_name] || host
set :ssh_options, options
