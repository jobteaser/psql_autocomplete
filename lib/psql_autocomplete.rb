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
    fields.map(&method(:sql_sanitize_column)).join(" || ' ' || ")
  end

  def sql_sanitize_column(field)
    "coalesce(lower(regexp_replace(#{field}, '[:'']', '', 'g')), '')"
  end

  def tsquery(sentence)
    sentence.
      downcase.
      split(' ').
      map(&:strip).
      compact.
      map { |q| "'#{q.gsub("'", "''")}':*" }.
      join(' & ')
  end
end
