module PuppetVagrant
  class PuppetApplyFailed < StandardError; end
  class Box
    def initialize(name='default')
      @name = name
    end

    attr_reader :name

    def apply(manifest)
      run_puppet_command("sudo puppet apply --detailed-exitcode --modulepath #{manifest.module_path} #{manifest.path}")
    end


    def run_command(command)
      system "vagrant ssh #{@name} --command \"#{command}\""
      $?.exitstatus
    end
  
    private

    def run_puppet_command(command)
      exit_code = run_command(command)
      raise PuppetApplyFailed unless exit_code == 0 or exit_code == 2
    end

  end
end
