require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "form_for creates correction action attribute" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_select "form#edit_user_#{@user.id}"
    assert_select "form[action=\"#{user_path(@user)}\"]"
  end

  test "unsuccessful edit" do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
      user: {
        name: '',
        email: "foo@invalid",
        password: "foo",
        password_confirmation: "bar"
      }
    }
    assert_template 'users/edit'
    assert_select 'div#error_explanation ul' do
      assert_select "li", 4
    end
  end

  test "successful edit" do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
      user: {
        name: "Foo Bar",
        email: "foo@bar.com",
        password: "",
        password_confirmation: ""
      }
    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal "Foo Bar", @user.name
    assert_equal "foo@bar.com", @user.email
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)

    # check that a forwarding url has been added to session
    assert_equal edit_user_url(@user), session[:forwarding_url]
    log_in_as(@user)
    # check that the forwarding url was followed and deleted from session
    assert session[:forwarding_url].nil?
    assert_redirected_to edit_user_url(@user)

    username = "Foo Bar"
    email = "foobar@bar.com"
    patch user_path(@user), params: {
      user: {
        name: username,
        email: email,
        password: '',
        password_confirmation: ''
      }
    }

    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal username, @user.name
    assert_equal email, @user.email
  end
end
