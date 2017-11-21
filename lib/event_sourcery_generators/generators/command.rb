module EventSourceryGenerators
  module Generators
    class Command < Thor::Group
      include Thor::Actions

      argument :aggregate
      argument :command

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates/command')
      end

      def create_or_inject_into_aggregate_file
        aggregate_file = "#{project_root}/app/aggregates/#{aggregate_name}.rb"

        @command_method     = erb_file('aggregate/command_method.rb.tt')
        @apply_event_method = erb_file('aggregate/apply_event_method.rb.tt')

        if File.exist?(aggregate_file)
          insert_into_file(aggregate_file, @command_method, after: "include EventSourcery::AggregateRoot\n")
          insert_into_file(aggregate_file, @apply_event_method, after: "include EventSourcery::AggregateRoot\n")
        else
          template('aggregate.rb.tt', aggregate_file)
        end
      end

      def create_command_file
        template('command.rb.tt', "#{project_root}/app/commands/#{aggregate}/#{command}.rb")
      end

      def create_event
        event_file = "#{project_root}/app/events/#{event_name}.rb"

        unless File.exist?(event_file)
          template('event.rb.tt', event_file)
        end
      end

      def inject_command_to_api
        insert_into_file("#{project_root}/app/web/server.rb", after: "< Sinatra::Base\n") do
          erb_file('api_endpoint.rb.tt')
        end
      end

      private

      def aggregate_name
        @aggregate_name ||= aggregate.underscore
      end

      def aggregate_class_name
        @aggregate_class_name ||= aggregate_name.camelize
      end

      def command_name
        @command_name ||= command.underscore
      end

      def command_class_name
        @command_class_name ||= command_name.camelize
      end

      def event_name
        past_participle = Verbs::Conjugator.send(:past_participle, command.downcase.to_sym).to_s
        [ aggregate, past_participle ].map(&:underscore).join('_')
      end

      def event_class_name
        @event_class_name ||= event_name.underscore.camelize
      end

      def erb_file(file)
        path = File.join(self.class.source_root, file)
        ERB.new(::File.binread(path), nil, "-", "@output_buffer").result(binding)
      end

      def project_name
        event_sourcery_project.project_name
      end

      def project_root
        event_sourcery_project.project_root
      end

      def project_class_name
        @project_class_name ||= project_name.underscore.camelize
      end

      def event_sourcery_project
        @event_sourcery_project ||= EventSourceryProject.find()
        unless @event_sourcery_project
          raise ArgumentError, "must be in an event sourcery directory"
        end

        @event_sourcery_project
      end
    end
  end
end
