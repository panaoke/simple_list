module Admin
	module SimpleList
		class ListsController < Admin::ApplicationController
			include ::SimpleList::Controller
			include ListsHelper
			helper ListsHelper


		end
	end
end

