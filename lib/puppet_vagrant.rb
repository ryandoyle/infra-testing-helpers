require 'puppet_vagrant/helper'

module PuppetVagrant

  @settings = {
    :module_path => 'modules/',
    :site_pp     => '',
  }

  def self.site_pp
    @settings[:site_pp]
  end

  def self.site_pp=(puppet_code)
    @settings[:site_pp] = puppet_code
  end

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
