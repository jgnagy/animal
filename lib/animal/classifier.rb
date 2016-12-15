module Animal
  # The class responsible for actually classifying a node
  # The Classifier pulls together required plugins and config
  class Classifier
    def initialize(node_name)
      @node_name = node_name
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
      case type
      when 'environment'
        # TODO: look this up in a configuration somewhere
        'production'
      when 'classes'
        Rule.apply_all_for(@node_name)
      when 'parameters'
        nil
      else
        raise 'Not Implemented'
      end
    end
  end
end
