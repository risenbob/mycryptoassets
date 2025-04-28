require 'rails_helper'

RSpec.feature "User adds a crypto asset", type: :feature do
  let(:user) { create(:user) }

  scenario "User is not logged in" do
    visit root_path

    expect(page).to have_current_path(new_user_session_path)
  end

  scenario "User is logged in" do
    curr = create(:crypto_currency, name: "Bitcoin")
    price = create(:crypto_price, crypto_currency: curr)

    curr.update(crypto_price: price)

    login_as(user, scope: :user)

    visit root_path

    click_link "Add crypto asset"

    expect(page).to have_current_path(new_crypto_asset_path)
    select "Bitcoin", from: "Crypto currency"
    fill_in "crypto_asset[quantity]", with: "0.2"

    click_button "Submit"

    expect(page).to have_current_path(root_path)
    expect(page).to have_content("Bitcoin")
    expect(page).to have_content("0.2")
    expect(page).to have_content("Your common balance: 8000.0")
  end
end
