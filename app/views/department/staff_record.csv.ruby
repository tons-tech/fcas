require 'csv'

puts @records
CSV.generate do |csv|
  csv_column_names = %w(Date StartTime ExitTime)
  csv << csv_column_names
  @records.each do |record|
    csv_column_values = [
      record.duty_date,
      record.start_time,
      record.exit_time
    ]
    csv << csv_column_values
  end
end