require 'test_helper'

class UserFormRenderingTest < ActionView::TestCase
  def form_for(*)
    @output_buffer = super
  end

  test "form_for renders correctly with instance of UserForm" do
    user = User.new
    user_form = UserForm.new(user)

    form_for user_form do |f|
      concat f.label(:name)
      concat f.text_field(:name)
      concat f.label(:age)
      concat f.number_field(:age)
      concat f.label(:gender)
      concat f.select(:gender, User.get_genders_dropdown)
      concat f.label(:address)
      concat f.text_field(:address)
      concat f.submit('Create User')
    end

    assert_match /action="\/users"/, output_buffer
    assert_match /class="new_user"/, output_buffer
    assert_match /id="new_user"/, output_buffer
    assert_match /method="post"/, output_buffer
    assert_match /<label for="user_name">Name<\/label>/, output_buffer
    assert_match /<input id="user_name" name="user\[name\]" type="text" \/>/, output_buffer
    assert_match /<label for="user_age">Age<\/label>/, output_buffer
    assert_match /<input id="user_age" name="user\[age\]" type="number" \/>/, output_buffer
    assert_match /<label for="user_gender">Gender<\/label>/, output_buffer
    assert_match /<select id="user_gender" name="user\[gender\]">/, output_buffer
    assert_match /<option value="0">Male<\/option>/, output_buffer
    assert_match /<option value="1">Female<\/option>/, output_buffer
    assert_match /<\/select>/, output_buffer
    assert_match /<label for="user_address">Address<\/label>/, output_buffer
    assert_match /<input id="user_address" name="user\[address\]" type="text" \/>/, output_buffer
    assert_match /<input name="commit" type="submit" value="Create User" \/>/, output_buffer
  end

  test "form_for renders the values of persisted model" do
    user = User.new(name: "Petrakos", age: 23, gender: 0)
    user.email = Email.new(address: "petrakos@gmail.com")
    user.save!
    user_form = UserForm.new(user)

    form_for user_form do |f|
      concat f.label(:name)
      concat f.text_field(:name)
      concat f.label(:age)
      concat f.number_field(:age)
      concat f.label(:gender)
      concat f.select(:gender, User.get_genders_dropdown)
      concat f.label(:address)
      concat f.text_field(:address)
      concat f.submit('Update User')
    end

    id = user.id

    assert_match /action="\/users\/#{id}"/, output_buffer
    assert_match /class="edit_user"/, output_buffer
    assert_match /id="edit_user_#{id}"/, output_buffer
    assert_match /method="post"/, output_buffer
    assert_match /<input name="_method" type="hidden" value="patch"/, output_buffer
    assert_match /<input id="user_name" name="user\[name\]" type="text" value="#{user.name}" \/>/, output_buffer
    assert_match /<input id="user_age" name="user\[age\]" type="number" value="#{user.age}" \/>/, output_buffer
    assert_match /<option selected="selected" value="0">Male<\/option>/, output_buffer
    assert_match /<input id="user_address" name="user\[address\]" type="text" value="#{user.email.address}"/, output_buffer
    assert_match /<input name="commit" type="submit" value="Update User" \/>/, output_buffer
  end
end