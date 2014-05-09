# rsync via ruby's net/ssh
## usage

* configure dest host in `drb_server.rb`
* run rsync `rsync -e './drb_wrapper.rb' -av root@dev-stage1:/tmp/ /tmp/test_dev1_root`

## state

WiP

## links

* [man rsync](http://manpages.ubuntu.com/manpages/trusty/man1/rsync.1.html)
* [net/ssh](http://net-ssh.github.io/net-ssh/)
* [Drb](http://www.ruby-doc.org/stdlib-2.1.1/libdoc/drb/rdoc/DRb.html)
