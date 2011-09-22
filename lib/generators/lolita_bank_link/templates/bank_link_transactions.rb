class CreateLolitaBankLinkTransactions < ActiveRecord::Migration
  def self.up
    create_table :bank_link_transactions do |t|
      t.string :status, :default => "processing"
      t.references :paymentable, :polymorphic => true
      t.string :ip, :length => 10

      t.timestamps
    end

    add_index :bank_link_transactions, [:paymentable_type,:paymentable_id], :name => "bl_trx_paymentable_type_paymentable_id"
  end

  def self.down
    drop_table :bank_link_transactions
  end
end
