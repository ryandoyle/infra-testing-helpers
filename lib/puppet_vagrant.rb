require 'puppet_vagrant/helper'

module PuppetVagrant

  @settings = { :module_path => 'modules/' }

  def self.module_path
    @settings[:module_path]
  end

  def self.module_path=(path)
    @settings[:module_path] = path
  end

end

include PuppetVagrant::Helper

RSpec.configure do |c|
  c.before(:suite)   { apply_all_manifests }
end
