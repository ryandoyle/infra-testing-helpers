module PuppetVagrant
  class Manifest

    def initialize(code, module_path)
      @code = code
      @module_path = module_path
    end

    attr_reader :module_path, :code

  end
end
