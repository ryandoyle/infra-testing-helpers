module PuppetVagrant
  class PuppetApplyFailed < StandardError; end
  class Box
    def initialize(name, project_mount_point)
      @name = name
      @project_mount_point = project_mount_point
    end

    attr_reader :name

    def apply(manifest)
      exit_code = run_command("sudo puppet apply --detailed-exitcode --modulepath #{@project_mount_point}/#{manifest.module_path}", :stdin => manifest.puppet_code)
      raise PuppetApplyFailed unless exit_code == 0 or exit_code == 2
    end


    def run_command(command, opts = {})
      stdin = opts[:stdin] ? "echo '#{opts[:stdin]}' | " : ""
      system "#{stdin}vagrant ssh #{@name} --command \"#{command}\""
      $?.exitstatus
    end
  
  end
end
