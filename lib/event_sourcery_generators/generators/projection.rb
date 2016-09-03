module EventSourceryGenerators
  module Generators
    class Projection < Thor::Group
      include Thor::Actions

      argument :projection_name

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates/projection')
      end

      def create_projector
        template('projector.rb.tt', "projections/#{projection_name}/projectors/v1.rb")
      end

      def create_query_handling_files
        template('query_handler.rb.tt', "projections/#{projection_name}/query_handler.rb")
        template('model.rb.tt', "projections/#{projection_name}/model.rb")
        template('view.rb.tt', "projections/#{projection_name}/view.rb")
      end

      private

      def project_name
        @project_name ||= File.split(Dir.pwd).last
      end
    end
  end
end
