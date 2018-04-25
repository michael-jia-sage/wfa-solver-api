class CreateTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :tokens do |t|
      t.string  :token
      t.string  :refresh_token
      t.string  :code
      t.string  :scope
      t.string  :token_type
      t.string  :resource_id
      t.datetime :expires_in
    end
  end
end
