class ChangePrescriptFieldToDeploymentStage < ActiveRecord::Migration
  def self.up
    remove_column :packages, :prescript
    add_column :packages, :deployment_stage, :integer
  end

  def self.down
    add_column :packages, :prescript, :boolean
    remove_column :packages, :deployment_stage
  end
end
