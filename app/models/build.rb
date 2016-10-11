class Build < ApplicationRecord
  belongs_to :app
  mount_uploader :source_file, SourceFileUploader
end
