require 'grpc'
require 'logger'

this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'bulk_services_pb'

module RubyLogger
  def logger
    LOGGER
  end

  LOGGER = Logger.new(STDERR)
end

module GRPC
  extend RubyLogger
end

class BulkServer < Bm::Bulk::Service
  def load(call)
    indices = call.each_remote_read.map { |d| d['index'] }
    Bm::Response.new(indices: indices)
  end
end

def main
  s = GRPC::RpcServer.new
  s.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
  s.handle(BulkServer)
  s.run_till_terminated
end

main
