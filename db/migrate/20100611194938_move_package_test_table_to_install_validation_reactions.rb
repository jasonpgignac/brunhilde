class MovePackageTestTableToInstallValidationReactions < ActiveRecord::Migration
  def self.up
	rename_table :package_test_reactions, :install_validation_reactions
  end

  def self.down
	rename_table :install_validation_reactions, :package_test_reactions
  end
end
