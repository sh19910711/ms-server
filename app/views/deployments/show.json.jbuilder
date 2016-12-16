json.(@deployment, :major_version, :minor_version, :board, :comment,
      :created_at, :updated_at, :released_at)

json.build do
  json.status @deployment.build.status
  json.log    @deployment.build.log
end
