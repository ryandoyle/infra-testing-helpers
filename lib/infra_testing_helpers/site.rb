require 'tempfile'

module InfraTestingHelpers
  class Site

    def initialize(site_code, module_path, project_root)
      @site_code = site_code
      @module_path = module_path
      @project_root = project_root
      @manifest_code = ""
    end

    attr_reader :module_path

    def add_manifest(manifest)
      @manifest_code << "#{manifest}\n"
    end

    def manifest_file
      file = Tempfile.new(['infra-testing-helpers', '.pp'], @project_root)
      begin
        file.puts puppet_code
        file.fsync
        yield(File.basename(file.path)) if block_given?
      ensure 
        file.close
        file.unlink
      end
    end

    def puppet_code
      "#{@site_code}\n#{@manifest_code}"
    end

  end
end
