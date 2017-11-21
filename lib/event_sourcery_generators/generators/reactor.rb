module EventSourceryGenerators
  module Generators
    class Reactor < Thor::Group
      include Thor::Actions

      argument :reactor_name
      argument :event_names, type: :array, default: []

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates/reactor')
      end

      def create_reactor
        template('reactor.rb.tt', "#{project_root}/app/reactors/#{reactor_name}.rb")
      end

      def add_reactor_to_rakefile
        insert_into_file("#{project_root}/Rakefile", erb_file('reactor_process.tt'), after: "processors = [\n")
      end

      private

      def project_name
        event_sourcery_project.project_name
      end

      def project_root
        event_sourcery_project.project_root
      end

      def project_class_name
        @project_class_name ||= project_name.underscore.camelize
      end

      def reactor_class_name
        @reactor_class_name ||= reactor_name.underscore.camelize
      end

      def erb_file(file)
        path = File.join(self.class.source_root, file)
        ERB.new(::File.binread(path), nil, "-", "@output_buffer").result(binding)
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
