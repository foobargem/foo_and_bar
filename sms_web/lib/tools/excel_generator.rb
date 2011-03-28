# encoding: utf-8
module Tools
  class ExcelGenerator

    attr_reader :output_file_path

    def initialize(filename_prefix)
      tmpfile = Tempfile.new(filename_prefix)
      @output_file_path = tmpfile.path

      @header_format = Spreadsheet::Format.new(:align => :center, :color => :gray)
      @content_format = Spreadsheet::Format.new(:align => :center)
    end

    def export_to_xls(sheet_datas)
      doc = Spreadsheet::Workbook.new

      sheet_datas.each do |data|
        sheet = doc.create_worksheet
        sheet.name = data[:sheet_name]

        write_data_to_sheet(sheet, data[:collection], data[:columns], data[:assocs])
      end

      doc.write(@output_file_path)
    end


    protected

      def write_data_to_sheet(sheet, collection, columns, assocs)
        row_index = 0
        sheet.row(row_index).replace(columns.map{|hs| hs.values.first })
        sheet.row(row_index).default_format = @header_format

        row_index += 1

        collection.each do |row|
        
          values = []
          columns.map{|hs| hs.keys.first }.each do |c|

            value = if assocs.has_key?(c)
                      assoc = assocs[c]
                      row.send(assoc[0])[(assoc[1])]
                    else
                      row[c]
                    end

            values << value
          end

          sheet.row(row_index).replace(values)
          sheet.row(row_index).default_format = @content_format

          row_index += 1
        end
      end

  end
end
