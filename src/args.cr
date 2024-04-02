require "option_parser"

module Args
  def self.parse
    search_query = ""
    directory_path = "./input"

    OptionParser.parse do |parser|
      parser.banner = "Usage: search.cr [arguments]"

      parser.on("-q QUERY", "--query QUERY", "Search query") { |query| search_query = query.strip }

      parser.on("-d DIRECTORY", "--directory DIRECTORY", "Directory path") { |directory| directory_path = directory.strip }

      parser.on("-h", "--help", "Show this help") do
        puts parser
        exit
      end

      parser.invalid_option do |flag|
        STDERR.puts "ERROR: #{flag} is not a valid option."
        STDERR.puts parser
        exit(1)
      end
    end

    if search_query.empty?
      puts "Please provide a search query"
      exit
    end

    {search_query: search_query, directory_path: directory_path}
  end
end
