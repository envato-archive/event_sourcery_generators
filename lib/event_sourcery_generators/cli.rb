require 'thor'
require 'active_support/inflector'

require 'event_sourcery_generators/generators/project'
require 'event_sourcery_generators/generators/command'
require 'event_sourcery_generators/generators/projection'

module EventSourceryGenerators
  class CLI < Thor
    # Creating projects
    register(Generators::Project, 'new', 'new [PROJECT NAME]', 'Creates a new EventSourcery project')

    # Creating components inside a project
    register(Generators::Command, 'generate:command', 'generate:command [AGGREGATE] [COMMAND] [EVENT]', 'Generates a new COMMAND for AGGREGATE to create EVENT')
    register(Generators::Projection, 'generate:projection', 'generate:projection [NAME]', 'Generates a new projection with the name NAME')
  end
end
