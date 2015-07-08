module Admin
	module SimpleList
		module ListsHelper

			def model_table_name
				@model_table_name ||= params[:model_class]
			end
		
		end
	end
end

