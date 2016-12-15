require 'spec_helper'

describe Animal do
  it 'has a version number' do
    expect(Animal::VERSION).not_to be nil
  end
end
