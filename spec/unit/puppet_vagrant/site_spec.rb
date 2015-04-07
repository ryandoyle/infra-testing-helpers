require 'spec_helper'

require 'infra_testing_helpers/site'

describe InfraTestingHelpers::Site do

  let(:site) { described_class.new('site.pp code', '/some/module/path') }

  describe '#puppet_code' do
    it 'should contain the site.pp code' do
      expect(site.puppet_code).to include 'site.pp code'
    end
    it 'should have a new line between the site code and the manifest code' do
      site.add_manifest 'include ntp'

      expect(site.puppet_code).to include "site.pp code\ninclude ntp"
    end
  end

  describe '#add_manifest' do
    it 'should add the manifest to the puppet code' do
      site.add_manifest('include ntp')

      expect(site.puppet_code).to include 'include ntp'
    end
    it 'should add a new line after each manifest' do
      site.add_manifest('include ntp')
      site.add_manifest('include apache')

      expect(site.puppet_code).to include "include ntp\ninclude apache"
    end
  end

end
