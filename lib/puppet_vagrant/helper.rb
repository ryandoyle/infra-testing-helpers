require 'puppet_vagrant/box'
require 'puppet_vagrant/manifest'

module PuppetVagrant
  module Helper
    def apply_manifest(manifest_code)
      box = PuppetVagrant::Box.new('default', '/vagrant')
      manifest = PuppetVagrant::Manifest.new(manifest_code, 'spec/functional/modules')
      box.apply(manifest)
    end
  end
end
