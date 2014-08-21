#!/bin/bash -x

# allow install script to run before they get re-disabled
chmod a+rx /opt/teampass/install
rm /opt/teampass/includes/settings.php

COOKIEJAR=`mktemp`
URL='{{ salt["pillar.get"]("teampass:url", "http://localhost/teampass") }}/install'
curl -v -c $COOKIEJAR -b $COOKIEJAR --data 'step=3&db_host={{ salt["pillar.get"]("teampass:mysql:host", "localhost") }}&db_bdd={{ salt["pillar.get"]("teampass:mysql:db", "teampass") }}&db_login={{ salt["pillar.get"]("teampass:mysql:user", "teampass") }}&db_pw={{ salt["pillar.get"]("teampass:mysql:pass") }}' $URL/install.php
curl -v -c $COOKIEJAR -b $COOKIEJAR --data 'step=4&tbl_prefix=teampass_' $URL/install.php
curl -v -b $COOKIEJAR --data 'type=step1&abspath=/opt/teampass&url_path={{ pillar["teampass"]["url"] }}' $URL/install_ajax.php
curl -v -b $COOKIEJAR --data type=step4 $URL/install_ajax.php
RET=$?
rm $COOKIEJAR
exit $RET
