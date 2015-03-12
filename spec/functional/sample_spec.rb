require 'functional_spec_helper'


describe file('/tmp/testfile.txt') do

  before do
    apply_manifest 'include test_manifest'
  end

  it { should be_file }
end
