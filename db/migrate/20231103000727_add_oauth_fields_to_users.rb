# frozen_string_literal: true

class AddOauthFieldsToUsers < ActiveRecord::Migration[7.0]
  def up
    change_table :users, bulk: true do |t|
      t.change_null :email, true
      t.string :name, null: true
      t.string :oauth_provider, null: true
      t.string :oauth_uid, null: true
    end
  end

  def down
    change_table :users, bulk: true do |t|
      t.change_null :email, false
      t.remove :name
      t.remove :oauth_provider
      t.remove :oauth_uid
    end
  end
end
