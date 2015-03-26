require 'functional_spec_helper'

apply_manifest 'include test_manifest'

describe file('/tmp/testfile.txt') do

  before do
    apply_manifest "file {'/tmp/testfile.txt': ensure => file }"
  end

  it { should be_file }
end
