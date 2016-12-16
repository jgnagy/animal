module Animal
  module Plugins
    module Inventory
      # The Facter integration inventory plugin mock-up
      class Fact < InventoryPlugin
        def self.get(node, key)
          data = {
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
          }
          data.key?(node) && data[node].key?(key) ? data[node][key] : nil
        end
      end
    end
  end
end
