# The Animal namespace module
module Animal
  ## Treetop Rules Parsing
  dir = File.expand_path(File.dirname(__FILE__))
  Treetop.load File.expand_path(File.join(dir, 'rules'))

  # The basis for the rules engine used for classifying nodes
  class Rule
    def self.all
      rules = []
      Dir.chdir File.expand_path(File.join(ANIMAL_HOME, 'rules.db')) do
        Dir.glob('*.yml').each do |rule_file|
          YAML.load_file(rule_file).each do |data|
            rules << if data.key?(:failure)
                       Rule.new(data[:statement], data[:success], data[:failure])
                     else
                       Rule.new(data[:statement], data[:success])
                     end
          end
        end
      end
      rules
    end

    def self.apply_all_for(node)
      operations = { add: [], subtract: [] }
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

    # Used to evaluate the conditions provided by parsing a rule statement
    # rubocop:disable Metrics/AbcSize
    def evaluate(node, condition)
      plugin = get_plugin_class(condition[:plugin]) if condition.key?(:plugin)
      if [:and, :or].include? condition[:conjunction]
        recurse_on_conjunction(node, condition[:conditions], condition[:conjunction])
      elsif condition[:operator] == :like
        # Use the plugin to lookup a key and match it against the condition's value
        plugin.get(node, condition[:key]).match condition[:value]
      elsif condition[:operator] == '='.to_sym
        plugin.get(node, condition[:key]) == condition[:value]
      elsif ['!=', '>=', '<=', '>', '<'].include?(condition[:operator].to_s)
        plugin.get(node, condition[:key]).send(condition[:operator], condition[:value])
      else
        false
      end
    end

    def recurse_on_conjunction(node, conditions, conjunction)
      if conjunction == :all
        subresult = nil
        conditions.each do |subcondition|
          subresult = evaluate(node, subcondition)
          break if subresult.is_a? FalseClass
        end
        subresult
      elsif conjunction == :or
        subresult = nil
        conditions.each do |subcondition|
          subresult = evaluate(node, subcondition)
          break if subresult.is_a? TrueClass
        end
        subresult
      end
    end

    def apply_for(node)
      evaluate(node, parse) ? @when_true : @when_false
    rescue => e
      # TODO: output something for debugging here since evaluate failed to run
      STDERR.puts "Exception occurred on Rule#apply_for(#{node}) for `#{@statement}`: #{e.message}"
      {}
    end

    private

    # Constantize the plugin based on the class name
    def get_plugin_class(name)
      Class.const_get("Animal::Plugins::#{name}")
    end
  end
end
