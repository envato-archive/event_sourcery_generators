require 'thor'

require 'event_sourcery_generators/generators/project'
require 'event_sourcery_generators/generators/command'

module EventSourceryGenerators
  class CLI < Thor
    register(Generators::Project, 'new', 'new [PROJECT NAME]', 'Creates a new EventSourcery project')
    register(Generators::Command, 'generate:command', 'generate:command [AGGREGATE] [COMMAND] [EVENT]', 'Generates a new COMMAND for AGGREGATE to create EVENT')
  end
end
