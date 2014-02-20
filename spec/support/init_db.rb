# Add models
ActiveRecord::Schema.define do
  create_table :bank_link_transactions do |t|
    t.string :status, default: "processing"
    t.references :paymentable, polymorphic: true
    t.string :ip, length: 10
    t.string :service
    t.string :version
    t.string :snd_id
    t.string :rec_id
    t.string :stamp
    t.string :t_no
    t.string :amount
    t.string :curr
    t.string :rec_acc
    t.string :rec_name
    t.string :snd_acc
    t.string :snd_name
    t.string :ref
    t.string :msg
    t.string :t_date

    t.timestamps
  end

  create_table :reservations do |t|
    t.integer :full_price
    t.string :status

    t.timestamps
  end
end
