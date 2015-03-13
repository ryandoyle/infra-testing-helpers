require 'puppet_vagrant/helper'
include PuppetVagrant::Helper

RSpec.configure do |c|
  c.before(:suite)   { apply_all_manifests }
end
