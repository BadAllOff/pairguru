require "rails_helper"

describe "Movies requests", type: :request do
  describe "movies list" do
    it "displays right title" do
      visit "/movies"
      expect(page).to have_selector("h1", text: "Movies")
    end
  end

  describe "Authenticated user" do
    context "creates new comment" do
      before do
        FactoryGirl.create(:movie)
        user = FactoryGirl.create(:user)
        user.confirmed_at = Time.zone.now
        user.save

        login_as(user, scope: :user)
      end
      it "has comment form" do
        visit "/movies/1"
        expect(page).to have_selector :css, "form.new_comment"
      end

      it "has comments list" do
        visit "/movies/1"
        expect(page).to have_selector("h3", text: "Comments")
      end

      it "comment can't be blank" do
        visit "/movies/1"
        click_on "Create Comment"

        expect(current_path).to eq "/movies/1"
        expect(page).to have_content "Body can't be blank"
        expect(page).to_not have_content "Your comment was successfully posted."
      end

      it "user can comment each movie only once" do
        visit "/movies/1"
        fill_in "comment_body", with: "This comment is ok"
        click_on "Create Comment"
        fill_in "comment_body", with: "This comment should not be here"
        click_on "Create Comment"

        expect(current_path).to eq "/movies/1"
        expect(page).to have_content "User can't comment the same movie more than once"
        expect(page).to have_content "This comment is ok"
        expect(page).to_not have_content "This comment should not be here"
      end

      it "user can add new comment after deleting previous one" do
        visit "/movies/1"
        fill_in "comment_body", with: "First comment. This comment is ok"
        click_on "Create Comment"

        click_on("Delete")

        fill_in "comment_body", with: "Second comment. This comment also is ok"
        click_on "Create Comment"

        expect(current_path).to eq "/movies/1"
        expect(page).to_not have_content "First comment. This comment is ok"
        expect(page).to have_content "Second comment. This comment also is ok"
        expect(page).to have_content "Your comment was successfully posted."
      end
    end
  end

  describe "Non-Authenticated user" do
    before { FactoryGirl.create(:movie) }

    scenario "- can't see comment form" do
      visit "/movies/1"
      expect(page).to_not have_selector :css, "form.new_comment"
    end
  end
end
