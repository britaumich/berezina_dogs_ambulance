require 'rails_helper'

RSpec.describe "Homes", type: :request do

  before(:each) do
    admin_user = FactoryBot.create(:admin_user)
    user = FactoryBot.create(:user, email_address: admin_user.email)
    animal_type_dog = FactoryBot.create(:animal_type, name: 'собака', plural_name: 'собаки')
    sign_in(user)
  end

  describe "GET /index" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end

end
