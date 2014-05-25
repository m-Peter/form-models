module FormObject
  class ModelFactory
    attr_reader :attributes, :model

    def initialize(attributes)
      @attributes = attributes
    end

    def populate_model
      @model = create_root_model

      @populators = [FormObject::Populator::Root.new(root_populator_args)]
      @populators.concat(
        create_populators_for(model, attributes.values.first).flatten
      )

      @populators.each do |p|
        p.call
      end

      @model
    end

    def create_populators_for(model, attributes)
      attributes.each_with_object([]) do |key_value, association_populators|
        # we are seeking a key whose values is a Hash
        # e.g { "email_attributes" => { "address" => "petrakos@gmail.com" } }
        next unless key_value[1].is_a?(Hash)
        key, value = key_value # split the value in two parts
        # the type of association(has_one for the above example), e.g has_one, has_many
        macro = macro_for_attribute_key(key)
        # attributes of the association e.g [{ "address" => "petrakos@gmail.com" }]
        associated_attrs = 
          case macro
          when :has_one
            [value]
          end

        associated_attrs.inject(association_populators) do |populators, record_attrs|
          # the name of the association, e.g email
          assoc_name = find_association_name_in(key)
          # attributes that belong to assoc_name, e.g { "address" => "petrakos@gmail.com" }
          current_scope_attrs = params_for_current_scope(record_attrs)

          # this is the resulting associated model
          associated_model = initialize_associated_model(
            current_scope_attrs,
            :for_association_name => assoc_name,
            :on_model => model,
            :with_macro => macro,
          )

          # populator for the nested models, e.g HasOne for email
          populator_class = "FormObject::Populator::#{macro.to_s.camelize}".constantize

          # args for the above populator class
          populator_args = {
            model: associated_model,
            association_name: assoc_name,
            attrs: current_scope_attrs,
            parent: model
          }

          # append the new populator
          populators << populator_class.new(populator_args)
          # continue recursively with nested models, if any
          populators.concat(create_populators_for(associated_model, record_attrs))
        end
      end
    end

    def root_populator_args
      ActiveSupport::HashWithIndifferentAccess.new(
        model: model,
        attrs: params_for_current_scope(attributes.values.first),
        association_name: attributes.keys.first
      )
    end

    def initialize_associated_model(attrs, args={})
      association_name, model, macro = args.values_at(:for_association_name, :on_model, :with_macro)
      
      case macro
      when :has_one
        model.send("build_#{association_name}")
      end
    end

    def params_for_current_scope(attrs)
      attrs.dup.reject { |_, v| v.is_a?(Hash) }
    end

    def macro_for_attribute_key(key)
      association_name = find_association_name_in(key).to_sym
      association_reflection = model.class.reflect_on_association(association_name)
      association_reflection.macro
    end

    ATTRIBUTES_KEY_REGEXP = /^(.+)_attributes$/

    def find_association_name_in(key)
      ATTRIBUTES_KEY_REGEXP.match(key)[1]
    end

    def create_root_model
      model_class = attributes.keys.first.to_s.camelize.constantize
      model_class.new
    end
  end
end