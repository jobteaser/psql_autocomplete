require 'spec_helper'

RSpec.describe PsqlAutocomplete do
  it 'has a version number' do
    expect(PsqlAutocomplete::VERSION).not_to be_nil
  end

  # Mock model
  class ModelDouble
    extend PsqlAutocomplete
  end

  describe '.autocomplete_query' do
    it 'generate an autocomplete queries' do
      input = 'Foo & baR', [:Title, :boDy]

      tsvector = "(coalesce(lower(Title),'') || ' ' || coalesce(lower(boDy),''))::tsvector"
      tsquery = "$$'foo':* & '&':* & 'bar':*$$::tsquery"

      expect(ModelDouble.autocomplete_query(*input)).
        to eq("#{tsvector} @@ #{tsquery}")
    end

    it 'handles apostrophe' do
      input = "L'Oréal", [:Title, :boDy]

      tsvector = "(coalesce(lower(Title),'') || ' ' || coalesce(lower(boDy),''))::tsvector"
      tsquery = "$$'l''oréal':*$$::tsquery"

      expect(ModelDouble.autocomplete_query(*input)).
        to eq("#{tsvector} @@ #{tsquery}")
    end

    it 'handles commas' do
      input = 'foo ) (bar', [:Title, :boDy]

      tsvector = "(coalesce(lower(Title),'') || ' ' || coalesce(lower(boDy),''))::tsvector"
      tsquery = "$$'foo':* & ')':* & '(bar':*$$::tsquery"

      expect(ModelDouble.autocomplete_query(*input)).
        to eq("#{tsvector} @@ #{tsquery}")
    end
  end
end
