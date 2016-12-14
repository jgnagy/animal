module Animal
  module Plugins
    class Fact < Plugin
      def self.get(node, key)
        {
          'dschaaff' => {
            'certname' => 'dschaaff.local',
            'machine_class' => 'server'
          },
          'jgnagy' => {
            'certname' => 'jgnagy.local',
            'machine_class' => 'desktop'
          }
        }[node][key]
      end
    end
  end
end
