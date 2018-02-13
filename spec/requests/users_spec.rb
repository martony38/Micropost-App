require 'rails_helper'

=begin
def is_logged_in?
  !session[:user_id].nil?
end
=end

RSpec.describe "Following", type: :request do

  describe "GET /user/id/following" do

    context "when user follows another user" do

      it "displays following list" do
        2.times do
          user = create(:random_user)
        end
        log_in_as(user = create(:random_user))
        relationship1 = create(:relationship, follower_id: User.last.id, followed_id: User.last.id - 1)
        relationship2 = create(:relationship, follower_id: User.last.id, followed_id: User.last.id - 2)
        get following_user_path(user)
        expect(user.following.empty?).to eq(false)
        expect(response.body).to match(user.following.count.to_s)
        user.following.each do |user|
          assert_select "a[href=?]", user_path(user)
        end
      end

    end

  end

end

RSpec.describe "Followers", type: :request do

  describe "GET /user/id/followers" do

    context "when user is being followed by another user" do

      it "displays followers list" do
        2.times do
          user = create(:random_user)
        end
        log_in_as(user = create(:random_user))
        relationship1 = create(:relationship, followed_id: User.last.id, follower_id: User.last.id - 1)
        relationship2 = create(:relationship, followed_id: User.last.id, follower_id: User.last.id - 2)
        get followers_user_path(user)
        expect(user.followers.empty?).to eq(false)
        expect(response.body).to match(user.followers.count.to_s)
        user.followers.each do |user|
          assert_select "a[href=?]", user_path(user)
        end
      end

    end

  end

end

RSpec.describe "Index", type: :request do

  describe "GET /users" do

    context "when logged in" do

      let(:user) { create :random_user }

      it "works!" do
        log_in_as(user)
        get users_path
        expect(response).to have_http_status(200)
      end

      it "displays the index page" do
        log_in_as(user)
        get users_path
        expect(response).to render_template('users/index')
      end

      it "index page includes pagination" do
        50.times do |n|
          user = create(:random_user)
        end
        log_in_as(user)
        get users_path
        assert_select "div.pagination"
        User.paginate(page: 1).each do |user|
          assert_select "a[href=?]", user_path(user), :text => user.name
        end
      end

      it "does not display unactivated users" do
        unactivated_user = create(:unactivated_user)
        user = create(:random_user)
        log_in_as(user)
        get users_path
        assert_select "a[href=?]", user_path(unactivated_user), :text => unactivated_user.name, count: 0
      end

      context "as non-admin" do

        it "index page does not display delete links" do
          50.times do |n|
            user = create(:random_user)
          end
          log_in_as(user)
          get users_path
          assert_select "a", text: "delete", count: 0
        end

      end

      context "as admin" do

        it "index page includes delete links except for logged in user" do
          50.times do |n|
            user = create(:random_user)
          end
          admin_user = create(:donald)
          log_in_as(admin_user)
          get users_path
          User.paginate(page: 1).each do |user|
            assert_select "a[href=?]", user_path(user), text: "delete", count: user == admin_user ? 0 : 1
          end
        end

      end

    end

  end

  describe "DELETE /users" do

    context "when not logged in" do

      it "does not destroy user" do
        unlogged_user = create(:random_user)
        expect{ delete user_path(unlogged_user) }.to_not change{ User.count }
      end

    end

    context "when logged in" do

      context "as non-admin" do

        it "does not destroy user" do
          unlogged_user = create(:random_user)
          user = create(:random_user)
          log_in_as(user)
          expect{ delete user_path(unlogged_user) }.to_not change{ User.count }
        end

      end

      context "as admin" do

        it "destroys user" do
          unlogged_user = create(:random_user)
          admin_user = create(:donald)
          log_in_as(admin_user)
          expect{ delete user_path(unlogged_user) }.to change{ User.count }.by(-1)
        end

      end

    end

  end

end

RSpec.describe "New", type: :request do

  describe "GET /signup" do

    it "works!" do
      get signup_path
      expect(response).to have_http_status(200)
    end

    it "displays the signup page" do
      get signup_path
      expect(response).to render_template('users/new')
    end

  end

  describe "POST /users" do

    context "with invalid info" do

      let(:invalid_attributes) { { name: "", email: "user@invalid", email_confirmation: "user@veryinvalid", password: "foo", password_confirmation: "bar" } }

      it "does not create a new user" do
        expect{ post users_path, user: invalid_attributes }.to_not change{User.count}
      end

      it "redirects to /users/new" do
        post users_path, user: invalid_attributes
        expect(response).to render_template('users/new')
      end

      it "reports error messages" do
        post users_path, user: invalid_attributes
        expect(response.body).to include("Name can&#39;t be blank" && "Email is invalid" && "Email confirmation doesn&#39;t match Email" && "Password confirmation doesn&#39;t match Password" && "Password is too short (minimum is 6 characters)")
      end

      it "does not send an activation email" do
        expect{ post users_path, user: invalid_attributes }.to_not change{ActionMailer::Base.deliveries.size}
      end

    end

    context "with valid info" do

      let(:valid_attributes) { attributes_for :unactivated_user }

      it "creates a new user" do
        expect{ post users_path, user: valid_attributes }.to change{User.count}.by(1)
      end

      it "sends an activation email" do
        expect{ post users_path, user: valid_attributes }.to change{ActionMailer::Base.deliveries.size}.by(1)
      end

      it "does not activate user" do
        post users_path, user: valid_attributes
        expect(assigns(:user).reload.activated?).to eq(false)
      end

      it "redirects to home page" do
        post users_path, user: valid_attributes
        expect(response).to redirect_to(root_path)
      end

    end

  end

