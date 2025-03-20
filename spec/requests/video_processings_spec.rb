require 'rails_helper'

RSpec.describe "VideoProcessings", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/video_processings/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/video_processings/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/video_processings/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/video_processings/show"
      expect(response).to have_http_status(:success)
    end
  end

end
