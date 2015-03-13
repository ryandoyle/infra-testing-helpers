require 'functional_spec_helper'

apply_manifest 'include test_manifest'

describe file('/tmp/testfile.txt') do
  it { should be_file }
end
