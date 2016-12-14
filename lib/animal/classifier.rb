module Animal
  class Classifier
    def initialize(node_name)
      @node_name = node_name
      @db_path = File.expand_path(File.join(ANIMAL_HOME, 'nodes'))
      FileUtils.mkdir_p(@db_path) unless File.exist?(@db_path)
    end

    def classes
      classify('classes')
    end

    def parameters
      classify('parameters')
    end

    def environment
      classify('environment')
    end

    def classify(type)
      file_name = File.join(@db_path, @node_name, "#{type}.yml")
      if File.exist?(file_name)
        YAML.load_file(file_name)
      else
        nil
      end
    end
  end
end
