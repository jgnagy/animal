module Animal
  module Plugins
    # The Facter integration inventory plugin mock-up
    class Fact < InventoryPlugin
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
