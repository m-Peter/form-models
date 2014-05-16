module FormObject
  class Base

    def initialize(root_model=nil)
      @root_model = root_model
    end

    def root_model
      @root_model
    end

    class << self
      def attributes(*attributes, of: nil)
        if of.nil?
          attr_accessor(*attributes)
        else
          attributes.each do |attribute|
            delegate attribute, to: :root_model
            delegate "#{attribute}=", to: :root_model
          end
        end
      end

      alias_method :attribute, :attributes
    end
  end
end