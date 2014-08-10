#!/usr/bin/ruby

require 'sinatra'
require 'fileutils'
require 'pry'

set :bind, '0.0.0.0'

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
    FileUtils.mkpath("#{server}/##{channel}")
    show = File.open("#{server}/##{channel}/show.log",'w')
    show.puts "Initializing ..."

    pid = Process.spawn("cinch-worker.rb --server #{server} --channel #{channel} --output --silent --log show")
    lockfile = File.open("#{server}/##{channel}/lock",'w')
    lockfile.puts(pid)
    Process.detach(pid)

    show.puts "Waiting for chatter ..."
    show.close

    lockfile.close
  end
  show = File.read("#{server}/##{channel}/show.log")
  show.gsub!(/\n/, '<br>')
  "<html>
    <body>
      <h1>#{server}/##{channel}</h1>
      #{show}
    </body>
  </html>"
end


