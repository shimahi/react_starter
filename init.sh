#!/bin/sh

source ./common.sh $1

rm -rf src/components src/graphql src/pages
rm -f src/store.tsx babel.next.config.js next-env.d.ts next.config.js next.sh codegen.js

find ./ -name "init.sh" | xargs rm
