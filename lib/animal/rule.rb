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

    def self.evaluate_all(node)
      operations = {add: [], subtract: []}
      all.each do |rule|
        result = rule.evaluate(node)
        operations[:add].concat result[:add] if result.key?(:add)
        operations[:subtract].concat result[:subtract] if result.key?(:subtract)
      end
      operations
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

    def evaluate(node, condition = parse)
      # TODO this is going to take some work for parenthetical expressions
      result = false
      condition.each do |parsed_condition|
        case
        when parsed_condition.is_a?(Array)
          # When the parsed condition is an Array, send it back to be evaluated on its own
          result = evaluate(node, parsed_condition)
        when parsed_condition[:operator] == :LIKE
          # Constantize the plugin based on the class name
          class_name = "Animal::Plugins::#{parsed_condition[:plugin]}"
          plugin = Class.const_get(class_name)
          # Use the plugin to lookup a key and match it against the condition's value
          result = plugin.get(node, parsed_condition[:key]).match parsed_condition[:value]
        when parsed_condition[:operator] == '='.to_sym
          class_name = "Animal::Plugins::#{parsed_condition[:plugin]}"
          plugin = Class.const_get(class_name)
          result = plugin.get(node, parsed_condition[:key]) == parsed_condition[:value]
        when ['!=', '>=', '<=', '>', '<'].include?(parsed_condition[:operator].to_s)
          class_name = "Animal::Plugins::#{parsed_condition[:plugin]}"
          plugin = Class.const_get(class_name)
          result = plugin.get(node, parsed_condition[:key]).send(parsed_condition[:operator], parsed_condition[:value])
        end
      end
      result ? @when_true : @when_false
    end
  end
end
