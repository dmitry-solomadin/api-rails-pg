## General Info

Project is a API with frontend written in different frameworks (ember/react you can find repos in my profile).

### Core functionality

* `Post` & `Comment` models -> create/update/delete posts and comments
* User as posts and comments author
* User abilities (3xcan) — admin, user, guest
* Simple token authentication

## Install

1. You have to have `rails` and `postgres` installed.
2. `bundle`
3. `rake db:create && rake db:migrate && rake db:seed`
4. `rails s` to launch server (frontend apps expect that server is run on `localhost:3000`)

## Run Tests

1. `rake db:migrate RAILS_ENV=test`
2. `rspec`


