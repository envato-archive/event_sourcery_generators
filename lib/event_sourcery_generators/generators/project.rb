module EventSourceryGenerators
  module Generators
    class Project < Thor::Group
      include Thor::Actions

      argument :project_name
      argument :project_root, required: false

      class_options skip_tests: false, skip_setup: false

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates', 'project')
      end

      def setup_ruby_project
        template('gemfile.tt', "#{project_directory}/Gemfile")
        template('rakefile.tt', "#{project_directory}/Rakefile")
      end

      def add_readme
        template('readme.md.tt', "#{project_directory}/README.md")
      end

      def setup_app
        template('server.rb.tt', "#{project_directory}/app/web/server.rb")

        %w{aggregates commands events projections reactors}.each do |directory|
          create_file("#{project_directory}/app/#{directory}/.gitkeep")
        end
      end

      def setup_environment
        template('environment.rb.tt', "#{project_directory}/config/environment.rb")
      end

      def setup_scripts
        %w{server setup}.each do |script_name|
          template("script_#{script_name}.tt", "#{project_directory}/script/#{script_name}")
          chmod("#{project_directory}/script/#{script_name}", 0755)
        end
      end

      def setup_rspec
        return if options[:skip_tests]

        template('spec_helper.rb.tt', "#{project_directory}/spec/spec_helper.rb")
        template('request_helpers.rb.tt', "#{project_directory}/spec/support/request_helpers.rb")
      end

      def setup_processes_infrastructure
        template('procfile.tt', "#{project_directory}/Procfile")
        template('config.ru.tt', "#{project_directory}/config.ru")
        template('app.json.tt', "#{project_directory}/app.json")
      end

      def run_setup_script
        return if options[:skip_setup]

        inside(project_directory) do
          run('./script/setup')
        end
      end

      private

      def project_directory
        project_root || project_name
      end

      def project_class_name
        @project_class_name ||= project_name.underscore.camelize
      end
    end
  end
end
