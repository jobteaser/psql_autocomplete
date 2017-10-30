require 'psql_autocomplete/version'

# Helper mixin for generating autocomplete queries
# on the postgresql full text search engine
module PsqlAutocomplete
  # Returns a postgres FTS query injectable in a where clause
  def autocomplete_query(sentence, fields, unaccent: false)
    "(#{tsvector(fields, unaccent)})::tsvector @@ " \
      "#{tsquery(sentence, unaccent)}::tsquery"
  end

  private

  def tsvector(fields, unaccent)
    sanitize = method(:sql_sanitize_column).curry[unaccent]
    fields.map(&sanitize).join(" || ' ' || ")
  end

  def sql_sanitize_column(unaccent, field)
    column = unaccent ? "unaccent(#{field})" : field
    "coalesce(lower(regexp_replace(#{column}, '[:''’]', '', 'g')), '')"
  end

  def tsquery(sentence, unaccent)
    query = sentence.
      downcase.
      split(' ').
      map(&:strip).
      compact.
      map { |q| "'#{q.gsub(/['’]/, "''")}':*" }.
      join(' & ')

    query = "$$#{query}$$"

    return query unless unaccent

    "unaccent(#{query})"
  end
end
