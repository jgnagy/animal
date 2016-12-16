ANIMAL_HOME = ENV['ANIMAL_HOME'] ? ENV['ANIMAL_HOME'] : File.expand_path(File.join('~', '.animal'))
FileUtils.mkdir_p(ANIMAL_HOME) unless File.exist?(ANIMAL_HOME)

# Standard Library requirements
require 'yaml'

# External requirements
require 'treetop'

# Internal requirements
require 'animal/version'
require 'animal/classifier'
require 'animal/inventory_plugin'
require 'animal/storage_plugin'
require 'animal/plugins/inventory/fact'
require 'animal/plugins/storage/yaml'
require 'animal/rule'
require 'animal/enc'
