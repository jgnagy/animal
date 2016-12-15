# Animal

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/animal`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'animal'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install animal

## Usage

### Rules

#### Rule Statement Syntax

Animal uses a rules-based approach to classifying nodes, and its rules engine supports a simple yet powerful syntax for building conditions based on installed plugins. It utilizes a delayed merging approach for building a list of Puppet classes to apply to a node, meaning that _subtracting_ a class from a list of classes happens _after_ all the _add_ operations are complete, allowing a _subtract_ to be performed at any point in the rules system. The benefit is that rules need not be evaluated in any particular order.

The actual syntax should be familiar enough for people used to writing either SQL or Puppet code. Here is an example of a simple rule statement:

```
Fact["certname"] = "machine.domain.tld"
```

This rule will use the `Fact` plugin (which is built-in to the core `Animal` library) to lookup the `certname` key and determines if it is equivalent to `"machine.domain.tld"`.

A slightly more complicated rule might look like:

```
(Fact["machine_class"] = "server" AND Fact["os"] = "ubuntu") OR Fact["awesome"] = true
```

This rule will again use the `Fact` plugin (several times, in fact) to first check if both the `machine_class` fact is set to `"server"` _and_ the `os` fact is set to `"ubuntu"`, and only if either of those are `false`, the rule determines if the `awesome` fact is set to the literal `true` value.

There are currently several limitations to the rules syntax, such as:

* Parenthesis are required to force the order of operations for cojunctions (`AND` and `OR`), but is not used to determing which is actually applied first. Parenthesis are, in fact, collapsed before any preceeding conjunction is used, but in `A OR (B AND C)`, if `A` is `true` then `(B AND C)` is never evaluated.
* Rules are recursively evaluated with an arity of 2, meaning they are always evaluated as `A then B` where `B` is one or more subrules. This means that `A AND B OR C` is equivalent to `A AND (B OR C)`.
* Keys sent to plugins, such as `foo` in `Fact["foo"]`, must be double-quoted and can not contain `[`, `]`, or `"`.
* Only these comparison operators are allowed for rules: `=`, `!=`, `>`, `>=`, `<`, `<=`, and `LIKE`. The `LIKE` comparison operator treats the provided value as a regular expression. Do not include the `/` before or after the regular expression.
* Values used in comparisons must be either literal booleans (`true` or `false`), a double-quoted string (`"foo"`), or an Integer (`1`, `2`, etc.). Decimals must currently be treated as strings.

#### Other Rule Components

Besides the rule statement described above, rules also support two additional components, each with two subcomponents. When a rule evaluates to `true`, it is said to be applied successfully, so rules have a `success` component. Otherwise, rules provide a `failure` component for determining what to do when the rule evaluates to `false`. Both of these components are considered optional by the rules engine, though a rule that does nothing should be suspect.

Each of these components support adding and subtracting Puppet classes from the final compiled list of classes returned by the ENC. These addition and subtraction operations are gathered then applied after all such operations are determined -- providing the delayed-merging capability of the tool. To add classes based on the outcome of a rule, define an Array of class names (usually roles or profiles) to return in an `add` section, either under `success` or `failure`. Likewise, define a `subtract` Array as needed.

When using the YAML storage provider (currently the only supported storage provider for Animal), this could be an example rule:

```
- :statement: (Fact["machine_class"] = "server" AND Fact["os"] = "ubuntu") OR Fact["awesome"] = true
  :success:
    :add:
    - roles::linux::server
    - roles::awesome
    :subtract:
    - roles::linux::desktop
```

This rule will add `roles::linux::server` and `roles::awesome`, and will guarantee that `roles::linux::desktop` will not be present in the returned list of Puppet classes if the rule evaluates to `true` for a given Puppet node.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/animal.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

