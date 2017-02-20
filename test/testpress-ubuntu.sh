#/bin/sh

echo doorbell-button-press | nc -u 192.168.0.255 4950 -q 1
