require 'spec_helper'

require 'puppet_vagrant/helper'

class TestPuppetVagrantHelper
  include PuppetVagrant::Helper
end

describe PuppetVagrant::Helper do 

  let(:helper) { TestPuppetVagrantHelper.new }
  let(:site) { double('PuppetVagrant::Site') }
  let(:box) { double('PuppetVagrant::Box') }


  before do
    allow(helper).to receive(:site).and_return site
    allow(PuppetVagrant::Box).to receive(:new).with('default', '/vagrant').and_return box
  end

  describe '#apply_manifest' do
    it 'adds the manifest to the site to be applied' do
      expect(site).to receive(:add_manifest).with 'include ntp'

      helper.apply_manifest('include ntp')
    end
  end

  describe '#apply_all_manifests' do
    it 'applies all manifests for a site' do
      expect(box).to receive(:apply).with(site)

      helper.apply_all_manifests
    end
  end
end
