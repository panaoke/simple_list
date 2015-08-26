module SimpleList
  class Engine < ::Rails::Engine
    isolate_namespace SimpleList

    initializer 'SimpleList precompile hook', group: :all do |app|
      app.config.assets.precompile += %w(
        simple_list/applcation.js
				simple_list/simple_list_form.js
        simple_list/application.css
        simple_list/login.css
      )

      app.config.i18n.load_path += Dir[File.join(SimpleList.root, 'config', 'locales',"**", '*.{rb,yml}')]
    end

    ActionView::Base.send :include, ::SimpleList::Helper::Common
  end
end
