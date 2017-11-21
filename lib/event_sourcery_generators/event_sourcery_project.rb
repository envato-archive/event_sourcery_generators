class EventSourceryProject
  EVENT_SOURCERY_APP_NAME_FILE = 'event_sourcery_app_name'
  attr_accessor :project_root, :project_name

  # @return [EventSourceryProject]
  def self.find()

    # code from Rails https://github.com/rails/rails/blob/master/railties/lib/rails/app_loader.rb, under MIT license
    original_cwd = Dir.pwd

    loop do
      if (File.file?(EVENT_SOURCERY_APP_NAME_FILE))
        esp = EventSourceryProject.new
        esp.project_root = Dir.pwd
        esp.project_name = File.read(EVENT_SOURCERY_APP_NAME_FILE)
        Dir.chdir(original_cwd)
        return esp
      end

      # If we exhaust the search there is no executable, this could be a
      # call to generate a new application, so restore the original cwd.
      Dir.chdir(original_cwd) && return if Pathname.new(Dir.pwd).root?

      # Otherwise keep moving upwards in search of an executable.
      Dir.chdir("..")
    end
  end
end