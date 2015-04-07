require 'spec_helper'

require 'serverspec'
require 'net/ssh'
require 'tempfile'
require 'infra_testing_helpers'

InfraTestingHelpers.module_path = 'spec/functional/modules/'
InfraTestingHelpers.site_pp = 'notify {"This is my site.pp":}
$extlookup_precedence = ["hosts/%{fqdn}", "domains/%{domain}", "common"]
'
InfraTestingHelpers.project_root = File.expand_path(File.dirname(__FILE__) + '/../')

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
