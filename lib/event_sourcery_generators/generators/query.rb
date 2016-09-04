module EventSourceryGenerators
  module Generators
    class Query < Thor::Group
      include Thor::Actions

      argument :projection_name

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates/query')
      end

      def create_projector
        template('projector.rb.tt', "queries/#{projection_name}/projector.rb")
      end

      def create_query_handling_files
        template('query_handler.rb.tt', "queries/#{projection_name}/query_handler.rb")
        template('model.rb.tt', "queries/#{projection_name}/model.rb")
        template('view.rb.tt', "queries/#{projection_name}/view.rb")
      end

      private

      def project_name
        @project_name ||= File.split(Dir.pwd).last
      end
    end
  end
end
