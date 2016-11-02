module Fixture
  def self.filepath(path)
    File.join('spec/fixtures', path)
  end

  def self.uploaded_file(path)
    Rack::Test::UploadedFile.new(filepath(path))
  end
end
