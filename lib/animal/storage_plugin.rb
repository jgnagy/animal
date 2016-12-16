module Animal
  # The base class for storage plugins
  class StoragePlugin
    # Must be overridden
    def self.get(_type, _id, _id_column = :id)
      nil
    end

    # Must be overridden
    def self.all(_type)
      []
    end
  end
end
