class CreateResponses < ActiveRecord::Migration[5.0]
	def change
		create_table :responses do |t|
			t.string :message, index: true
			t.string :response

			t.timestamps
		end
	end
end
