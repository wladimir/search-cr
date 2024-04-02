class Search
  property index : Hash(String, Hash(String, Array(Int32))) # in memory index

  def initialize
    @index = {} of String => Hash(String, Array(Int32))
  end

  def index(file_path : String)
    File.read_lines(file_path).each_with_index do |line, line_number|
      line.split.each do |word|
        word = word.downcase
        @index[word] ||= Hash(String, Array(Int32)).new
        @index[word][file_path] ||= Array(Int32).new
        @index[word][file_path] << line_number + 1
      end
    end
  end

  def lookup(query : String)
    @index[query.downcase]?
  end
end
