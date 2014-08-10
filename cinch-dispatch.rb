require 'sinatra'
require 'pry'

#do nothing
get '/' do;end

get '/:server/:channel' do
  server = params[:server]
  channel = params[:channel]
  server.gsub!("-","\.")
  binding.pry
  pid = Process.spawn("cinch-worker.rb --server #{server} --channel #{channel} --output --silent",
                      :out => 'dev/null', :err => 'dev/null')

  Process.detach
end