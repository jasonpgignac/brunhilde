module ApplicationHelper
  def condition_string(install_validation)
    DESCRIPTION_FOR_RULE_TYPE[install_validation.rule_type] + " " + install_validation.rule_parameter
  end
  
  def reaction_string(install_validation_reaction)
    DESCRIPTION_FOR_COMMAND_TYPE[install_validation_reaction.command].sub(/\%p/, install_validation_reaction.parameter) + " " + install_validation_reaction.parameter
  end

  def reaction_select_string(install_validation_reaction)
    DESCRIPTION_FOR_COMMAND_TYPE[install_validation_reaction.command].sub(/\%p/, "<i>value</i>")
  end
  
  def reaction_configuration_form(install_validation_reaction)
    DESCRIPTION_FOR_COMMAND_TYPE[install_validation_reaction.command].sub(/\%p/, f.text_field(install_validation_reaction, :parameter))
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    content_tag(:a, name, {
      :href         => "#",
      :class        => "add_new_subrow",
      :association  => association,
      :content      => fields.gsub(/[&"><]/) { |special| ERB::Util::HTML_ESCAPE[special] }.html_safe
    });
  end
end
