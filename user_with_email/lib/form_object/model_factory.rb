module FormObject
  class ModelFactory
    attr_reader :attributes, :model, :models

    def initialize(model, attributes)
      @model = model
      @attributes = attributes
      @models = {}
      add_to_models(model, attributes.keys.first.to_sym)
    end

    def populate_model
      populators = [FormObject::Populator::Root.new(root_populator_args)]
      populators.concat(
        create_populators_for(model, attributes.values.first).flatten
      )

      populators.each do |p|
        p.call
      end

      @model
    end

    def save!
      model.save!
    end

    private

    def add_to_models(model, key)
      @models[key] = model
    end

    def contains_association?(key_value)
      key_value[1].is_a?(Hash)
    end

    def attributes_for_macro(attributes, macro)
      case macro
      when :has_one
        [attributes]
      end
    end

    def create_populators_for(model, attributes)
      attributes.each_with_object([]) do |key_value, association_populators|
        # we are seeking a key whose value is a Hash
        # e.g { "email" => { "address" => "petrakos@gmail.com" } }
        next unless contains_association?(key_value)
        key, value = key_value # split the Hash in two parts(key, value)
        # the type of association, e.g :has_one, :has_many
        macro = macro_for_attribute_key(key)
        # attributes of the association, e.g [{ "address" => "petrakos@gmail.com" }]
        associated_attrs = attributes_for_macro(value, macro)

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

          add_to_models(associated_model, assoc_name.to_sym)

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
        if model.new_record?
          model.send("build_#{association_name}")
        else
          model.send("#{association_name}")
        end
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
    
    ATTRIBUTES_KEY_REGEXP = /^(.+)$/

    def find_association_name_in(key)
      ATTRIBUTES_KEY_REGEXP.match(key)[1]
    end

  end
end