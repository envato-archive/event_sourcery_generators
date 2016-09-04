require 'thor'
require 'active_support/inflector'

require 'event_sourcery_generators/generators/project'
require 'event_sourcery_generators/generators/command'
require 'event_sourcery_generators/generators/query'
require 'event_sourcery_generators/generators/dep'

module EventSourceryGenerators
  class CLI < Thor
    # Creating projects
    register(Generators::Project, 'new', 'new [PROJECT NAME]', 'Creates a new EventSourcery project')

    # Creating components inside a project
    register(Generators::Command, 'generate:command', 'generate:command [AGGREGATE] [COMMAND] [EVENT]', 'Generates a new COMMAND for AGGREGATE to create EVENT')
    register(Generators::Query, 'generate:query', 'generate:query [NAME]', 'Generates a new query with the name NAME')
    register(Generators::DEP, 'generate:dep', 'generate:dep [NAME]', 'Generates a new Downstream Event Processor with the name NAME')
  end
end
