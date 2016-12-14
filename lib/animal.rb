ANIMAL_HOME = ENV['ANIMAL_HOME'] ?  ENV['ANIMAL_HOME'] : File.expand_path(File.join('~', '.animal'))

# Standard Library requirements
require 'yaml'

# External requirements
require 'treetop'

# Internal requirements
require 'animal/version'
require 'animal/classifier'
require 'animal/plugin'
require 'animal/plugins/fact'
require 'animal/rule'
require 'animal/enc'
