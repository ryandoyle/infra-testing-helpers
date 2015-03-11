require 'spec_helper'

require 'puppet_vagrant/box'

describe PuppetVagrant::Box do

  let(:manifest) { double('Manifest') }
  let(:box) { described_class.new }
  
  before do 
    allow_message_expectations_on_nil
    allow($?).to receive(:exitstatus).and_return(0)
    allow(manifest).to receive(:module_path).and_return('/manifest/path')
    allow(manifest).to receive(:path).and_return('/manifest_to_apply.pp')
  end

  describe '#apply' do

    it 'successfully applies a manifest to the box' do
      expect(box).to receive(:run_command).with('sudo puppet apply --detailed-exitcode --modulepath /manifest/path /manifest_to_apply.pp').and_return(0)
      box.apply(manifest)
    end

    it 'successfully applies a manifest to the box and deals with weird exit codes' do
      expect(box).to receive(:run_command).with('sudo puppet apply --detailed-exitcode --modulepath /manifest/path /manifest_to_apply.pp').and_return(2)
      box.apply(manifest)
    end
    

    it 'raises a PuppetVagrant::PuppetApplyFailed error if the puppet apply fails' do
      allow(box).to receive(:run_command).with('sudo puppet apply --detailed-exitcode --modulepath /manifest/path /manifest_to_apply.pp').and_return(1)
      expect{box.apply(manifest)}.to raise_error(PuppetVagrant::PuppetApplyFailed)
    end
  end

  describe '#run_command' do
    it 'runs the command on the box' do
      expect(box).to receive(:system).with('vagrant ssh default --command "some_command"')
      box.run_command('some_command')
    end

    it 'runs the command on the box with the box name' do
      box = described_class.new('somebox')
      expect(box).to receive(:system).with('vagrant ssh somebox --command "some_command"')
      box.run_command('some_command')
    end

    it 'returns the exit status of the command that ran' do
      allow(box).to receive(:system)
      allow($?).to receive(:exitstatus).and_return(1)

      expect(box.run_command('foo')).to eql(1)
    end
  end

  describe '#name' do
    it 'defaults to the "default" box name if not specified' do
      expect(box.name).to eql 'default'
    end

    it 'has a name if specified' do
      box = described_class.new('somebox')
      expect(box.name).to eql 'somebox'
    end

  end

end
