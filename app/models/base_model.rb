# frozen_string_literal: true

class BaseModel
  def initialize(attributes)
    @attributes = attributes
  end

  def respond_to_missing?(name, include_private = false)
    _is_setter, attribute_name = analyze_attribute_name(name)

    @attributes.key?(attribute_name) || super
  end

  # All models are tableless so whenever we get API response from Githib service we need to convert json to an object
  # For example: lets say API response we get for repos looks like
  # { id: 1, name: 'rails', full_name: 'rails/rails' } then it will convert to
  # repository = #<Repository:0x0000ffff890f5788 @attributes={"id"=>1, "name"=>'rails', "full_name"=>'rails/rails'}>
  # now it's like instance object so we can access attributes of the repository like
  # repository.id = 1
  # Now RepositorySerializer able to serialize the repository
  def method_missing(name, *args, &)
    is_setter, attribute_name = analyze_attribute_name(name)

    return super unless @attributes.key?(attribute_name)

    if is_setter
      self.class.define_method(:"#{attribute_name}=") { |val| @attributes[attribute_name] = val }
      @attributes[attribute_name] = args[0]
    else
      self.class.define_method(name) { @attributes[attribute_name] }
      @attributes[attribute_name]
    end
  end

  private

  def analyze_attribute_name(name)
    is_setter = name.to_s.end_with?('=')
    attribute_name = is_setter ? name.to_s[..-2] : name.to_s

    [is_setter, attribute_name]
  end
end
