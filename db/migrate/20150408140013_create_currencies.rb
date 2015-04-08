class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies, id: :uuid do |t|
      t.json    :rates
      t.boolean :consumer1_ack, default: false
      t.boolean :consumer2_ack, default: false
      t.boolean :consumer3_ack, default: false

      t.timestamps
    end
  end
end
