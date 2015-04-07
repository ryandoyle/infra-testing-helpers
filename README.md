# InfraTestingHelpers
> Your helping hand for infrastructure code testing

InfraTestingHelpers provides integrations with Vagrant, Puppet and Serverspec to make infrastructure code testing easy! I'll show you around to see how it can help you too. There is some assumed knowledge of Serverspec so have a read of the [tutorial] if you haven't done so already

## Serverspec integraton
Lets say you've written some tests for Serverspec that test your Puppet modules. InfraTestingHelpers provide a way to run your Puppet code against a Vagrant box before validating with Serverspec
### Setup
Install with `gem install infra-testing-helpers`

Next, lets have a look at your `spec_helper.rb` (probably generated by Serverspec) and add the parts we need in for InfraTestingHelpers.
```ruby
...
require 'infra_testing_helpers'
InfraTestingHelpers.project_root = File.expand_path(File.dirname(__FILE__) + '/../')
InfraTestingHelpers.module_path = ['modules/:another_module_path/']
InfraTestingHelpers.site_pp = 'Exec { path => "/sbin:/usr/sbin:/bin:/usr/bin" }'
InfraTestingHelpers.vagrant_shared_folder = '/etc/puppet'
...
```
- `require 'infra_testing_helpers'` mixes in the functions we will use later in our specs as well as sets up a global `before` hook in RSpec. 
- `InfraTestingHelpers.project_root` is the directory the Vagrantfile is located it. This is manditory
- `InfraTestingHelpers.module_path` is the location of your modules. This defaults to just `modules/` if nothing is specified. 
- `InfraTestingHelpers.site_pp` is the contents of your own `site.pp` file. If yours is rather large, you might want to dynamically populate this (`File.read`). Again, this is optional.
- `InfraTestingHelpers.vagrant_shared_folder` reflects where your shared folder is in your `Vagrantfile`. This defaults to `/vagrant`.

### Specs
Lets look at an example spec `modules/apache/spec/default/apache_spec.rb`.

``` ruby
require 'spec_helper'
apply_manifest 'include apache'

describe 'apache' do

  describe 'its default MPM mode is perfork' do
    describe process('httpd') do
      it { should be_running }
    end
  end
  
  describe 'worker mode' do
    before do
      apply_manifest 'class {"apache": mpm => "worker"}'
      describe process('httpd.woker') do
        it { should be_running }
      end
    end
  end
  
end
```

Lets apply the manifest with  `rspec modules/apache/spec/default/apache_spec.rb`.

```
Notice: Compiled catalog for vagrant-ubuntu-trusty-64.local in environment production in 0.05 seconds
Notice: Finished catalog run in 0.03 seconds
.Notice: Compiled catalog for vagrant-ubuntu-trusty-64.local in environment production in 0.04 seconds
Notice: Finished catalog run in 0.01 seconds
.
Finished in 6.92 seconds (files took 5.05 seconds to load)
2 examples, 0 failures
```

`apply_manifest` will apply Puppet code differently depending on the scope in which it is called. In the global rspec scope, it will apply the manifests before running any tests. If you have multiple specs with `apply_manifest` in the global scope, they are lazily evaluated and run as a single puppet apply. This helps speed up Puppet runs and can detect duplicate resource definitions.

When `apply_manifests` is run within a `before` block it is applied instantly. This is useful for testing manifests that can not co-exist with others or for testing different arguments to the same manifest.
