module ImageFile
  def self.get_board_from_filename(filename)
    if /.+\.(?<board>.+)\.image$/ =~ filename
      return board
    end

    nil
  end
end
