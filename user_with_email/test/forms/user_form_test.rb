require 'test_helper'

class UserFormTest < ActiveSupport::TestCase
  

  def setup
    @user = User.new
    @email = Email.new
    @user_form = UserForm.new(@user, @email)
  end

  test "should contain the object it represents" do
    assert_equal @user, @user_form.user
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

  test "should submit params" do
    params = { name: 'Petrakos', age: 23, gender: 0 }
    @user_form.submit(params)

    assert_equal @user_form.name, params[:name]
    assert_equal @user_form.age, params[:age]
    assert_equal @user_form.gender, params[:gender]
  end

  test "submit should return true if the params are valid" do
    params = { name: 'Petrakos', age: 23, gender: 0, address: "petrakos@gmail.com" }
    result = @user_form.submit(params)

    assert result
  end

  test "submit should return false for invalid params" do
    params = { name: 'Petr', age: "12", gender: "male" }
    result = @user_form.submit(params)

    assert_not result
    assert_includes @user.errors.messages[:name], "is too short (minimum is 6 characters)"
  end

  test "should save the model" do
    params = { name: 'Petrakos', age: 23, gender: 0 }
    @user_form.submit(params)

    assert_difference('User.count') do
      @user_form.save
    end
  end

  test "should update the model" do
    user = User.create!(name: 'Petrakos', age: 23, gender: 0)
    email = Email.create!(address: 'petrakos@gmail.com')
    user_form = UserForm.new(user, email)

    user_form.submit({name: "Petros"})

    assert_difference('User.count', 0) do
      user_form.save
    end

    assert_equal "Petros", user_form.name
  end

  test "should accept the nested model" do
    assert_equal @user, @user_form.user
    assert_equal @email, @user_form.email
  end

  test "should delegate attributes to the nested model" do
    @user_form.address = "markoupetr@gmail.com"

    assert_equal @email.address, @user_form.address
  end

  test "should submits parameters for both models" do
    params = { name: 'Petrakos', age: 23, gender: 0, address: 'markoupetr@gmail.com' }
    @user_form.submit(params)

    assert_equal 'markoupetr@gmail.com', @user_form.address
  end

  test "should detect invalid params on nested model" do
    params = { name: 'Petrakos', age: 23, gender: 0, address: 'markoupetr' }
    result = @user_form.submit(params)

    assert_not result
    assert_includes @user_form.errors.messages[:address], "is invalid"
  end

  test "should save both models" do
    params = { name: 'Petrakos', age: 23, gender: 0, address: "petrakos@gmail.com" }
    @user_form.submit(params)

    assert_difference('User.count') do
      @user_form.save
    end

    assert @user_form.persisted?
    assert @user.persisted?
    assert @email.persisted?
    assert_equal @email, @user.email
  end

  class UserFormRenderingTest < ActionView::TestCase
    def form_for(*)
      @output_buffer = super
    end

    test "form_for renders correctly with instance of UserForm" do
      user = User.new
      user_form = UserForm.new(user, Email.new)

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
      user = User.create!(name: "Petrakos", age: 23, gender: 0)
      user_form = UserForm.new(user, Email.new)

      form_for user_form do |f|
        concat f.label(:name)
        concat f.text_field(:name)
        concat f.label(:age)
        concat f.number_field(:age)
        concat f.label(:gender)
        concat f.select(:gender, User.get_genders_dropdown)
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
      assert_match /<input name="commit" type="submit" value="Update User" \/>/, output_buffer
    end
  end
end