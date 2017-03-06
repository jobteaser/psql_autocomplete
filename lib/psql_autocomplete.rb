require 'psql_autocomplete/version'

# Helper mixin for generating autocomplete queries
# on the postgresql full text search engine
module PsqlAutocomplete
  # Returns a postgres FTS query injectable in a where clause
  def autocomplete_query(sentence, fields)
    "(#{tsvector(fields)})::tsvector @@ $$#{tsquery(sentence)}$$::tsquery"
  end

  private

  def tsvector(fields)
    fields.map { |field| "coalesce(#{field},'')" }.join(" || ' ' || ")
  end

  def tsquery(sentence)
    sentence.
      split(' ').
      map(&:strip).
      compact.
      map { |q| "'#{q}':*" }.
      join(' & ')
  end
end
