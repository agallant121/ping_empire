# Ping Empire

A simple Rails API for monitoring uptime and response information on website endpoints.

## Architecture

- **Models**
  - `Website` — tracks URLs to monitor
  - `Response` — stores status, response_time (ms), and optional error

- **Jobs**
  - `PingAllWebsitesJob`: enqueues a `PingWebsiteJob` for each URL (Website).
  - `PingWebsiteJob`: makes call to website, times the request, crates/saves a `Response`.

## Setup & Usage

1. Clone the repo.
2. Run `bundle install` and `yarn install` if needed.
3. `rails db:setup` to create database.
4. Start Sidekiq: `bundle exec sidekiq`.
5. (Optional) Start Rails server: `rails s`.
6. Pings run automatically on schedule via `sidekiq-scheduler` (configured in `sidekiq.yml`) from `sidekiq.rb` initializer.

## API Endpoints

- `POST /api/v1/websites` — create new Website with URL
- `GET /api/v1/websites` — list Websites and their URLs
- `GET /api/v1/websites/:id` — show Website and its responses
- `DELETE /api/v1/websites/:id` — remove Website

## Archiving
`ArchiveDayOldPingsJob`: runs daily (via sidekiq-scheduler) to:

Export all Response records older than 24 hours to a timestamped CSV file in the archive/ directory.

Delete those responses from the database only after confirming the CSV file was saved successfully.

