# Install

1. You have to have `rails` and `postgres` installed.
2. `bundle`
3. `rake db:create && rake db:migrate && rake db:seed`
4. `rails s` to launch server (frontend apps expect that server is run on `localhost:3000`)

# Run Tests

1. `rake db:migrate RAILS_ENV=test`
2. `rspec`
