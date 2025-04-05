require 'rails_helper'

RSpec.describe "Homes", type: :request do

  before(:each) do
    animal_type_dog = FactoryBot.create(:animal_type, name: 'собака', plural_name: 'собаки')
  end

  describe "GET /index" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end

end
