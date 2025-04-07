require "application_system_test_case"

class ImagesTest < ApplicationSystemTestCase
  setup do
    @image = images(:one)
  end

  test "visiting the index" do
    visit images_url
    assert_selector "h1", text: "Images"
  end

  test "should create image" do
    visit images_url
    click_on "New image"

    fill_in "Name", with: @image.name
    click_on "Create Image"

    assert_text "Image was successfully created"
  end

  test "should update Image" do
    visit image_url(@image)
    click_on "Edit", match: :first

    fill_in "Name", with: @image.name
    click_on "Update Image"

    assert_text "Image was successfully updated"
  end

  # test "should remove Image" do
  #   visit image_url(@image)
  #   click_on "Remove", match: :first
  #
  #   assert_text "Image was successfully removed"
  # end
end
