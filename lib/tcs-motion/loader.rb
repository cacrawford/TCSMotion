unless defined?(Motion::Project::Config)
  raise 'This file must be required within a RubyMotion project Rakefile.'
end

unless defined?(TCS_MOTION::LOADER_PRESENT)
  require_relative 'version' unless defined?(TCS_MOTION::VERSION)
  require 'bubble-wrap/core'

  module TCS_MOTION
    LOADER_PRESENT=true
    module_function

    Motion::Project::App.setup do |app|
      local_resources_dir = File.expand_path('../../../resources', __FILE__)
      app.resources_dirs << local_resources_dir
      app.frameworks << 'QuartzCore'
    end

    def require(file_spec, &block)
      BW::Requirement.scan(caller.first, file_spec, &block)
    end
  end

end
