require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "invalid login" do
    get login_path
    assert_template 'sessions/new'

    post login_path, params: {
      session: {
        email: '',
        password: 'foo'
      }
    }

    assert_template 'sessions/new'
    assert_not flash.empty?

    get root_path
    assert flash.empty?
  end

  test "valid login followed by logout" do
    get login_path

    post login_path, params: {
      session: {
        email: @user.email,
        password: 'password'
      }
    }
    assert is_logged_in?
    # check the right redirect target
    assert_redirected_to @user
    # actually visit the target page
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    # delete here is the HTTP verb delete,
    # as post above is a post method to the login_path
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    # log in to set the cookie
    log_in_as(@user, remember_me: '1')
    # log in again without remember_me
    log_in_as(@user, remember_me: '0')
    # verify that the cookie was deleted
    assert_empty cookies['remember_token']
  end
end
