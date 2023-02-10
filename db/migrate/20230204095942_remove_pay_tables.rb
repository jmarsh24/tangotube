# frozen_string_literal: true

class RemovePayTables < ActiveRecord::Migration[7.0]
  def change
    drop_table :pay_charges, force: :cascade
    drop_table :pay_customers, force: :cascade
    drop_table :pay_merchants, force: :cascade
    drop_table :pay_payment_methods, force: :cascade
    drop_table :pay_subscriptions, force: :cascade
    drop_table :pay_webhooks, force: :cascade
  end
end
