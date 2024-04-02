require "./args"
require "./search"

args = Args.parse
search = Search.new

# use channels for communication between fibers
file_paths = Channel(String).new
indexing_done = Channel(Nil).new

worker_count = ENV["WORKERS"]?.try(&.to_i) || 4
worker_count.times do
  spawn do
    while file_path = file_paths.receive?
      search.index(file_path)
    end
    indexing_done.send(nil)
  end
end

Dir.each_child(args[:directory_path]) do |entry|
  next unless entry.ends_with?(".txt")
  file_path = File.join(args[:directory_path], entry)
  file_paths.send(file_path) # send file path to workers
end
file_paths.close

worker_count.times { indexing_done.receive } # wait here until all workers are done

results = search.lookup(args[:search_query])

if results
  results.each do |file_path, line_numbers|
    puts "Found '#{args[:search_query]}' in file '#{file_path}' on lines: #{line_numbers.join(", ")}"
  end
else
  puts "No occurrences found for '#{args[:search_query]}'."
end
