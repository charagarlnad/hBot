require 'socket'
require 'json'

Process.spawn('python3 ytdl_host.py')
sleep(0.5)
@socket = UNIXSocket.new('test.s')
@request_lock = Mutex.new
def self.request_vid(request, args)
  @request_lock.lock
  value =
    if request == :play
      @socket.puts('play ' + args)
      response = @socket.recv(16777216).chomp
      JSON.parse(response)
    elsif request == :search
      @socket.puts('search ' + args)
      videos = []
      8.times do
        response = @socket.recv(16777216).chomp
        videos << JSON.parse(response)
      end
      videos
    elsif request == :download
      @socket.puts('download ' + args)
      response = @socket.recv(16777216).chomp
      true
    elsif request == :kill
      @socket.puts('kill')
      true
    end
  @request_lock.unlock
  value
end

request_vid(:play, 'https://www.youtube.com/watch?v=Qt2LqGo4Eys')
request_vid(:search, 'fuck topkek')
request_vid(:download, 'https://www.youtube.com/watch?v=Qt2LqGo4Eys')
request_vid(:kill, true)
