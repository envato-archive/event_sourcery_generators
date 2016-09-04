module EventSourceryGenerators
  module Generators
    class DEP < Thor::Group
      include Thor::Actions

      argument :dep_name

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates/dep')
      end

      def create_downstream_event_processor
        template('dep.rb.tt', "event_processors/#{dep_name}.rb")
      end

      private

      def project_name
        @project_name ||= File.split(Dir.pwd).last
      end
    end
  end
end
