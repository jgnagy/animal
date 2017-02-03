module Animal
  module Plugins
    module Inventory
      # The Facter integration inventory plugin mock-up
      class Fact < InventoryPlugin
        # method for reading facts into ruby here
        # use facts yaml in /opt/puppetlabs/server/data/puppetserver/yaml/facts
        # TODO: make that dir ^^ a config option
        # TODO: consider slurping in all fact files and cache them
        def self.get(certname, *key)
          file = File.read("/opt/puppetlabs/server/data/puppetserver/yaml/facts/#{certname}.yaml")
          fact_data = ::YAML.load(file.gsub(%r{\!ruby\/object.*$}, ''))
          keys = key.split('.')
          read_keys(fact_data['values'], keys)
        end

        def read_keys(input, key)
          key.size == 1 ? input[key.first] : read_keys(input[key.shift], key)
        end
      end
    end
  end
end
