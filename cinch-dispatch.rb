#!/usr/bin/ruby

require 'sinatra'
require 'pry'

#do nothing
get '/' do;end

get '/:server/:channel/unlock' do
  server = params[:server]
  channel = params[:channel]
  server.gsub!("-","\.")
  File.delete("#{server}/#{channel}/lock")
end

get '/:server/:channel' do
  server = params[:server]
  channel = params[:channel]
  server.gsub!("-","\.")
  pid = Process.spawn("cinch-worker.rb --server #{server} --channel #{channel} --output --silent")
  lockfile = File.open("#{server}/#{channel}/lock",'w')
  lockfile.puts(pid)
  Process.detach(pid)
  lockfile.close
end

