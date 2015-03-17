require 'functional_spec_helper'

apply_manifest 'include test2_manifest'

describe file('/tmp/testfile2.txt') do
  it { should be_file }
end