end

RSpec.describe "Show", type: :request do

  describe "GET /users/id" do

    let(:user) { create :donald }

    it "works!" do
      get user_path(user)
      expect(response).to have_http_status(200)
    end

    it "displays the user page" do
      get user_path(user)
      expect(response).to render_template('users/show')
      assert_select 'title', "#{user.name} | Micropost App"
      assert_select "h1", text: user.name
      assert_select "h1>img.gravatar"
    end

    it "displays the user's microposts" do
      user = create(:user_with_microposts)
      get user_path(user)
      expect(response.body).to match(user.microposts.count.to_s)
      assert_select "div.pagination"
      user.microposts.paginate(page: 1).each do |micropost|
        expect(response.body).to match(micropost.content)
      end
    end

    context "when logged in" do

      it "displays the delete links" do
        user = create(:user_with_microposts)
        log_in_as(user)
        get user_path(user)
        assert_select 'a', text: "delete", count: 30
      end

    end

    context "when logged in as different user" do

      it "does not display the delete links" do
        another_user = create(:user_with_microposts)
        log_in_as(user)
        get user_path(another_user)
        assert_select 'a', text: "delete", count: 0
      end

    end

  end

end

RSpec.describe "Edit", type: :request do

  let(:user) { create :donald }

  describe "GET /edit" do

    context "when logged in" do

      it "works!" do
        log_in_as(user)
        get edit_user_path(user)
        expect(response).to have_http_status(200)
      end

      it "displays the edit page" do
        log_in_as(user)
        get edit_user_path(user)
        expect(response).to render_template('users/edit')
      end

    end

    context "when not logged in" do

      it "redirects to login" do
        get edit_user_path(user)
        expect(response).to redirect_to(login_path)
      end

      it "redirects to edit after logging in" do
        get edit_user_path(user)
        log_in_as(user)
        expect(response).to redirect_to(edit_user_path(user))
      end

    end

  end

  describe "PATCH /edit" do

    context "with invalid info" do

      let(:invalid_attributes) { { name: "", email: "user@invalid", email_confirmation: "user@veryinvalid", password: "foo", password_confirmation: "bar" } }

      it "redirects to users/edit" do
        log_in_as(user)
        patch user_path(user), user: invalid_attributes
        expect(response).to render_template('users/edit')
      end

      it "does not update user info" do
        log_in_as(user)
        patch user_path(user), user: invalid_attributes
        assigns(:user).reload
        expect(assigns(:user)).to eq(user)
      end

      it "does not update email without confirmation" do
        invalid_attributes = { email: "updated@email.com" }
        log_in_as(user)
        patch user_path(user), user: invalid_attributes
        assigns(:user).reload
        expect(assigns(:user)).to eq(user)
      end

      it "does not update password without confirmation" do
        invalid_attributes = { password: "new_password" }
        log_in_as(user)
        patch user_path(user), user: invalid_attributes
        assigns(:user).reload
        expect(assigns(:user)).to eq(user)
      end

    end

    context "with valid info" do

      let(:valid_attributes) { { name: "Updated Name", email: "updated@email.com", email_confirmation: "updated@email.com", password: "new_password", password_confirmation: "new_password" } }

      it "flashes sucess" do
        log_in_as(user)
        patch user_path(user), user: valid_attributes
        assert flash[:success]
      end

      it "displays user page" do
        log_in_as(user)
        patch user_path(user), user: valid_attributes
        expect(response).to redirect_to(assigns(:user))
      end

      it "updates all user info" do
        log_in_as(user)
        patch user_path(user), user: valid_attributes
        assigns(:user).reload
        expect(assigns(:user).name).to eq(valid_attributes[:name])
        expect(assigns(:user).email).to eq(valid_attributes[:email])
        expect(BCrypt::Password.new(assigns(:user).password_digest).is_password?(valid_attributes[:password])).to eq(true)
      end

      it "only updates user name" do
        valid_attributes = { name: "updated Name" }
        log_in_as(user)
        patch user_path(user), user: valid_attributes
        assigns(:user).reload
        expect(assigns(:user).name).to eq(valid_attributes[:name])
      end

      it "only updates user email" do
        valid_attributes = { email: "updated@email.com", email_confirmation: "updated@email.com" }
        log_in_as(user)
        patch user_path(user), user: valid_attributes
        assigns(:user).reload
        expect(assigns(:user).email).to eq(valid_attributes[:email])
      end

      it "only updates user password" do
        valid_attributes = { password: "new_password", password_confirmation: "new_password" }
        log_in_as(user)
        patch user_path(user), user: valid_attributes
        assigns(:user).reload
        expect(BCrypt::Password.new(assigns(:user).password_digest).is_password?(valid_attributes[:password])).to eq(true)
      end

    end

  end

end