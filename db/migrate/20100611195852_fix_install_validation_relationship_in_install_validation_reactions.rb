class FixInstallValidationRelationshipInInstallValidationReactions < ActiveRecord::Migration
  def self.up
	rename_column :install_validation_reactions, :package_test_id, :install_validation_id
  end

  def self.down
	rename_column :install_validation_reactions, :install_validation_id, :package_test_id
  end
end
