module ApplicationHelper
  def condition_string(install_validation)
    DESCRIPTION_FOR_RULE_TYPE[install_validation.rule_type] + " " + install_validation.rule_parameter
  end
  
  def reaction_string(install_validation_reaction)
    DESCRIPTION_FOR_COMMAND_TYPE[install_validation_reaction.command].sub(/\%p/, install_validation_reaction.parameter)
  end

end
