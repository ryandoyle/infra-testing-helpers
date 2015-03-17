require 'puppet_vagrant/box'
require 'puppet_vagrant/site'

module PuppetVagrant
  module Helper

    def apply_manifest(manifest_code)
      site.add_manifest(manifest_code)
    end

    def apply_all_manifests
      box = PuppetVagrant::Box.new('default', '/vagrant')
      box.apply(site)
    end

    private

    def site
      @@site ||= PuppetVagrant::Site.new('', PuppetVagrant.module_path)
    end

  end
end
