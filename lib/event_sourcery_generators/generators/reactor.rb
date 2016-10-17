module EventSourceryGenerators
  module Generators
    class Reactor < Thor::Group
      include Thor::Actions

      argument :reactor_name

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates/reactor')
      end

      def create_downstream_event_processor
        template('reactor.rb.tt', "reactors/#{reactor_name}.rb")
      end

      private

      def project_name
        @project_name ||= File.split(Dir.pwd).last
      end
    end
  end
end
