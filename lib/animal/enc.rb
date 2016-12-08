module Animal
  class ENC
    def self.query(node_name, opts = {})
      classes     = example_classes
      params      = example_params
      environment = example_environment
      results     = {}

      results['classes']     = classes if classes
      results['params']      = params if params
      results['environment'] = environment if environment

      to_enc_output results
    end
    
    def self.to_enc_output(data = {})
      return nil if data.empty?
      data.to_yaml
    end

    # an example of some data we'll actually compile later
    def self.example_classes
      {
        'role::windows::ad_dc' => nil
      }
    end

    def self.example_params
      {
        'ntp_servers' => [
          '0.pool.ntp.org'
        ]
      }
    end

    def self.example_environment
      'production'
    end
  end
end
