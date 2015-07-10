module SimpleList
	module Controller

		extend ActiveSupport::Concern
		include Helper
		included do
			if Rails.env == 'development'
				self.send(:before_filter, :refresh_config)
				self.send(:before_filter, :get_javascript_i18n)
			end
			if SimpleList::Config.config[:default][:open_permission_manage]
				self.send(:before_filter, :check_user_ability)
			end
			self.send(:before_filter, :filter_post_params, {only: [:create, :update]})
			self.send(:before_filter, :finder_query_condition, {only: [:list]})
			self.send(:before_filter, :model_table_name, :fetch_header)
			self.send(:before_filter, :find_model, :only => [:edit, :update, :new, :destroy])
			self.send(:helper, AceSkin::AceFormHelper)
			self.send(:helper, Helper)
			self.send(:layout, 'simple_list')
			self.send(:attr_accessor, :_config)

		end

		def index
			render '/admin/simple_list/lists/index'
		end

		def new
			render '/admin/simple_list/lists/new', layout: nil
		end

		def edit
			render '/admin/simple_list/lists/edit', layout: nil
		end

		def show
			render '/admin/simple_list/lists/show', layout: nil
		end

		def create
			@model = model_class.create(params[model_singularize_name].to_hash)
			render json: {
				is_success: true,
				record: @model
      }
		end

		def update
			status = @model.update_attributes(params[model_singularize_name].to_hash)
			render json: {
			   is_success: status,
			   record: @model
			}
		end

		def destroy
			status = @model.destroy
			render json: {
				is_success: status,
				record: @model
			}
		end

		def current_app
			@current_app = list_config[:current_app] || model_singularize_name
		end

		def list
			@result = model_class.by_scopes(@conditions).paginate(@paginate)
			render '/admin/simple_list/lists/list.json.erb', layout: nil
		end

		protected
		def filter_post_params
			params.require(model_singularize_name).permit(model_fields)
		end

		def finder_query_condition
			@conditions = params[model_singularize_name] || {}
			@page = params[:page] || 1
			@per_page = params[:per_page] || model_list_config[:per_page] || list_config[:per_page] || 10
			@paginate = {page: @page, per_page: @per_page}
		end

		def refresh_config
			SimpleList::Config.load
		end

		def find_model
			@model = params[:id].blank? ? model_class.new  : model_class.find(params[:id])
		end

		def fetch_header
			if @_env['HTTP_WITHOUT_LAYOUT'] == 'true'
				@_action_has_layout = false
			end
		end

		def check_user_ability
			@_permission_manage = true
			return redirect_to '/admin' unless can_read?

			action = params[:action].to_sym
			return redirect_to '/admin' if [:new, :edit, :create, :update].include?(action) && !can_write?
		end

	end
end

