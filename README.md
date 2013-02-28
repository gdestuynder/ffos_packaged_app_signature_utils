ffos_packaged_app_signature_utils
=================================

Utils to sign and verify signatures from packaged apps for Firefox OS

RESOURCES
---------
Trunion: https://github.com/mozilla/trunion/
Signing clients: https://github.com/mozilla/signing-clients/
Zamboni: https://github.com/mozilla/zamboni/

EXAMPLE
-------

  $ ./sign.py unsigned.zip signed.zip http://localhost:10000/1.0/sign\_app
  $ ./verify.sh signed.zip root\_ca.pem

sign.py
-------

sign.py is a python script which attempts to sign a packaged app with a Trunion signing server.
It uses signing clients (as sc.py) to parse the packaged app format.
It attempts to mimic Zamboni for the actual signing requests (https://github.com/mozilla/zamboni/blob/master/lib/crypto/packaged.py)
Do not use for production apps.

verify.sh
---------

verify.sh is a bash script which uses NSS utilities to manually verify a signed packaged app (such as one obtained with sign.py) against a public certificate.
