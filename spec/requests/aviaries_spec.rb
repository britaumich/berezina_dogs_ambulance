require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/aviaries", type: :request do

  before(:each) do
    admin_user = FactoryBot.create(:admin_user)
    user = FactoryBot.create(:user, email_address: admin_user.email)
    animal_type_dog = FactoryBot.create(:animal_type, name: 'собака', plural_name: 'собаки')
    sign_in(user)
  end
  
  # This should return the minimal set of attributes required to create a valid
  # Aviary. As you add validations to Aviary, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { name: "вольер" }
  }

  let(:invalid_attributes) {
    { name: "" }
  }

  describe "GET /index" do
    it "renders a successful response" do
      Aviary.create! valid_attributes
      get aviaries_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      aviary = Aviary.create! valid_attributes
      get aviary_url(aviary)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_aviary_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      aviary = Aviary.create! valid_attributes
      get edit_aviary_url(aviary)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Aviary" do
        expect {
          post aviaries_url, params: { aviary: valid_attributes }
        }.to change(Aviary, :count).by(1)
      end

      it "redirects to the created aviary" do
        post aviaries_url, params: { aviary: valid_attributes }
        expect(response).to redirect_to(aviary_url(Aviary.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Aviary" do
        expect {
          post aviaries_url, params: { aviary: invalid_attributes }
        }.to change(Aviary, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post aviaries_url, params: { aviary: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { name: "новый вольер" }
      }

      it "updates the requested aviary" do
        aviary = Aviary.create! valid_attributes
        patch aviary_url(aviary), params: { aviary: new_attributes }
        aviary.reload
        expect(aviary.name).to eq("Новый вольер")
      end

      it "redirects to the aviary" do
        aviary = Aviary.create! valid_attributes
        patch aviary_url(aviary), params: { aviary: new_attributes }
        aviary.reload
        expect(response).to redirect_to(aviary_url(aviary))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        aviary = Aviary.create! valid_attributes
        patch aviary_url(aviary), params: { aviary: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested aviary" do
      aviary = Aviary.create! valid_attributes
      expect {
        delete aviary_url(aviary)
      }.to change(Aviary, :count).by(-1)
    end

    it "redirects to the aviaries list" do
      aviary = Aviary.create! valid_attributes
      delete aviary_url(aviary)
      expect(Aviary.exists?(aviary.id)).to be_falsey
    end
  end
end
