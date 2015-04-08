class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies, id: :uuid do |t|
      t.json    :rates
      1.upto(3) { |i| t.boolean "consumer#{i}_ack", null: false, default: false }

      t.timestamps
    end
  end
end
