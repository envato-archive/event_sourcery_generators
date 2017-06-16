module EventSourceryGenerators
  module Generators
    class Project < Thor::Group
      include Thor::Actions

      argument :project_name

      class_options skip_tests: false, skip_setup: false

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates', 'project')
      end

      def setup_ruby_project
        template('gemfile.tt', "#{project_name}/Gemfile")
        template('rakefile.tt', "#{project_name}/Rakefile")
      end

      def add_readme
        template('readme.md.tt', "#{project_name}/README.md")
      end

      def setup_app
        template('server.rb.tt', "#{project_name}/app/web/server.rb")

        %w{aggregates commands events projections reactors}.each do |directory|
          create_file("#{project_name}/app/#{directory}/.gitkeep")
        end
      end

      def setup_environment
        template('environment.rb.tt', "#{project_name}/config/environment.rb")
      end

      def setup_scripts
        %w{server setup}.each do |script_name|
          template("script_#{script_name}.tt", "#{project_name}/script/#{script_name}")
          chmod("#{project_name}/script/#{script_name}", 0755)
        end
      end

      def setup_rspec
        return if options[:skip_tests]

        template('spec_helper.rb.tt', "#{project_name}/spec/spec_helper.rb")
        template('request_helpers.rb.tt', "#{project_name}/spec/support/request_helpers.rb")
      end

      def setup_processes_infrastructure
        template('Procfile.tt', "#{project_name}/Procfile")
        template('config.ru.tt', "#{project_name}/config.ru")
        template('app.json.tt', "#{project_name}/app.json")
      end

      def run_setup_script
        return if options[:skip_setup]

        inside(project_name) do
          run('./script/setup')
        end
      end

      private

      def project_class_name
        @project_class_name ||= project_name.underscore.camelize
      end
    end
  end
end
