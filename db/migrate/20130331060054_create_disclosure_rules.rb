class CreateDisclosureRules < ActiveRecord::Migration
  def change
    create_table :disclosure_rules do |t|
      t.belongs_to :owner
      t.string :notifier_class
      t.string :reactor_class
      t.string :action

      t.timestamps
    end
    add_index :disclosure_rules, :owner_id
  end
end
