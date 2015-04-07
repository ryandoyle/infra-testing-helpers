require 'infra_testing_helpers/box'
require 'infra_testing_helpers/site'

module InfraTestingHelpers
  module Helper

    def apply_manifest(manifest_code)
      if box.applied?
        local_site = InfraTestingHelpers::Site.new(InfraTestingHelpers.site_pp, InfraTestingHelpers.module_path)
        local_site.add_manifest(manifest_code)
        box.apply(local_site)
      else
        global_site.add_manifest(manifest_code)
      end

    end

    def apply_all_manifests
      box.apply(global_site)
    end

    private

    def global_site
      @@global_site ||= InfraTestingHelpers::Site.new(InfraTestingHelpers.site_pp, InfraTestingHelpers.module_path)
    end

    def box
      @@box ||= InfraTestingHelpers::Box.new('default', InfraTestingHelpers.vagrant_shared_folder)
    end

  end
end
