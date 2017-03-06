require 'spec_helper'

describe PsqlAutocomplete do
  it 'has a version number' do
    expect(PsqlAutocomplete::VERSION).not_to be nil
  end

  context 'mixin' do

    # Mock model
    class ModelDouble

      extend PsqlAutocomplete

      # Expected sanitization pass
      def self.sanitize_sql_array(fields)
        fields
      end

    end

    it 'generate autocomplete queries' do
      expect(ModelDouble.autocomplete_query('query', [:title, :body])).to eq(
        %{(coalesce(title,'') || ' ' || coalesce(body,''))::tsvector @@ $$'query':*$$::tsquery}
      )
    end

  end
end
