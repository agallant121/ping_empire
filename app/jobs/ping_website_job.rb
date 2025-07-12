require "net/http"

class PingWebsiteJob < ApplicationJob
  queue_as :default

  def perform(website_id)
    website = Website.find_by(id: website_id)
    return unless website

    uri = URI.parse(website.url)
    start_time = Time.now
    result = Net::HTTP.get_response(uri)
    response_time_ms = ((Time.now - start_time) * 1000).to_i

    Response.create!(
      website: website,
      status_code: result.code.to_i,
      response_time: response_time_ms,
      checked_at: Time.now
    )
  rescue => e
    Response.create!(
      website: website,
      status_code: nil,
      response_time: nil,
      checked_at: Time.now,
      error_message: e.message
    )
  end
end
