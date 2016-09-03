require 'thor'

require 'event_sourcery_generators/generators/create_new_project'
require 'event_sourcery_generators/generators/generate_command'

module EventSourceryGenerators
  class CLI < Thor
    register(Generators::CreateNewProject, 'new', 'new [PROJECT NAME]', 'Creates a new EventSourcery project')
    register(Generators::GenerateCommand, 'generate:command', 'generate:command [AGGREGATE] [COMMAND] [EVENT]', 'Generates a new COMMAND for AGGREGATE to create EVENT')
  end
end
