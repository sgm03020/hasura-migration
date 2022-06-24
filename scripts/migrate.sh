#!/bin/sh

chdir /migrations
rm -rf /migrations/*
/scripts/migrate.exp

sleep 3
cd /migrations
cd /migrations/${CLONE}

# metadata.json
curl -d'{"type": "export_metadata", "args": {}}' \
 --header "x-hasura-admin-secret: ${SECRET}" \
 ${ENDPOINT}/v1/metadata -o hasura_metadata.json

# public table list
PUBLIC_SEEDS=`
curl -X POST \
  -H 'Content-Type: application/json' \
  -H 'X-Hasura-Role:admin' \
  -H "X-Hasura-Admin-Secret:${SECRET}" \
  -d '{"type":"run_sql","args":{"source":"default","sql":"SELECT tablename FROM pg_tables WHERE schemaname='\''public'\'';"}}' \
  ${ENDPOINT}/v2/query`

# public data
echo $PUBLIC_SEEDS | jq .result[][0] | sed 's/"//g' | sed '/tablename/d' | sed 's/^/--from-table /g' |  xargs hasura seed create public_seeds --disable-interactive --database-name default --endpoint $ENDPOINT

# hdb_catalog table list
HDB_CATALOG_SEEDS=`
curl -X POST \
  -H 'Content-Type: application/json' \
  -H 'X-Hasura-Role:admin' \
  -H "X-Hasura-Admin-Secret:${SECRET}" \
  -d '{"type":"run_sql","args":{"source":"default","sql":"SELECT tablename FROM pg_tables WHERE schemaname='\''hdb_catalog'\'';"}}' \
  ${ENDPOINT}/v2/query`

# hdb_catalog data
echo $HDB_CATALOG_SEEDS | jq .result[][0] | sed 's/"//g' | sed '/tablename/d' | sed 's/^/--from-table /g' |  xargs hasura seed create hdb_catalog_seeds --disable-interactive --database-name default --endpoint $ENDPOINT


tree /migrations

