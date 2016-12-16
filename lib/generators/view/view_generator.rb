class ViewGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  def copy_initializer_file
    template "template.html", "ui/views/#{file_name}.html"
    template "template.scss", "ui/views/#{file_name}.scss"
    template "template.js",   "ui/views/#{file_name}.js"
  end
end
