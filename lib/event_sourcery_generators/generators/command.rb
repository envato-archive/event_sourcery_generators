module EventSourceryGenerators
  module Generators
    class Command < Thor::Group
      include Thor::Actions

      argument :aggregate
      argument :command

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates/command')
      end

      def create_respository_file
        template('repository.rb.tt', "commands/#{aggregate}/repository.rb")
      end

      def create_or_inject_into_aggregate_file
        aggregate_file = "commands/#{aggregate}/#{aggregate}.rb"

        @command_method = erb_file('aggregate/command_method.rb.tt')
        @apply_event_method = erb_file('aggregate/apply_event_method.rb.tt')

        if File.exist?(aggregate_file)
          insert_into_file(aggregate_file, @command_method, after: "include EventSourcery::AggregateRoot\n")
          insert_into_file(aggregate_file, @apply_event_method, after: "private\n")
        else
          template('aggregate.rb.tt', aggregate_file)
        end
      end

      def create_command_files
        template('command.rb.tt', "commands/#{aggregate}/#{command}/command.rb")
        template('command_handler.rb.tt', "commands/#{aggregate}/#{command}/command_handler.rb")
      end

      def inject_command_to_api
        insert_into_file('web/commands/api.rb', after: "def self.registered(app)\n") do
          erb_file('api_endpoint.rb.tt')
        end
      end

      private

      def aggregate_name
        aggregate.underscore
      end

      def aggregate_class_name
        aggregate.camelize
      end

      def command_name
        command.underscore
      end

      def command_class_name
        command_name.camelize
      end

      def event_name
        # Primitive way to get past tense of the command,
        # will likely need more work in the future
        past_tense = command.gsub(/e$/, '') + 'ed'
        [ aggregate, past_tense ].map(&:underscore).join('_')
      end

      def erb_file(file)
        path = File.join(self.class.source_root, file)
        ERB.new(::File.binread(path), nil, "-", "@output_buffer").result(binding)
      end

      def project_name
        @project_name ||= File.split(Dir.pwd).last
      end
    end
  end
end
