# PsqlAutocomplete

[![Build Status](https://travis-ci.org/jobteaser/psql_autocomplete.svg?branch=master)](https://travis-ci.org/jobteaser/psql_autocomplete)
[![Code Climate](https://codeclimate.com/github/jobteaser/psql_autocomplete/badges/gpa.svg)](https://codeclimate.com/github/jobteaser/psql_autocomplete)

This gem introduces a mixin allowing you to run autocomplete queries with the PostgreSQL full text search

It runs a prefix autocomplete on one or multiple fields of your model

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'psql_autocomplete'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install psql_autocomplete

## Usage

```
# Query generation
class Contact < ActiveRecord::Base
  extend PsqlAutocomplete
end

Contact.autocomplete_query('John', [:first_name, :last_name])
# => "(coalesce(lower(regexp_replace(first_name, '[:'']', '', 'g')), '') || ' ' || coalesce(lower(regexp_replace(last_name, '[:'']', '', 'g')), ''))::tsvector @@ $$'john':*$$::tsquery"

Contact.autocomplete_query('John', [:first_name, :last_name], unaccent: true)
# => => "(unaccent(coalesce(lower(regexp_replace(first_name, '[:'']', '', 'g')), '')) || ' ' || unaccent(coalesce(lower(regexp_replace(last_name, '[:'']', '', 'g')), '')))::tsvector @@ unaccent($$'john':*$$)::tsquery"

# You will need to `create extension unaccent` for this option to work

# Actual search
class Contact < ActiveRecord::Base
  extend PsqlAutocomplete

  def self.autocomplete(query)
    where(autocomplete_query(query, [:first_name, :last_name]))
  end
end

Contact.autocomplete('Jules')
# => [#<Contact:0x0x007fd2be761220>, #<Contact:0x007fd2be760938>, ...]
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
