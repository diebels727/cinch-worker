#!/usr/bin/ruby

require 'sinatra'
require 'fileutils'
require 'sinatra/json'
require 'pry'

set :bind, '0.0.0.0'

#do nothing
get '/' do;end

get '/:server/:channel' do
  server = params[:server]
  channel = params[:channel]
  server.gsub!("-","\.")

  if !File.exists?("#{server}/##{channel}/lock")
    FileUtils.mkpath("#{server}/##{channel}")
    json_file = File.open("#{server}/##{channel}/json.log",'w')

    pid = Process.spawn("cinch-worker.rb --server #{server} --channel #{channel} --output --silent --log json")
    lockfile = File.open("#{server}/##{channel}/lock",'w')
    lockfile.puts(pid)
    Process.detach(pid)
    json_file.close

    lockfile.close
  end
  json_file = File.read("#{server}/##{channel}/json.log")
  binding.pry 
end


