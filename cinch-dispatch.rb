#!/usr/bin/ruby

require 'sinatra'
require 'fileutils'
require 'pry'

#do nothing
get '/' do;end

# get '/:server/:channel/unlock' do
#   server = params[:server]
#   channel = params[:channel]
#   server.gsub!("-","\.")
#   File.delete("#{server}/#{channel}/lock")
# end
#
# get '/:server/:channel/status' do
#   if File.exists?("#{server}/##{channel}/lock")
#     lockfile = File.open("#{server}/##{channel}/lock",'r')
#     binding.pry
#     process = `ps -p 2378 | grep -v PID`
#   end
# end
#
# get '/:server/:channel/reset' do
#
# end

get '/:server/:channel' do
  server = params[:server]
  channel = params[:channel]
  server.gsub!("-","\.")
  if !File.exists?("#{server}/##{channel}/lock")
    pid = Process.spawn("cinch-worker.rb --server #{server} --channel #{channel} --output --silent --log show")
    FileUtils.mkpath("#{server}/##{channel}")
    lockfile = File.open("#{server}/##{channel}/lock",'w')
    lockfile.puts(pid)
    Process.detach(pid)
    lockfile.close
  end
end


