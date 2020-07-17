#!/bin/bash 

ZIP_FILE=$(ls /drone/src/artifacts/*zip)

if [ ! -f $ZIP_FILE ]; then
  echo "[ERROR] No such file $ZIP_FILE"
  exit 1
fi

ACCESS_TOKEN=$(curl https://accounts.google.com/o/oauth2/token -d "client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}&refresh_token=${REFRESH_TOKEN}&grant_type=refresh_token&redirect_uri=urn:ietf:wg:oauth:2.0:oob" | jq -r .access_token)

# upload
curl --write-out %{http_code} -s -f -H "Authorization: Bearer ${ACCESS_TOKEN}" -H 'x-goog-api-version: 2' -X PUT -T $ZIP_FILE "https://www.googleapis.com/upload/chromewebstore/v1.1/items/${APPLICATION_ID}"

# publish
curl -H "Authorization: Bearer ${ACCESS_TOKEN}" -H "x-goog-api-version: 2" -H "Content-Length: 0" -X POST -v "https://www.googleapis.com/chromewebstore/v1.1/items/${APPLICATION_ID}/publish"
