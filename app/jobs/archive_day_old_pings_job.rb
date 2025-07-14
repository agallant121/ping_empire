require "csv"

class ArchiveDayOldPingsJob < ApplicationJob
  queue_as :default

  def perform
    responses = Response.more_than_one_day_old
    return if responses.empty?

    file_path = "archive/responses#{Time.current.strftime("%Y-%m-%d_%H-%M-%S")}.csv"

    CSV.open(file_path, "w") do |csv|
      csv << %w[id website_id status_code response_time checked_at created_at]
      responses.find_each do |response|
        csv << [
          response.id,
          response.website_id,
          response.status_code,
          response.response_time,
          response.checked_at,
          response.created_at
        ]
      end
    end 

    file_saved = File.exist?(file_path) && File.size?(file_path) > 0
    raise "CSV file not saved!" unless file_saved
    responses.delete_all if file_saved
  end

end
