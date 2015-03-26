require 'spec_helper'

require 'puppet_vagrant/box'

describe PuppetVagrant::Box do

  let(:manifest) { double('Manifest') }
  let(:box) { described_class.new('default', '/vagrant') }
  
  before do 
    allow_message_expectations_on_nil
    allow($?).to receive(:exitstatus).and_return(0)
    allow(manifest).to receive(:module_path).and_return('modules/')
    allow(manifest).to receive(:puppet_code).and_return('include some_manifest')
  end

  describe '#apply' do

    it 'successfully applies a manifest to the box' do
      expect(box).to receive(:run_command).with('sudo puppet apply --detailed-exitcode --modulepath /vagrant/modules/',  {:stdin=>"include some_manifest"}).and_return(0)
      box.apply(manifest)
    end

    it 'successfully applies a manifest to the box and deals with weird exit codes' do
      expect(box).to receive(:run_command).with('sudo puppet apply --detailed-exitcode --modulepath /vagrant/modules/',  {:stdin=>"include some_manifest"}).and_return(2)
      box.apply(manifest)
    end
    

    it 'raises a PuppetVagrant::PuppetApplyFailed error if the puppet apply fails' do
      allow(box).to receive(:run_command).with('sudo puppet apply --detailed-exitcode --modulepath /vagrant/modules/',  {:stdin=>"include some_manifest"}).and_return(1)

      expect{box.apply(manifest)}.to raise_error(PuppetVagrant::PuppetApplyFailed)
    end


  end

  describe '#applied?' do

    it 'is false if a manifest has not been applied' do
      expect(box.applied?).to be false
    end

    it 'is true when a manifest is applied successfully' do
      allow(box).to receive(:run_command).and_return(0)
      box.apply(manifest)

      expect(box.applied?).to be true
    end
    it 'is false when a manifest is not applied successfully' do
      allow(box).to receive(:run_command).with('sudo puppet apply --detailed-exitcode --modulepath /vagrant/modules/',  {:stdin=>"include some_manifest"}).and_return(1)
      expect{box.apply(manifest)}.to raise_error(PuppetVagrant::PuppetApplyFailed)

      expect(box.applied?).to be false
    end

  end

  describe '#run_command' do
    it 'runs the command on the box' do
      expect(box).to receive(:system).with('vagrant ssh default --command "some_command"')
      box.run_command('some_command')
    end

    it 'runs the command on the box with the box name' do
      box = described_class.new('somebox', '/vagrant')
      expect(box).to receive(:system).with('vagrant ssh somebox --command "some_command"')
      box.run_command('some_command')
    end

    it 'returns the exit status of the command that ran' do
      allow(box).to receive(:system)
      allow($?).to receive(:exitstatus).and_return(1)

      expect(box.run_command('foo')).to eql(1)
    end

    it 'pipes stdin to the command if given' do
      expect(box).to receive(:system).with("vagrant ssh default --command \"some_command\" << EOF\nsomething\nEOF")
      box.run_command('some_command', :stdin => "something")
    end
  end

  describe '#name' do
    it 'defaults to the "default" box name if not specified' do
      expect(box.name).to eql 'default'
    end

    it 'has a name if specified' do
      box = described_class.new('somebox', '/vagrant')
      expect(box.name).to eql 'somebox'
    end
  end

end
