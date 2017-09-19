require 'httparty'
require 'benchmark'

this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'bulk_services_pb'

$iterations = (ARGV[0] || 5).to_i

class IterableData
  def initialize(size)
    @size = size
  end

  def each
    return enum_for(:each) unless block_given?
    @size.times { |i| yield Bm::Data.new(index: i) }
  end
end

puts "GRPC:"
Benchmark.bm do |bm|
  stub = Bm::Bulk::Stub.new('grpc:50051', :this_channel_is_insecure)
  (1..$iterations).each do |i|
    size = 10 ** i
    req = IterableData.new(size)
    bm.report("10^#{i}") do
      stub.load(req.each)
    end
  end
end

puts "\nGrape:"
Benchmark.bm do |bm|
  (1..$iterations).each do |i|
    size = 10 ** i
    data = size.times.map { |d| { index: d } }
    bm.report("10^#{i}") do
      HTTParty.post('http://grape:9292/load', body: { data: data })
    end
  end
end

