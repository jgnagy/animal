module Animal
  module Plugins
    class Fact < Plugin
      def self.get(node, key)
        {
          'dschaaff' => {
            'certname' => 'dschaaff.local',
            'machine_class' => 'server',
            'os' => 'ubuntu'
          },
          'jgnagy' => {
            'certname' => 'jgnagy.local',
            'machine_class' => 'server',
            'os' => 'darwin',
            'awesome' => true
          }
        }[node][key]
      end
    end
  end
end
