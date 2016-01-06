module SimpleList
	module Helper

		module Common
			def javascript_i18n
				@_javascript_i18n ||= Rails.cache.read("javascript_i18n_#{locale}")
				if @_javascript_i18n.blank?
					get_javascript_i18n
					Rails.cache.write("javascript_i18n_#{locale}", @_javascript_i18n)
				end
				@_javascript_i18n
			end

			def get_javascript_i18n
				@_javascript_i18n = (I18n.t!("javascript") rescue {})
			end

			def permission_manage?
				@_permission_manage
			end

		end

		include Common

		def list_columns
			@count = @result.total_entries
			total = @count / @per_page
			total += 1 if @count % @per_page > 0
			{
					page: @page,
					per_page: @per_page,
					model: model_singularize_name,
					rows: @result.map{|record| column_record(record)},
					total: total,
			    caption: @_table_caption,
			    count: @count
			}
		end

		def list_per_page
			per_page = (params[:per_page] || params[:rows] || model_list_config[:per_page] || list_config[:per_page] || 10).to_i
			per_page = 10 if per_page == 0
			per_page
		end

		def column_record(record)
			model_list_config[:list][:columns].inject({}) do |result,(column_name, column_config)|
				if respond_to?("list_column_#{column_name}")
					result[column_name] = self.send("list_column_#{column_name}", record)
				else
					if record.respond_to?(column_name)
						result[column_name] = record.send(column_name)
					else
						result[column_name] = nil
					end
				end
				result
			end
		end

		def model_url
			"/admin/simple_list/#{model_singularize_name.tableize}"
		end

		def model_table_name
			@model_table_name ||= self.class.name.sub('Controller', '').split('::').last.tableize
		end

		def model_singularize_name
			@model_singularize_name ||= model_table_name.singularize
		end

		def model_label
			model_list_config[:label]
		end

		def model_class
			@model_class ||= Object.const_get(model_list_config[:class_name] || model_table_name.classify)
		end

		def list_config
			@list_config ||= SimpleList::Config.config[:default]
		end

		def javascript_tags

		end

		def stylesheet_tags

		end

		def model_list_config
			@model_list_config||= SimpleList::Config.config[:model][model_singularize_name]
		end

		def action_form_fields(action)
			(model_list_config[:form]["#{action}_fields"] || model_list_config[:form][:fields])
		end

		def form_fields(action, disabled = false)
			action_form_fields(action).map do |field, config|
				config = config.clone
				config[:code] = [model_singularize_name, field].join('_')
				config[:code] = "#{model_singularize_name}[#{field}]"
				if config[:value]
					config[:value] = ERB.new(config[:value].to_s).result(binding) rescue nil
				else
					config[:value] = @model.send(field) rescue nil
				end
				if [:radio, :checkbox, :choose, :multiple_choose].include?(config[:type].to_sym)
					config[:collection] ||= @model.class.send(config[:collection_method] || "#{field}_collection")
				end

				config[:disabled] = disabled
				config
			end
		end

		def model_fields
			@model_fields = model_list_config[:form][:fields].keys
		end

		def model_columns
			@model_columns = model_list_config[:list][:columns].keys
		end

		def format_filter_config
			@_filter_config = model_list_config[:list][:filter] || {}
			@_filter_config[:filterConfig] ||= {}
			@_filter_config[:filterConfig].each do |code, config|
				if config[:type] == 'choose'
					config[:collection] = config[:collection] ||= model_class.send(config[:collection_method] || "#{code}_collection")
				end
			end
		end

		def list_js_options(table_pager_id)
			format_filter_config
			column_names = model_list_config[:list][:columns].map{|_, config| config[:zh_name]}
			options = {
					url: "#{model_url}/list?#{params.to_param}",
					colNames: column_names,
					colModel: model_list_config[:list][:columns].values,
					caption: params[:caption] || @caption || model_list_config[:list][:name],
					pager: table_pager_id,
					searchBtn: true,
					export_btn: false,
					pagerBtns: [ ],
					filter: @_filter_config,
					rowNum: list_per_page
			}
			if can_write?
				options[:pagerBtns] << {
						caption: "新建",
						buttonicon: "icon-folder-open-alt",
						title: "新建",
						id: "new_btn",
						css: 'new_btn'
				}
			end

			unless @_filter_config[:filterConfig].blank?
				options[:pagerBtns] << {
						caption: "搜索",
						buttonicon: "icon-search",
						title: "搜索",
						id: "search-btn",
						css: 'search-btn'
				}
			end

			options[:pagerBtns] << {
					caption: "下载",
					buttonicon: "icon-download-alt",
					title: "下载",
					id: "export-btn",
					css: 'export-btn'
			}

			page_btns(options)

			options
		end

		# 这是一个钩子方法, 用来让资料实现并覆盖该方法
		def page_btns(options)

		end

		def list_column_operate(record)
			links = []
			links << show_btn(record)
			links << edit_btn(record) if can_write?
			links << delete_btn(record) if can_write?
			content_tag :div do
				links.compact.join(' | ').html_safe
			end
		end

		def edit_btn(record)
			link_to list_i18n(:edit), 'javascript:void(0)',
			        {
					        'data-update-btn' => true,
					        'data-title' => "#{list_i18n(:edit)} #{model_label} ( #{record.to_label rescue nil} )",
					        'data-toggle' => 'dialog',
					        'data-url' => "#{model_url}/#{record.id}/edit?#{params.to_param}"
			        }
		end

		def show_btn(record)
			link_to list_i18n(:show), 'javascript:void(0)',
			        {
					        'data-title' => "#{list_i18n(:show)} #{model_label} ( #{record.to_label rescue nil} )",
					        'data-toggle' => 'dialog',
					        'data-url' => "#{model_url}/#{record.id}?#{params.to_param}"
			        }
		end

		def delete_btn(record)
			record_name = record.name rescue nil
			link_to list_i18n(:delete), 'javascript:void(0)',
			        {
					        'data-ace-confirm' => ERB.new(list_i18n(:confirm_delete)).result(binding),
					        'data-type' => 'DELETE',
					        'data-url' => "#{model_url}/#{record.id}?#{params.to_param}"
			        }
		end

		def list_i18n(name)
			I18n.t!("simple_list.#{name}") rescue name.to_s.humanize
		end

		def current_app
			@current_app = list_config[:current_app] || model_singularize_name
		end

	end
end


