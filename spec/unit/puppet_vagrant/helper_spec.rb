require 'spec_helper'

require 'infra_testing_helpers/helper'

class TestInfraTestingHelper
  include InfraTestingHelpers::Helper
end

describe InfraTestingHelpers::Helper do 

  let(:helper) { TestInfraTestingHelper.new }
  let(:global_site) { double('Global Site') }
  let(:local_site) { double('Local Site') }
  let(:box) { double('InfraTestingHelpers::Box') }


  before do
    allow(helper).to receive(:global_site).and_return global_site
    allow(helper).to receive(:box).and_return box
    allow(box).to receive(:applied?).and_return false
    allow(InfraTestingHelpers).to receive(:module_path)
    allow(InfraTestingHelpers).to receive(:site_pp)
    allow(InfraTestingHelpers).to receive(:project_root)
  end

  describe '#apply_manifest' do
    it 'adds the manifest to the site to be applied' do
      expect(global_site).to receive(:add_manifest).with 'include ntp'

      helper.apply_manifest('include ntp')
    end

    it 'applies the manifest straight away if it was previously applied' do
      allow(box).to receive(:applied?).and_return true 
      allow(InfraTestingHelpers::Site).to receive(:new).and_return local_site
      allow(local_site).to receive(:add_manifest)

      expect(box).to receive(:apply).with(local_site)

      helper.apply_manifest('include ntp')
    end
  end

  describe '#apply_all_manifests' do
    it 'applies all manifests for a site' do
      expect(box).to receive(:apply).with(global_site)

      helper.apply_all_manifests
    end
  end
end
