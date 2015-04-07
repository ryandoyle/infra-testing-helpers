module InfraTestingHelpers
  class PuppetApplyFailed < StandardError; end
  class Box
    def initialize(name)
      @name = name
      @applied = false
    end

    attr_reader :name

    def apply(manifest)
      manifest.manifest_file do |file|
        exit_code = run_command("sudo puppet apply --detailed-exitcode --modulepath #{manifest.module_path} #{file}")
        raise PuppetApplyFailed unless exit_code == 0 or exit_code == 2
        @applied = true
      end
    end

    def applied?
      @applied
    end


    def run_command(command, opts = {})
      stdin = opts[:stdin] ? " << EOF\n#{opts[:stdin]}\nEOF" : ""
      system "vagrant ssh #{@name} --command \"#{command}\"#{stdin}"
      $?.exitstatus
    end
  
  end
end
