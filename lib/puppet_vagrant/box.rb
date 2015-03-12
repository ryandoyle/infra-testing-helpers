module PuppetVagrant
  class PuppetApplyFailed < StandardError; end
  class Box
    def initialize(name, project_mount_point)
      @name = name
      @project_mount_point = project_mount_point
    end

    attr_reader :name

    def apply(manifest)
      run_puppet_command("sudo puppet apply --detailed-exitcode --modulepath #{@project_mount_point}/#{manifest.module_path} #{@project_mount_point}/#{manifest.path}")
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
