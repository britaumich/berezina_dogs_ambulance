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

RSpec.describe "/admin_users", type: :request do

  before(:each) do
    admin_user = FactoryBot.create(:admin_user)
    user = FactoryBot.create(:user, email_address: admin_user.email)
    animal_type_dog = FactoryBot.create(:animal_type, name: 'собака', plural_name: 'собаки')
    sign_in(user)
  end
  
  # This should return the minimal set of attributes required to create a valid
  # AdminUser. As you add validations to AdminUser, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { email: "test@test.com" }
  }

  let(:invalid_attributes) {
    { email: "" }
  }

  describe "GET /index" do
    it "renders a successful response" do
      AdminUser.create! valid_attributes
      get admin_users_url
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_admin_user_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      admin_user = AdminUser.create! valid_attributes
      get edit_admin_user_url(admin_user)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new AdminUser" do
        expect {
          post admin_users_url, params: { admin_user: valid_attributes }
        }.to change(AdminUser, :count).by(1)
      end

      it "redirects to the admin_user index page" do
        post admin_users_url, params: { admin_user: valid_attributes }
        expect(response).to redirect_to(admin_users_url)
      end
    end

    context "with invalid parameters" do
      it "does not create a new AdminUser" do
        expect {
          post admin_users_url, params: { admin_user: invalid_attributes }
        }.to change(AdminUser, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post admin_users_url, params: { admin_user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { email: "test1@test.com" }
      }

      it "updates the requested admin_user" do
        admin_user = AdminUser.create! valid_attributes
        patch admin_user_url(admin_user), params: { admin_user: new_attributes }
        admin_user.reload
        expect(admin_user.email).to eq("test1@test.com")
      end

      it "redirects to the admin_users index page" do
        admin_user = AdminUser.create! valid_attributes
        patch admin_user_url(admin_user), params: { admin_user: new_attributes }
        admin_user.reload
        expect(response).to redirect_to(admin_users_url)
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        admin_user = AdminUser.create! valid_attributes
        patch admin_user_url(admin_user), params: { admin_user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested admin_user" do
      admin_user = AdminUser.create! valid_attributes
      expect {
        delete admin_user_url(admin_user)
      }.to change(AdminUser, :count).by(-1)
    end

    it "doesn't show admin_user on the page" do
      admin_user = AdminUser.create! valid_attributes
      delete admin_user_url(admin_user)
      expect(AdminUser.exists?(admin_user.id)).to be_falsey
    end
  end
end
