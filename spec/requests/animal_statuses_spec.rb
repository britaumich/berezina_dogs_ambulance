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

RSpec.describe "/animal_statuses", type: :request do

  before(:each) do
    admin_user = FactoryBot.create(:admin_user)
    user = FactoryBot.create(:user, email_address: admin_user.email)
    animal_type_dog = FactoryBot.create(:animal_type, name: 'собака', plural_name: 'собаки')
    sign_in(user)
  end

  # This should return the minimal set of attributes required to create a valid
  # AnimalStatus. As you add validations to AnimalStatus, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { name: "в приюте" } }
  let(:invalid_attributes) { { name: "" } }

  describe "GET /index" do
    it "renders a successful response" do
      AnimalStatus.create! valid_attributes
      get animal_statuses_url
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_animal_status_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      animal_status = AnimalStatus.create! valid_attributes
      get edit_animal_status_url(animal_status)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new AnimalStatus" do
        expect {
          post animal_statuses_url, params: { animal_status: valid_attributes }
        }.to change(AnimalStatus, :count).by(1)
      end

      it "redirects to the animal_statuses index page" do
        post animal_statuses_url, params: { animal_status: valid_attributes }
        expect(response).to redirect_to(animal_statuses_url)
      end
    end

    context "with invalid parameters" do
      it "does not create a new AnimalStatus" do
        expect {
          post animal_statuses_url, params: { animal_status: invalid_attributes }
        }.not_to change(AnimalStatus, :count)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post animal_statuses_url, params: { animal_status: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { name: "умер" }
      }

      it "updates the requested animal_status" do
        animal_status = AnimalStatus.create! valid_attributes
        patch animal_status_url(animal_status), params: { animal_status: new_attributes }
        animal_status.reload
        expect(animal_status.name).to eq("умер")
      end

      it "redirects to the animal_status" do
        animal_status = AnimalStatus.create! valid_attributes
        patch animal_status_url(animal_status), params: { animal_status: new_attributes }
        animal_status.reload
        expect(response).to redirect_to(animal_statuses_url)
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        animal_status = AnimalStatus.create! valid_attributes
        patch animal_status_url(animal_status), params: { animal_status: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested animal_status" do
      animal_status = AnimalStatus.create! valid_attributes
      expect {
        delete animal_status_url(animal_status)
      }.to change(AnimalStatus, :count).by(-1)
    end

    it "doesn't show animal status on the page" do
      animal_status = AnimalStatus.create! valid_attributes
      delete animal_status_url(animal_status)

      expect(AnimalStatus.exists?(animal_status.id)).to be_falsey
    end
  end
end
