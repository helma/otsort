class Table

  def initialize columns
    @matrix = [columns]
  end

  def << row
    @matrix << row.collect{|c| c.class == Float ? c.round(3) : c }
  end

  def format_string
    format = ""
    @matrix.first.each_index do |i|
      max_size = @matrix.collect{|row| row[i].to_s.length}.max
      format << "%-#{max_size+2}s"
    end
    format
  end

  def print
    format = format_string
    puts @matrix.collect { |row| format % row }.join("\n")
  end

end
