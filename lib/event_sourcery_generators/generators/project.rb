module EventSourceryGenerators
  module Generators
    class Project < Thor::Group
      include Thor::Actions

      argument :project_name

      class_options skip_bundle: false, skip_db: false

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates', 'project')
      end

      def setup_ruby_project
        create_file("#{project_name}/.env")
        template('gemfile.tt', "#{project_name}/Gemfile")
        template('rakefile.tt', "#{project_name}/Rakefile")
      end

      def setup_processes_infrastructure
        # Procfile for web + event processing processes
        template('Procfile.tt', "#{project_name}/Procfile")

        # Web process
        template('config.ru.tt', "#{project_name}/config.ru")
      end

      def setup_app
        template('web.rb.tt', "#{project_name}/web/web.rb")

        [ 'command', 'query' ].each do |side|
          @side = side # So it's available in ERB
          template('api.rb.tt', "#{project_name}/web/#{side}/api.rb")
        end
      end

      def bundle_install
        return if options[:skip_bundle]

        inside(project_name) do
          run('bundle install', capture: true)
        end
      end

      def create_event_store
        return if options[:skip_db]

        confirmation_text = "Would you like to set up the required Event Store PostgreSQL database? (y/n)"

        if yes?(confirmation_text, :red)
          db_name = ask('Database name:', default: "#{project_name}_event_store_development")
          db_user = ask('Database user:', default: 'postgres')
          db_pass = ask('Database password:', default: '')
          db_port = ask('Database port:', default: '5432')

          cmd = "PGPASSWORD=#{db_pass} createdb -U #{db_user} -p #{db_port} #{db_name}"
          run(cmd, capture: true)

          require 'sequel'
          uri = "postgres://#{db_user}:#{db_pass}@localhost:#{db_port}/#{db_name}"
          db = Sequel.connect(uri)

          db.create_table :events do
            primary_key :id, type: :Bignum
            column :aggregate_id, 'uuid not null'
            column :type, 'varchar(255) not null'
            column :body, 'json not null'
            column :created_at, 'timestamp without time zone not null default (now() at time zone \'utc\')'
            index :aggregate_id
            index :type
            index :created_at
          end

          append_to_file("#{project_name}/.env") do
            "EVENT_STORE_DATABASE_URI=#{uri}\n"
          end
        else
          say("Okay. You will need to set up your own Event Store.", :yellow)
        end
      end
    end
  end
end
