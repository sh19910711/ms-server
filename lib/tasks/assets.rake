namespace :assets do
  task :precompile do
    %x[npm run build]
  end
end
