require 'puppet_vagrant/box'
require 'puppet_vagrant/site'

module PuppetVagrant
  module Helper

    def apply_manifest(manifest_code)
      if box.applied?
        local_site = PuppetVagrant::Site.new(PuppetVagrant.site_pp, PuppetVagrant.module_path)
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
      @@global_site ||= PuppetVagrant::Site.new(PuppetVagrant.site_pp, PuppetVagrant.module_path)
    end

    def box
      @@box ||= PuppetVagrant::Box.new('default', PuppetVagrant.vagrant_shared_folder)
    end

  end
end
