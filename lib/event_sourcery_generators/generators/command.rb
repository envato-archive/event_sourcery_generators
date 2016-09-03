module EventSourceryGenerators
  module Generators
    class Command < Thor::Group
      include Thor::Actions

      argument :aggregate
      argument :command
      argument :event

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates/command')
      end

      def create_aggregate_file
        template('aggregate.rb.tt', "domain/#{aggregate}/aggregate.rb")
      end

      def create_respository_file
        template('repository.rb.tt', "domain/#{aggregate}/repository.rb")
      end

      def create_command_handler_file
        template('command_handler.rb.tt', "domain/#{aggregate}/#{command}/command_handler.rb")
      end
    end
  end
end
