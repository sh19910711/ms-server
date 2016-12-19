require 'rails/generators/named_base'

class ComponentGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  def copy_initializer_file
    template "template.html", "ui/components/#{file_name}.html"
    template "template.scss", "ui/components/#{file_name}.scss"
    template "template.js",   "ui/components/#{file_name}.js"
  end
end
