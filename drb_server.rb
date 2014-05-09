#!/usr/bin/env ruby

require 'drb/drb'
require 'net/ssh'

drb_uri = 'drbunix:///tmp/test_rsync_net-ssh'

Net::SSH.start('dev-stage1.buero.former03.de', 'root') do |ssh|
  DRb.start_service(drb_uri, ssh)
  DRb.thread.join
end

