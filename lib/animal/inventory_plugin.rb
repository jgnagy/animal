module Animal
  # The base class for inventory plugins
  class InventoryPlugin
    # Must be overridden
    def self.get(_node, _key)
      nil
    end
  end
end
