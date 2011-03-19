module CrudSearches

  def self.included(base)
    class << base
      attr_reader :crud_model_class, :crud_order_scope

      private

      attr_writer :crud_model_class, :crud_order_scope
    end

    base.extend(ClassMethods)

  end

  def ordered_results
    if @search.blank?
      self.class.crud_model_class.send(self.class.crud_order_scope).paginate(:page => params[:page])
    else
      self.class.crud_model_class.filtered(@search).send(self.class.crud_order_scope).paginate(:page => params[:page])
    end
  end

  module ClassMethods

    def crud_model(model)
      self.crud_model_class = model
    end

    def order_scope(scope)
      self.crud_order_scope = scope
    end

  end

end