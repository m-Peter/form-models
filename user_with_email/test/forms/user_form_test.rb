require 'test_helper'

class UserFormTest < ActiveSupport::TestCase
  

  def setup
    @user = User.new
    @user_form = UserForm.new(@user)
  end

  test "should contain the object it represents" do
    assert_equal @user, @user_form.model
  end

  test "should contain the attributes of the object" do
    attributes = [:name, :name=, :age, :age=, :gender, :gender=]

    attributes.each do |attribute|
      assert_respond_to @user_form, attribute
    end
  end

  test "should delegates the attributes to the object" do
    @user_form.name = "Petrakos"
    @user_form.age = 23
    @user_form.gender = 0

    assert_equal @user_form.name, @user.name
    assert_equal @user_form.age, @user.age
    assert_equal @user_form.gender, @user.gender
  end

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
      assert_match /<input name="commit" type="submit" value="Create User" \/>/, output_buffer
    end
  end
end