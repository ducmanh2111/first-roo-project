class User < ApplicationRecord
  class << self
    def import(file)
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        binding.pry
        user = find_or_initialize_by(code: row['Code'])
        user.update_attributes!(row.to_hash)
      end
    end

    def open_spreadsheet(file)
      case File.extname(file.original_filename)
      when '.csv' then Roo::Csv.new(file.path, file_warning: :ignore)
      when '.xlsm' then Roo::Excelx.new(file.path, file_warning: :ignote)
      else raise 'Unknown file'
      end
    end
  end
end
