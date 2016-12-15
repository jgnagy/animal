module Animal
  ## Treetop Rules Parsing
  dir = File.expand_path(File.dirname(__FILE__))
  Treetop.load File.expand_path(File.join(dir, 'rules'))

  # Actual Rule class
  class Rule
    def self.all
      rules = []
      Dir.chdir File.expand_path(File.join(ANIMAL_HOME, 'rules.db')) do
        Dir.glob('*.yml').each do |rule_file|
          YAML.load_file(rule_file).each do |data|
            if data.key?(:failure)
              rules << Rule.new(data[:statement], data[:success], data[:failure])
            else
              rules << Rule.new(data[:statement], data[:success])
            end
          end
        end
      end
      rules
    end

    def self.apply_all_for(node)
      operations = {add: [], subtract: []}
      all.each do |rule|
        result = rule.apply_for(node)
        operations[:add].concat result[:add] if result.key?(:add)
        operations[:subtract].concat result[:subtract] if result.key?(:subtract)
      end
      operations[:add].uniq - operations[:subtract]
    end

    def initialize(statement, when_true, when_false = {})
      @statement  = statement
      @when_true  = when_true
      @when_false = when_false
    end

    def parse
      parser = RulesParser.new
      result = parser.parse(@statement)
      result.conditions
    end

    def evaluate(node, condition)
      # TODO this is going to take some work for parenthetical expressions
      result = false

      case
      when condition[:conjunction] == :and
        subresult = nil
        condition[:conditions].each do |subcondition|
          subresult = evaluate(node, subcondition)
          break if subresult.is_a? FalseClass
        end
        result = subresult
      when condition[:conjunction] == :or
        subresult = nil
        condition[:conditions].each do |subcondition|
          subresult = evaluate(node, subcondition)
          break if subresult.is_a? TrueClass
        end
        result = subresult
      when condition[:operator] == :like
        # Constantize the plugin based on the class name
        class_name = "Animal::Plugins::#{condition[:plugin]}"
        plugin = Class.const_get(class_name)
        # Use the plugin to lookup a key and match it against the condition's value
        result = plugin.get(node, condition[:key]).match condition[:value]
      when condition[:operator] == '='.to_sym
        class_name = "Animal::Plugins::#{condition[:plugin]}"
        plugin = Class.const_get(class_name)
        result = plugin.get(node, condition[:key]) == condition[:value]
      when ['!=', '>=', '<=', '>', '<'].include?(condition[:operator].to_s)
        class_name = "Animal::Plugins::#{condition[:plugin]}"
        plugin = Class.const_get(class_name)
        result = plugin.get(node, condition[:key]).send(condition[:operator], condition[:value])
      end

      result
    end

    def apply_for(node)
      begin
        evaluate(node, parse) ? @when_true : @when_false
      rescue => e
        # TODO output something for debugging here since evaluate failed to run
        {}
      end
    end
  end
end
