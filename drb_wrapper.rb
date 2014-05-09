#!/usr/bin/env ruby

require 'drb/drb'
require 'io/wait'

drb_uri = 'drbunix:///tmp/test_rsync_net-ssh'

if $stdin.tty?
  $stderr.puts('Please execute only through rsync')
  exit (1)
end

remote_cmd = ARGV[3..-1].join(' ')


DRb.start_service
t = nil
ssh = DRbObject.new_with_uri(drb_uri)
channel_outer=ssh.open_channel do |channel|
  channel.exec(remote_cmd) do |ch, success|
    abort "could not execute command" unless success

    # Start stdin reader
    t = Thread.new do
      begin
        data = $stdin.read_nonblock(4096)
        channel.send_data data
      rescue IO::WaitReadable
        break if $stdin.closed
        break if channel.eof?
        IO.select([$stdin])
        retry
      end
      channel.eof!
    end
    
    # Data readable
    channel.on_data do |c, data|
      $stdout.write(data)
    end

    # Stderr readable
    channel.on_extended_data do |c, type, data|
      $stderr.write(data)
    end

    channel.on_close do |c|
      #puts "channel is closing!"
    end
  end
end
channel_outer.wait
ssh.loop

=begin do |ch2, success|
    # input from remote


$stderr.puts("Execute cmd: #{remote_cmd}")
puts ssh.exec!('uname -a')
channel=ssh.open_channel do |ch, success|
  puts ch
  puts channel
end
    channel.on_data do |ch3, data|
      $stdout.write(data)
    end
    # end from remote
    channel.on_close do
      $stdout.close
    end

    if $stdin.ready?
      channel.send $stdin.read
    end

    if $stdin.eof?
      channel.eof!
    end
=end


