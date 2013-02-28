#!/usr/bin/env python

# ***** BEGIN LICENSE BLOCK *****
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
# ***** END LICENSE BLOCK *****

# This is a quick manual signing script. It is not intended for production use.
# Uses https://github.com/mozilla/signing-clients/ as sc.py
# Mimics code from https://github.com/mozilla/zamboni/blob/master/lib/crypto/packaged.py
# It _needs_ connectivity to a signing service running trunion (https://github.com/mozilla/trunion/)
# kang@mozilla.com

from sc import JarExtractor
import requests
import json
from base64 import b64decode
import sys

OMIT_SIG_SECTIONS=True #Defaults to true in Zamboni as well, at time of writing

if len(sys.argv) != 4:
		print("USAGE: "+sys.argv[0]+" <unsigned.zip> <signed.zip> <URL>")
		print("Example: "+sys.argv[0]+" test.zip test-signed.zip http://localhost:10000/1.0/sign_app")
		sys.exit(1)

in_zip = sys.argv[1]
out_zip = sys.argv[2]
url = sys.argv[3]

jar = JarExtractor(open(in_zip,'r'), open(out_zip, 'w'), omit_signature_sections=OMIT_SIG_SECTIONS)
sig = b64decode(json.loads(requests.post(url,files={'file': ('zigbert.sf', str(jar.signatures))}).content)['zigbert.rsa'])

# If you just want the signature:
# fd = open('zigbert.rsa')
# fd.write(sig)
# fd.close()

jar.make_signed(sig)
