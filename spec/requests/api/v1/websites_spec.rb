require 'rails_helper'

RSpec.describe "Api::V1::Websites", type: :request do

  it "creates a new website" do
    websites_count = Website.count
    post "/api/v1/websites", params: { url: "https://google.com" }

    expect(response).to have_http_status(:created)
    expect(Website.count).to eq(websites_count + 1)

    json = JSON.parse(response.body)
    expect(json["url"]).to eq("https://google.com")
  end

  context "get websites that exist and don't exist" do
    let!(:website) { Website.create!(url: "https://www.google.com") }
    
    it "returns the website and its reponses" do
      website.responses.create!(status_code: 200, response_time: 100, checked_at: Time.now)
      website.responses.create!(status_code: 404, response_time: 200, checked_at: Time.now - 1.day)

      get "/api/v1/websites/#{website.id}"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["website"]["id"]).to eq(website.id)
      expect(json["website"]["url"]).to eq(website.url)
      expect(json["responses"].length).to eq(2)
    end

    it "returns an error when website does not exist" do
      get "/api/v1/websites/987654321"

      expect(response).to have_http_status(:not_found)

      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Website not found")
    end
  end

  it "returns a list of websites" do
    Website.create!(url: "https://google.com")
    Website.create!(url: "https://yahoo.com")

    get "/api/v1/websites"

    expect(response).to have_http_status(:ok)

    json = JSON.parse(response.body)
    expect(json.length).to eq(2)
    expect(json.first["url"]).to eq("https://google.com")
    expect(json.last["url"]).to eq("https://yahoo.com")
  end

  context "deleting when there are/are no websites" do
    it "deletes a website that exists" do
      website = Website.create!(url: "https://google.com")
      websites_count = Website.count

      delete "/api/v1/websites/#{website.id}"

      expect(response).to have_http_status(:no_content) 
      expect(Website.count).to eq(websites_count - 1)
    end

    it "returns an error when deleting a website that does not exist" do
      delete "/api/v1/websites/987654321"

      expect(response).to have_http_status(:not_found)

      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Website not found")
    end
  end

end
