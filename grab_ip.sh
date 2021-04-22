#!/bin/bash
# This script spits out fresh IPs from the traphouse server.
# Enter your Traphouse username and password, and the IP group if different from default.

# Edit your options here...
TRAPHOUSE_USERNAME="youremail@gmail.com"
TRAPHOUSE_PASSWORD="YOURPA\$\$WORD"
IP_GROUP="default"

# Okay, the code.
SESSION_COOKIE=`curl -s -c - https://ccdc.io/ | fgrep _session_id | sed s/.*_session_id.//`
AUTH_TOKEN=`curl -s --cookie "_session_id=$SESSION_COOKIE" https://ccdc.io/auth/login | fgrep name=\"authenticity_token\" | sed s/.*value=\"// | sed s/\".*//`
USER_TOKEN=`curl -s -c - --cookie "_session_id=$SESSION_COOKIE" --referer "https://ccdc.io/auth/login" --data-urlencode "authenticity_token=$AUTH_TOKEN"  --data-urlencode "user%5Bemail%5D=$TRAPHOUSE_USERNAME" --data-urlencode "user%5Bpassword%5D=$TRAPHOUSE_PASSWORD" --data-urlencode "user%5Bremember_me%5D=0" --data-urlencode "user%5Bremember_me%5D=1" --data-urlencode "commit=Sign In" -X POST https://ccdc.io/auth/login | fgrep remember_user_token | sed s/.*remember_user_token.//`
SESSION_COOKIE=`curl -c - -s --cookie "_session_id=$SESSION_COOKIE; remember_user_token=$USER_TOKEN" https://nccdc2021.ccdc.io/dashboard/settings/network | fgrep _session_id | sed s/.*_session_id.//`
CSRF_TOKEN=`curl -s --cookie "_session_id=$SESSION_COOKIE; remember_user_token=$USER_TOKEN" https://nccdc2021.ccdc.io/dashboard/settings/network | fgrep csrf-token | sed 's/.*content=\"//' | sed 's/\".*//'`
curl -s --cookie "_session_id=$SESSION_COOKIE; remember_user_token=$USER_TOKEN" --referer "https://nccdc2021.ccdc.io/dashboard/settings/network" -H "X-CSRF-Token: $CSRF_TOKEN" --data-urlencode "group_name=$IP_GROUP" --data-urlencode "sample_size=1" -X POST https://nccdc2021.ccdc.io/dashboard/settings/network/generate
