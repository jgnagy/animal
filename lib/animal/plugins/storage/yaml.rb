module Animal
  module Plugins
    module Storage
      # The basic, YAML storage plugin
      class Yaml < StoragePlugin
        def self.all(type)
          # TODO: add caching in here...
          results = []
          Dir.chdir File.expand_path(File.join(ANIMAL_HOME, "#{type}.d")) do
            Dir.glob('*.yml').each do |file|
              results.concat ::YAML.load_file(file)
            end
          end
          results
        end
      end
    end
  end
end
