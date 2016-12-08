module Animal
  class ENC
    def self.query(node_name, opts = {})
      classifier  = Classifier.new(node_name)
      classes     = classifier.classes
      parameters  = classifier.parameters
      environment = classifier.environment
      results     = {}

      results['classes']     = classes if classes
      results['parameters']  = parameters if parameters
      results['environment'] = environment ? environment : 'production'

      to_enc_output results
    end

    def self.to_enc_output(data = {})
      return nil if data.empty? || (!data.key?('classes') && !data.key?('parameters'))
      data.to_yaml
    end
  end
end
