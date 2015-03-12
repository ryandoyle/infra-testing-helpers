#!/usr/bin/env ruby
$:.unshift File.expand_path(File.dirname(__FILE__) + '/lib/')

require 'puppet_vagrant/box'
require 'puppet_vagrant/manifest'

box = PuppetVagrant::Box.new('default', '/vagrant')
manifest = PuppetVagrant::Manifest.new('include some_manifest', 'test/modules')

box.apply(manifest)
