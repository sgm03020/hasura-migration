#!/bin/sh

chdir /migrations
rm -rf /migrations/*
/scripts/migrate.exp

sleep 3
cd /migrations
cd /migrations/${CLONE}

SEEDS=`
curl -X POST \
  -H 'Content-Type: application/json' \
  -H 'X-Hasura-Role:admin' \
  -H "X-Hasura-Admin-Secret:${SECRET}" \
  -d '{"type":"run_sql","args":{"source":"default","sql":"SELECT tablename FROM pg_tables WHERE schemaname='\''public'\'';"}}' \
  ${ENDPOINT}/v2/query`

echo $SEEDS | jq .result[][0] | sed 's/"//g' | sed '/tablename/d' | sed 's/^/--from-table /g' |  xargs hasura seed create all_tables_seed --disable-interactive --database-name default --endpoint $ENDPOINT


tree /migrations

