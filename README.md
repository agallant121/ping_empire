# Ping Empire

A simple Rails API for monitoring uptime and response information on website endpoints.

## Architecture

- **Models**
  - `Website` — tracks URLs to monitor
  - `Response` — stores status, response_time (ms), and optional error

- **Jobs**
  - `PingAllWebsitesJob`: enqueues a `PingWebsiteJob` for each URL
  - `PingWebsiteJob`: makes HTTP call, times the request, saves a `Response`

## Setup & Usage

1. Clone the repo.
2. Run `bundle install` and `yarn install` if needed.
3. `rails db:setup` to create database.
4. Start Sidekiq: `bundle exec sidekiq`.
5. (Optional) Start Rails server: `rails s`.
6. Pings run automatically on schedule via `sidekiq-scheduler` (configured in `sidekiq.yml`) from `sidekiq.rb` initializer.

