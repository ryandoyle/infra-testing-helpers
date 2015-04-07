require 'spec_helper'

require 'infra_testing_helpers/site'

describe InfraTestingHelpers::Site do

  let(:site) { described_class.new('site.pp code', ['modules', 'other_modules'], '/some/project/root', '/vagrant') }
  let(:tempfile) { double('Tempfile') }

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

  describe '#module_path' do
    it 'returns the module path as a flattened path' do
      expect(site.module_path).to eql '/vagrant/modules:/vagrant/other_modules'
    end
  end

  describe '#manifest_file' do
    before do
      allow(Tempfile).to receive(:new).with(['infra-testing-helpers', '.pp'], '/some/project/root').and_return tempfile
      allow(tempfile).to receive(:close)
      allow(tempfile).to receive(:unlink)
      allow(tempfile).to receive(:puts)
      allow(tempfile).to receive(:fsync)
    end
    it 'writes the puppet code to a tempfile' do
      expect(tempfile).to receive(:puts).with("site.pp code\n")

      site.manifest_file
    end
    it 'syncs the file to the filesystem' do
      expect(tempfile).to receive(:fsync)

      site.manifest_file
    end
    it 'yeilds the base filename of the tempfile' do 
      allow(tempfile).to receive(:path).and_return('/tmp/tempfile_base_path.pp')

      expect { |b| site.manifest_file(&b) }.to yield_with_args('/vagrant/tempfile_base_path.pp')
    end
    it 'closes the file after yielding' do
      expect(tempfile).to receive(:close)

      site.manifest_file
    end
    it 'closes the file after yielding' do
      expect(tempfile).to receive(:unlink)

      site.manifest_file
    end
  end

end
