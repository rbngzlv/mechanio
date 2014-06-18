class AddSearchTermsToJobs < ActiveRecord::Migration
  def up
    add_column :jobs, :search_terms, :string

    Job.all.each do |j|
      j.set_search_terms
      j.save
    end
  end

  def down
    remove_column :jobs, :search_terms
  end
end
