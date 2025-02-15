require "application_system_test_case"

class UserRegistrationsTest < ApplicationSystemTestCase
  test "admin can assign roles during registration" do
    admin = users(:admin)
    sign_in admin

    visit new_user_registration_path
    fill_in "Email", with: "new_admin@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    select "Admin", from: "Role"
    click_button "Sign up"

    assert User.last.admin?, "Admin should be able to create admin users"
  end

  test "regular user cannot assign role" do
    visit new_user_registration_path
    assert_no_select "Role", text: "Admin"

    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_button "Sign up"

    assert User.last.member?, "Default role should be assigned"
  end

  # test "malicious role assignment attempt is blocked" do
  #   visit new_user_registration_path

  #   # Instead of trying to manipulate a non-existent field, add hidden input
  #   page.execute_script(<<~JS)
  #     const form = document.getElementById('new_user');
  #     const hiddenInput = document.createElement('input');
  #     hiddenInput.type = 'hidden';
  #     hiddenInput.name = 'user[role]';
  #     hiddenInput.value = 'admin';
  #     form.appendChild(hiddenInput);
  #   JS

  #   fill_in "Email", with: "hacker@example.com"
  #   fill_in "Password", with: "password123"
  #   fill_in "Password confirmation", with: "password123"
  #   click_button "Sign up"

  #   assert User.last.member?, "Should fallback to default role"
  #   assert_text "Role assignment not permitted", count: 1
  # end
end
