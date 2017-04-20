require 'spec_helper'

RSpec.describe PsqlAutocomplete do
  it 'has a version number' do
    expect(PsqlAutocomplete::VERSION).not_to be_nil
  end

  class ModelDouble
    extend PsqlAutocomplete
  end

  describe '.autocomplete_query' do
    it 'generate an autocomplete queries' do
      input = 'Foo & baR', [:Title, :boDy]

      tsvector = "(coalesce(lower(regexp_replace(Title, '[:'']', '', 'g')), '') || ' ' || coalesce(lower(regexp_replace(boDy, '[:'']', '', 'g')), ''))::tsvector"
      tsquery = "$$'foo':* & '&':* & 'bar':*$$::tsquery"

      expect(ModelDouble.autocomplete_query(*input)).
        to eq("#{tsvector} @@ #{tsquery}")
    end

    it 'handles apostrophe' do
      input = "L'Oréal", [:Title, :boDy]

      tsvector = "(coalesce(lower(regexp_replace(Title, '[:'']', '', 'g')), '') || ' ' || coalesce(lower(regexp_replace(boDy, '[:'']', '', 'g')), ''))::tsvector"
      tsquery = "$$'l''oréal':*$$::tsquery"

      expect(ModelDouble.autocomplete_query(*input)).
        to eq("#{tsvector} @@ #{tsquery}")
    end

    it 'handles commas' do
      input = 'foo ) (bar', [:Title, :boDy]

      tsvector = "(coalesce(lower(regexp_replace(Title, '[:'']', '', 'g')), '') || ' ' || coalesce(lower(regexp_replace(boDy, '[:'']', '', 'g')), ''))::tsvector"
      tsquery = "$$'foo':* & ')':* & '(bar':*$$::tsquery"

      expect(ModelDouble.autocomplete_query(*input)).
        to eq("#{tsvector} @@ #{tsquery}")
    end

    it 'handles unaccent' do
      input = ['Foo & baR', [:Title, :boDy], unaccent: true]

      tsvector = "(unaccent(coalesce(lower(regexp_replace(Title, '[:'']', '', 'g')), '')) || ' ' || unaccent(coalesce(lower(regexp_replace(boDy, '[:'']', '', 'g')), '')))::tsvector"
      tsquery = "unaccent($$'foo':* & '&':* & 'bar':*$$)::tsquery"

      expect(ModelDouble.autocomplete_query(*input)).
        to eq("#{tsvector} @@ #{tsquery}")
    end
  end
end
