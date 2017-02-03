require 'spec_helper'

describe Animal::Rule do
  context 'given a simple rule statement' do
    subject { Animal::Rule.new('Fact["test.bar"] = true', add: ['role::test']) }

    it 'should parse correctly' do
      correct_result = { operator: :"=", plugin: 'Fact', key: 'test.bar', value: true }
      expect(subject.parse).to eq(correct_result)
    end
  end

  context 'given a complex rule statement' do
    subject do
      statement = '(Fact["test"] = true OR Fact["foo"] >= 10) AND Fact["bar"] LIKE "^b(in|az)$"'
      Animal::Rule.new(statement, add: ['role::test'])
    end

    it 'should parse correctly' do
      correct_result = {
        conditions: [
          {
            conditions: [
              {
                operator: :"=",
                plugin: 'Fact',
                key: 'test',
                value: true
              },
              {
                operator: :>=,
                plugin: 'Fact',
                key: 'foo',
                value: 10
              }
            ],
            conjunction: :or
          },
          {
            operator: :like,
            plugin: 'Fact',
            key: 'bar',
            value: '^b(in|az)$'
          }
        ],
        conjunction: :and
      }
      expect(subject.parse).to eq(correct_result)
    end
  end
end
