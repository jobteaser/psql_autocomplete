require 'psql_autocomplete/version'

# Helper mixin for generating autocomplete queries
# on the postgresql full text search engine
module PsqlAutocomplete
  # Returns a postgres FTS query injectable in a where clause
  def autocomplete_query(sentence, fields)
    "to_tsvector('simple', #{tsvector(fields)}) @@ #{tsquery(sentence)}"
  end

  private

  def tsvector(fields)
    fields.map { |field| "coalesce(#{field},'')" }.join(" || ' ' || ")
  end

  def tsquery(sentence)
    words = sentence.split(' ').map(&:strip).compact.map { |q| "#{q}:*" }.join(' & ')
    sanitize_sql_array ["to_tsquery('simple', ?)", words]
  end
end
