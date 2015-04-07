require 'infra_testing_helpers/helper'

module InfraTestingHelpers

  @settings = {
    :module_path         => 'modules/',
    :site_pp             => '',
    :vagrant_shared_folder => '/vagrant'
  }

  def self.vagrant_shared_folder
    @settings[:vagrant_shared_folder]
  end

  def self.vagrant_shared_folder=(mount_point)
    @settings[:vagrant_shared_folder] = mount_point
  end

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

include InfraTestingHelpers::Helper

RSpec.configure do |c|
  c.before(:suite)   { apply_all_manifests }
end