require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:user) { create :donald }
  let(:wrong_user) { create :mickey }

  describe "GET #following" do

    context "when not logged in" do

      it "redirects to login" do
        get :following, id: user
        expect(response).to redirect_to(login_path)
      end

    end

  end

  describe "GET #followers" do

    context "when not logged in" do

      it "redirects to login" do
        get :followers, id: user
        expect(response).to redirect_to(login_path)
      end

    end

  end

  describe "GET #index" do

  	context "when not logged in" do

  		it "redirects to login page" do
  			get :index
  			expect(response).to redirect_to(login_path)
  		end

  	end

  end

  describe "GET #new" do

    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

  end

  describe "GET #show" do

    context "when user activated" do

      it "show user" do
        get :show, id:user
        expect(response).to have_http_status(:success)
      end

    end

    context "when user not activated" do

      it "show user" do
        user = create(:unactivated_user)
        get :show, id:user
        expect(response).to redirect_to(root_path)
      end

    end

  end

  describe "GET #edit" do

  	context "when not logged in" do

  		it "flashes an alert" do
  			get :edit, id: user
  			assert flash[:danger]
  		end

  		it "redirects to login page" do
  			get :edit, id: user
  			expect(response).to redirect_to(login_path)
  		end

  	end

  	context "when logged in as wrong user" do

  		it "does not flashes anything" do
  			log_in_as(wrong_user)
  			get :edit, id: user
  			expect(flash.empty?).to eq(true)
  		end

  		it "redirects to root" do
  			log_in_as(wrong_user)
  			get :edit, id: user
  			expect(response).to redirect_to(root_path)
  		end

  	end

  end

  describe "PATCH #update" do

  	context "when not logged in" do

  		it "flashes an alert" do
  			patch :update, id: user, user: { name: "Updated Name" }
  			assert flash[:danger]
  		end

  		it "redirects to login page" do
  			patch :update, id: user, user: { name: "Updated Name" }
  			expect(response).to redirect_to(login_path)
  		end

  	end

    context "when logged in" do

      it "does not allow the admin attribute to be edited via the web" do
        log_in_as(user = create(:random_user))
        expect(user.admin?).to eq(false)
        patch :update, id: user, user: { admin: true }
        user.reload
        expect(user.admin?).to eq(false)
      end

      context "as wrong user" do

        it "does not flashes anything" do
          log_in_as(wrong_user)
          patch :update, id: user, user: { name: "Updated Name" }
          expect(flash.empty?).to eq(true)
        end

        it "redirects to root" do
          log_in_as(wrong_user)
          patch :update, id: user, user: { name: "Updated Name" }
          expect(response).to redirect_to(root_path)
        end

      end

    end



  end

  describe "DELETE #destroy" do

    context "when not logged in" do

      it "does not destroy user" do
        unlogged_user = user
        expect{ delete :destroy, id: user }.to_not change{ User.count }
      end

      it "redirects to login page" do
        unlogged_user = user
        delete :destroy, id: user
        expect(response).to redirect_to(login_path)
      end

    end

    context "when logged in as non-admin" do

      it "does not destroy user" do
        unlogged_user = create(:random_user)
        non_admin_user = create(:random_user)
        log_in_as(non_admin_user)
        expect{ delete :destroy, id: unlogged_user }.to_not change{ User.count }
      end

      it "redirects to root" do
        unlogged_user = create(:random_user)
        non_admin_user = create(:random_user)
        log_in_as(non_admin_user)
        delete :destroy, id: unlogged_user
        expect(response).to redirect_to(root_path)
      end

    end

    context "when logged in as admin" do

      it "destroys user" do
        unlogged_user = create(:random_user)
        admin_user = user
        log_in_as(admin_user)
        expect{ delete :destroy, id: unlogged_user }.to change{ User.count }.by(-1)
      end

    end

  end

end
