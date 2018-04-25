class CreateTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :tokens do |t|
      t.string  :token
      t.string  :refresh_token
      t.string  :code
      t.datetime :expires_in
    end
  end
end
