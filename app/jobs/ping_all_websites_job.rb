class PingAllWebsitesJob < ApplicationJob
  queue_as :default

  def perform
    Website.each do |website|
      PingWebsiteJob.perform_later(website.id)
  end
end
