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
        %{to_tsvector('simple', coalesce(title,'') || ' ' || coalesce(body,'')) @@ ["to_tsquery('simple', ?)", "query:*"]}
      )
    end

  end
end
