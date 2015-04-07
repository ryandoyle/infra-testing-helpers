module InfraTestingHelpers
  class Site

    def initialize(site_code, module_path)
      @site_code = site_code
      @module_path = module_path
      @manifest_code = ""
    end

    attr_reader :module_path

    def add_manifest(manifest)
      @manifest_code << "#{manifest}\n"
    end

    def puppet_code
      "#{@site_code}\n#{@manifest_code}"
    end

  end
end
