class MovePackageTestTableToInstallValidations < ActiveRecord::Migration
  def self.up
	rename_table :package_tests, :install_validations
  end

  def self.down
	rename_table :install_validations, :package_tests
  end
end
