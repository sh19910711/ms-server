namespace :ui do
  task :compile do
    %x[npm run build]
  end
end
