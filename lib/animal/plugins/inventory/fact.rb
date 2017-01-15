module Animal
  module Plugins
    module Inventory
      # The Facter integration inventory plugin mock-up
      class Fact < InventoryPlugin
        # def self.get(node, key)
        #  data = {
        #    'dschaaff' => {
        #      'certname' => 'dschaaff.local',
        #      'machine_class' => 'server',
        #      'os' => 'ubuntu'
        #    },
        #    'jgnagy' => {
        #      'certname' => 'jgnagy.local',
        #      'machine_class' => 'server',
        #      'os' => 'darwin',
        #      'awesome' => true
        #    }
        #  }
        #  data.key?(node) && data[node].key?(key) ? data[node][key] : nil
        # end
        # method for reading facts into ruby here
        # use facts yaml in /opt/puppetlabs/server/data/puppetserver/yaml/facts
        # TODO: make that dir ^^ a config option
        # TODO: consider slurping in all fact files and cache them
        # TODO: fix key to account for nested facts
        def self.get(certname, key)
          fact_file = File.read("/opt/puppetlabs/server/data/puppetserver/yaml/facts/#{certname}.yaml")
          fact_data = ::YAML.load_file(fact_file.gsub(/\!ruby\/object.*$/, ''))
          fact_data[key]
        end
      end
    end
  end
end
