#!/bin/sh

source ./common.sh $1


## setting git
rm -f .gitignore README.md
touch .env.local .gitignore
echo "NEXT_PUBLIC_GRAPHQL_ENDPOINT=http://localhost:3000/api/graphql
" >>.env.local

echo '# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

# dependencies
/node_modules
/.pnp
.pnp.js

# testing
/coverage

# next.js
/.next/
/out/

# production
/build

# misc
.DS_Store

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# local env files
.env.local
.env.development.local
.env.test.local
.env.production.local

# DX
.vscode
' >>.gitignore

rm -f babel.config.js init.sh webpack.config.js
rm -f src/index.html src/index.tsx
mv babel.next.config.js babel.config.js

mkdir src/components/atoms
mkdir src/components/molecules
mkdir src/components/organisms
mkdir src/components/templates
mkdir src/contexts

### import npm packages
yarn add next graphql @apollo/client apollo-server-micro @emotion/server @emotion/css

yarn add -D @graphql-codegen/{cli,typescript,typescript-operations,typescript-react-apollo} \
  url-loader file-loader

yarn remove html-webpack-plugin worker-plugin

## change "scripts" attributes of package.json
cat package.json | jq '.scripts.dev = "next dev"' | jq '.scripts.build = "next build"'  > tmp.json
rm -f package.json
mv tmp.json package.json

## add scripts
npx npm-add-script -k start -v "next start"
npx npm-add-script -k export -v "next export"

## remove this script
find ./ -name "next.sh" | xargs rm
