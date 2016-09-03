require 'thor'

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
        template('aggregate.tt', "command/#{aggregate}/aggregate.rb")
      end

      def create_respository_file
        template('repository.tt', "command/#{aggregate}/repository.rb")
      end

      def create_command_handler_file
        template('command_handler.tt', "command/#{aggregate}/#{command}/command_handler.rb")
      end
    end
  end
end
