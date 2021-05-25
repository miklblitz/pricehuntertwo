require 'spec_helper'

feature 'Visit Main page' do
  scenario 'with valid email and password' do
    visit '/'

    expect(page).to have_content('Вход')
    expect(page).to have_content('Регистрация')
    expect(page).to have_xpath("//input[@name='query']")
    expect(page).to have_xpath("//input[@name='commit']")
  end

  scenario 'when does not find goods' do
    allow_any_instance_of(Onliner::Proxy).to receive(:catalog_search_products).with({"page"=>1, "query"=>nil}).and_return({body: []})
    allow_any_instance_of(Onliner::Proxy).to receive(:catalog_search_products).with({"page"=>1, "query"=>"dededededed"}).and_return({body: []})
    visit '/'

    fill_in "query", :with => 'dededededed'
    click_button "commit"

    expect(page).to have_content('Вход')
    expect(page).to have_content 'Результат поиска: "dededededed"'
    expect(page).to have_content 'Список поиска пуст'
  end

  scenario 'when finds goods' do
    allow_any_instance_of(Onliner::Proxy).to receive(:catalog_search_products).with({"page"=>1, "query"=>nil}).and_return({body: []})
    data = JSON.parse(file_fixture("catalog_search_products.json").read)
    response = { body: data, status: "success" }
    allow_any_instance_of(Onliner::Proxy).to receive(:catalog_search_products).with(
        { "page" => 1,
          "query" => "бензопила" }
    ).and_return(response.as_json)

    visit '/'

    fill_in "query", :with => 'бензопила'
    click_button "commit"

    expect(page).to have_content('Вход')
    expect(page).to have_content 'Результат поиска: "бензопила"'
    expect(page).not_to have_content 'Список поиска пуст'
    expect(page).to have_css("div.found_goods")
    expect(page).to have_css("//a.good_link", :minimum => 2)
  end


  scenario 'add to favorite' do

    allow_any_instance_of(Onliner::Proxy).to receive(:catalog_search_products).with({"page"=>1, "query"=>nil}).and_return({body: []})
    data = JSON.parse(file_fixture("catalog_search_products.json").read)
    response = { body: data, status: "success" }
    allow_any_instance_of(Onliner::Proxy).to receive(:catalog_search_products).with(
        { "page" => 1,
          "query" => "бензопила" }
    ).and_return(response.as_json)

    visit '/users/sign_up'
    within('#new_user') do
      fill_in 'user[email]', with: 'miklblitz@yandex.ru'
      fill_in 'user[password]', with: '111111'
      fill_in 'user[password_confirmation]', with: '111111'
      click_button 'Сохранить'
    end

    visit '/'

    fill_in "query", :with => 'бензопила'
    click_button "commit"
    expect(page).to have_field('add_favorite_powermaxxbsbasic', checked: false)
    # or ...
    # expect(page).to have_unchecked_field('add_favorite_powermaxxbsbasic')
    find(:css, "#add_favorite_powermaxxbsbasic").set(true)
    expect(page).to have_checked_field('add_favorite_powermaxxbsbasic')

    # не отрабатывает ?
    save_page

    visit '/'
    fill_in "query", :with => 'бензопила'
    click_button "commit"
  end

end