require 'rails_helper'

feature "Event Config" do
  let(:event) { create(:event, review_tags: ["intro", "advanced"]) }

  let(:organizer_user) { create(:user) }
  let!(:organizer_teammate) { create(:teammate, :organizer, user: organizer_user, event: event) }

  let(:reviewer_user) { create(:user) }
  let!(:reviewer_event_teammate) { create(:teammate, :reviewer, user: reviewer_user, event: event) }

  let(:program_team_user) { create(:user) }
  let!(:program_team_event_teammate) { create(:teammate, :program_team, user: program_team_user, event: event) }

  def document
    page.document
  end

  context "As an organizer", js: true do
    before :each do
      logout
      login_as(organizer_user)
    end

    it "can add a new session format" do
      visit event_staff_config_path(event)
      click_on "Add Session Format"

      within_bs_modal 'New Session Format' do
        fill_in "Name", with: "Best Session"
        click_button "Save"
      end

      expect(find('table#session-formats'))
        .to have_table_row('Name' => 'Best Session')
    end

    it "can edit a session format" do
      session_format = create(:session_format)
      visit event_staff_config_path(event)

      find("tr#session_format_#{session_format.id}").click_on 'Edit'

      within_bs_modal 'Edit Session Format' do
        fill_in "Description", with: "The most exciting session."
        click_button "Save"
      end

      expect(find('table#session-formats'))
        .to have_table_row('Description' => 'The most exciting session.')
    end

    it "can't edit a session format to have no name" do
      session_format = create(:session_format)
      visit event_staff_config_path(event)

      find("tr#session_format_#{session_format.id}").click_on 'Edit'

      within_bs_modal 'Edit Session Format' do
        fill_in "Name", with: ""
        click_button "Save"

        expect(current_scope)
          .to have_css('.errors', text: "Name can't be blank")
      end
    end

    it "can delete a session format" do
      session_format = create(:session_format)
      visit event_staff_config_path(event)
      expect(page).to have_content session_format.name
      expect(page).to have_content session_format.description

      within("#session_format_#{session_format.id}") do
        page.accept_confirm { click_on "Remove" }
      end

      page.reset!

      expect(page).not_to have_content session_format.name
      expect(page).not_to have_content session_format.description
    end

    it "can add a new track" do
      visit event_staff_config_path(event)
      click_on "Add Track"

      within_bs_modal 'New Track' do
        fill_in "Name", with: "Best Track"
        click_button "Save"
      end

      expect(find('table#tracks')).to have_table_row('Name' => 'Best Track')
    end

    it "can't add a track with a description longer than 250 characters" do
      visit event_staff_config_path(event)
      click_on "Add Track"

      within_bs_modal 'New Track' do
        fill_in "Name", with: "Best Session"
        fill_in "Description", with: "A really long description about  Gastropub sartorial narwhal pitchfork hashtag venmo forage gluten-free. Echo messenger bag swag. Lomo humblebrag authentic. Photo booth iphone portland cardigan pitchfork locavore ramps. Pop-up poutine photo booth fingerstache kombucha mumblecore mlkshk."
        click_button "Save"

        expect(current_scope)
          .to have_css(
            '.errors',
            text: 'Description is too long (maximum is 250 characters)'
          )
        expect(document).to have_bs_alert(%{
          There was a problem saving your track,
          Description is too long (maximum is 250 characters)
        }.squish)
      end
    end

    it "can edit a track" do
      track = create(:track, event: event)
      visit event_staff_config_path(event)

      find("tr#track_#{track.id}").click_on 'Edit'

      within_bs_modal 'Edit Track' do
        fill_in "Description", with: "The best track ever."
        click_button "Save"
      end

      expect(find('table#tracks'))
        .to have_table_row('Description' => 'The best track ever.')
    end

    it "can't edit a track to have no name" do
      track = create(:track, event: event)
      visit event_staff_config_path(event)

      find("tr#track_#{track.id}").click_on 'Edit'

      within_bs_modal 'Edit Track' do
        fill_in "Name", with: ""
        click_button "Save"

        expect(current_scope)
          .to have_css('.errors', text: "Name can't be blank")
      end
    end

    it "can't edit description to be longer than 250 characters" do
      track = create(:track, event: event)
      visit event_staff_config_path(event)

      find("#track_#{track.id}").click_on 'Edit'

      within_bs_modal 'Edit Track' do
        fill_in "Description", with: "A really long description about  Gastropub sartorial narwhal pitchfork hashtag venmo forage gluten-free. Echo messenger bag swag. Lomo humblebrag authentic. Photo booth iphone portland cardigan pitchfork locavore ramps. Pop-up poutine photo booth fingerstache kombucha mumblecore mlkshk."
        click_button "Save"

        expect(current_scope)
          .to have_css(
            '.errors',
            text: 'Description is too long (maximum is 250 characters)'
          )
        expect(document).to have_bs_alert(%{
          There was a problem updating your track,
          Description is too long (maximum is 250 characters).
        }.squish)
      end
    end

    it "can delete a track" do
      track = create(:track, event: event)
      visit event_staff_config_path(event)
      expect(page).to have_content track.name
      expect(page).to have_content track.description

      within("#track_#{track.id}") do
        page.accept_confirm { click_on "Remove" }
      end

      page.reset!

      expect(page).not_to have_content track.name
      expect(page).not_to have_content track.description
    end

    it "can edit reviewer tags" do
      visit event_staff_config_path(event)

      within("#show-reviewer-tags") do
        expect(page).to have_content "intro, advanced"
        click_on "Edit"
      end

      fill_in "event[valid_review_tags]", with: "beginner, advanced"
      click_on "Save"

      within("#show-reviewer-tags") do
        expect(page).to have_content "beginner, advanced"
      end
    end

    it "can add and edit proposal tags" do
      visit event_staff_config_path(event)

      within("#show-proposal-tags") do
        expect(page).to have_link "Add"
        click_on "Add"
      end

      fill_in "event[valid_proposal_tags]", with: "okay, good, awesome"
      click_on "Save"

      within("#show-proposal-tags") do
        expect(page).to have_content "okay, good, awesome"
        click_on "Edit"
      end

      fill_in "event[valid_proposal_tags]", with: "stellar"
      click_on "Save"

      within("#show-proposal-tags") do
        expect(page).to have_content "stellar"
      end
    end

    it "can add and edit custom fields" do
      visit event_staff_config_path(event)

      within("#show-custom-fields") do
        expect(page).to have_link "Add"
        click_on "Add"
      end

      fill_in "event[custom_fields_string]", with: "aboveandbeyond"
      click_on "Save"

      within("#show-custom-fields") do
        expect(page).to have_content "aboveandbeyond"
        click_on "Edit"
      end

      fill_in "event[custom_fields_string]", with: "aboveandbeyond, whoa"
      click_on "Save"

      within("#show-custom-fields") do
        expect(page).to have_content "aboveandbeyond, whoa"
      end
    end
  end

  context "As a reviewer", js: true do
    before :each do
      logout
      login_as(reviewer_user)
    end

    it "cannot view link to add new session format" do
      visit event_staff_config_path(event)

      expect(page).to_not have_content("Add Session Format")
    end

    it "cannot view link to edit or remove a session format" do
      session_format = create(:session_format)
      visit event_staff_config_path(event)

      within("#session_format_#{session_format.id}") do
        expect(page).to_not have_content("Edit")
        expect(page).to_not have_content("Remove")
      end
    end

    it "cannot view link to add new track" do
      visit event_staff_config_path(event)

      expect(page).to_not have_content("Add Track")
    end

    it "cannot view link to edit or remove a track" do
      track = create(:track, event: event)
      visit event_staff_config_path(event)

      within("#track_#{track.id}") do
        expect(page).to_not have_content("Edit")
        expect(page).to_not have_content("Remove")
      end
    end

    it "cannot add or edit reviewer tags" do
      visit event_staff_config_path(event)

      within("#show-reviewer-tags") do
        expect(page).to_not have_link("Add")
        expect(page).to_not have_link("Edit")
      end
    end

    it "cannot add or edit proposal tags" do
      visit event_staff_config_path(event)

      within("#show-proposal-tags") do
        expect(page).to_not have_link("Add")
        expect(page).to_not have_link("Edit")
      end
    end

    it "cannot add or edit custom fields" do
      visit event_staff_config_path(event)

      within("#show-custom-fields") do
        expect(page).to_not have_link("Add")
        expect(page).to_not have_link("Edit")
      end
    end
  end

  context "As a program team", js: true do
    before :each do
      logout
      login_as(program_team_user)
    end

    it "cannot view link to add new session format" do
      visit event_staff_config_path(event)

      expect(page).to_not have_content("Add Session Format")
    end

    it "cannot view link to edit or remove a session format" do
      session_format = create(:session_format)
      visit event_staff_config_path(event)

      within("#session_format_#{session_format.id}") do
        expect(page).to_not have_content("Edit")
        expect(page).to_not have_content("Remove")
      end
    end

    it "cannot view link to add new track" do
      visit event_staff_config_path(event)

      expect(page).to_not have_content("Add Track")
    end

    it "cannot view link to edit or remove a track" do
      track = create(:track, event: event)
      visit event_staff_config_path(event)

      within("#track_#{track.id}") do
        expect(page).to_not have_content("Edit")
        expect(page).to_not have_content("Remove")
      end
    end

    it "cannot add or edit reviewer tags" do
      visit event_staff_config_path(event)

      within("#show-reviewer-tags") do
        expect(page).to_not have_link("Add")
        expect(page).to_not have_link("Edit")
      end
    end

    it "cannot add or edit proposal tags" do
      visit event_staff_config_path(event)

      within("#show-proposal-tags") do
        expect(page).to_not have_link("Add")
        expect(page).to_not have_link("Edit")
      end
    end

    it "cannot add or edit custom fields" do
      visit event_staff_config_path(event)

      within("#show-custom-fields") do
        expect(page).to_not have_link("Add")
        expect(page).to_not have_link("Edit")
      end
    end
  end
end

# session formats, tracks, proposal tags, reviewer tags, custom fields
