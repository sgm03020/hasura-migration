if [ -z $ENDPOINT ]; then
  ENDPOINT='http://localhost:8080'
fi

# shell variables
if [ -z $TARGET_SECRET ]; then
  TARGET_SECRET='mysecret'
fi

cd /migrations/$CLONE

# hasura metadata apply --envfile env/.prod.env

# migration target
if [ -z $TARGET ]; then
  : #exit 1
else
  # migrate metadata
  if [[ "$PWD" == "/migrations/${CLONE}" ]]; then
    hasura migrate apply --endpoint $TARGET --database-name default --admin-secret $TARGET_SECRET --disable-interactive --skip-update-check
    sleep 3
    hasura seed apply --endpoint $TARGET --database-name default --admin-secret $TARGET_SECRET --disable-interactive --skip-update-check
  fi
fi

