module EventSourceryGenerators
  module Generators
    class Project < Thor::Group
      include Thor::Actions

      argument :project_name

      class_options skip_bundle: false, skip_db: false, skip_rspec: false

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates', 'project')
      end

      def setup_ruby_project
        template('gemfile.tt', "#{project_name}/Gemfile")
        template('rakefile.tt', "#{project_name}/Rakefile")
      end

      def bundle_install
        return if options[:skip_bundle]

        inside(project_name) do
          run('bundle install', capture: true)
        end
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

      def setup_rspec
        return if options[:skip_rspec]

        template('spec_helper.rb.tt', "#{project_name}/spec/spec_helper.rb")
        template('request_helpers.rb.tt', "#{project_name}/spec/support/request_helpers.rb")
      end

      def setup_database
        return if options[:skip_db]

        inside(project_name) do
          run('bundle exec rake db:create db:migrate', capture: true)
        end
      end


      # def setup_processes_infrastructure
      #   # Procfile for web + event processing processes
      #   template('Procfile.tt', "#{project_name}/Procfile")

      #   # Web process
      #   template('config.ru.tt', "#{project_name}/config.ru")
      # end
    end
  end
end
