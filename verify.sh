#!/bin/bash
# ***** BEGIN LICENSE BLOCK *****
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
# ***** END LICENSE BLOCK *****

# Verifies a packaged app signature
# kang@mozilla.com

[[ $# -eq 2 ]] || {
		echo "USAGE: $0 <signed.zip> <certificate.crt>"
		exit 1
}

zip=$1
crt=$2

tmp_zip=$(mktemp -d)
tmp=$(mktemp -d)
certutil="certutil -d $tmp"
cmsutil="cmsutil -d $tmp"
cwd=$(pwd)
ex=0

cp "$zip" $tmp_zip/
cp "$crt" $tmp_zip/

cd $tmp_zip && unzip $(basename "$zip") || {
	echo "Couldn't unzip $tmp_zip/$zip"
	exit 1
}
[[ -d META-INF ]] || {
	echo "Couldn't find directory $tmp_zip/META-INF"
	exit 1
}

echo
echo "Just hit enter twice as password, this database is deleted at the end of the script run."
echo

$certutil -N
$certutil -A -n root-cert -t ",,C" -i $(basename "$crt")
$cmsutil  -D -i META-INF/zigbert.rsa -c META-INF/zigbert.sf -u 6 && {
	echo
	echo ":) SIGNATURE CHECK SUCCESS: Congratulations, signature has been verified for the supplied certificate"
} || {
	echo
	echo ":( FAILED: Invalid signature"
	ex=1
}

cd "$cwd"
rm -r $tmp
rm -r $tmp_zip
exit $ex
