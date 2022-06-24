if [ -z $ENDPOINT ]; then
  ENDPOINT='http://localhost:8080'
fi

# shell variables
if [ -z $SECRET ]; then
  SECRET='mysecret'
fi

cd /migrations

# hasura pg_dump API
if [[ "$PWD" == "/migrations" ]]; then
  curl --location --request POST "${ENDPOINT}/v1alpha1/pg_dump" \
  --header "x-hasura-admin-secret: ${SECRET}" --header 'Content-Type: application/json' \
  --data-raw '{  "opts": ["-O", "-x", "--schema-only", "--schema", "public"],  "clean_output": true}' \
  -o backup-schema-only.sql
fi


# public + data only backup to backup-datga-only.sql
if [[ "$PWD" == "/migrations" ]]; then
  curl --location --request POST "${ENDPOINT}/v1alpha1/pg_dump" \
  --header "x-hasura-admin-secret: ${SECRET}" --header 'Content-Type: application/json' \
  --data-raw '{  "opts": ["-O", "-x", "--schema", "public", "--data-only"],  "clean_output": true}' \
  -o backup-data-only.sql
fi


# migration target
#if [ -z $TARGET ]; then
#  : #exit 1
#else
#  # migrate metadata
#  if [[ "$PWD" == "/migrations" ]]; then
#    hasura migrate apply --endpoint $TARGET --admin-secret $SECRET
#  fi
#fi

# table data
# port = 43254
if [ -z $DB_URL ]; then
  DB_URL=postgresql://postgres:postgrespassword@taat-api-202206.tk:43254/postgres
fi

if [ -z $DB_URL ]; then
  : #exit 1
else
   # psql "postgresql://{ホスト名}:{ポート番号}/{DB名}?user={ユーザ名}&password={パスワード}"
   # postgresql://localhost/mydb?user=other&password=secret
   # const conString = "postgres://YourUserName:YourPassword@YourHostname:5432/YourDatabaseName";
   # psql -f ./backup-data-only.sql -U postgres -d postgres -h $DB_URL
   # 1) psql postgresql://postgres:postgrespassword@taat-api-202206.tk:43254/postgres
   #    psql -f ./backup-data-only.sql "${DB_URL}?user=postgres&password=postgrespassword"

   #psql -f ./backup-schema-only.sql $DB_URL
   #psql -f ./backup-data-only.sql $DB_URL
   :
fi


