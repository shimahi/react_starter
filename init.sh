#!/bin/sh

if [ $# != 1 ]; then
  echo "Please set an argument"
  return 2>&- || exit
fi

#rename this directory
initialDir=basename$(pwd)
initialDirVal=$(basename ${initialDir})
mv ../${initialDirVal} ../"$1"
cd ../"$1"

# ### remove original git information
rm -rf .git
rm -f .gitignore README.md

# ### initialize package.json
yarn init -y
npx npm-add-script -k start -v "webpack-dev-server --port=3000 --open --hot --inline --config webpack.dev.js --env=development"
npx npm-add-script -k dev -v "webpack --config webpack.dev.js --env=development"
npx npm-add-script -k build -v "webpack --config webpack.prod.js --env=production"

### import npm packages
yarn add react react-dom
yarn add -D typescript @types/{node,react,react-dom} \
  webpack webpack-{cli,dev-server,merge} {ts,style,css,url,file,babel}-loader html-webpack-plugin worker-plugin dotenv-webpack \
  ress @emotion/{core,babel-preset-css-prop} \
  @babel/{core,preset-env,preset-react} \
  graphql graphql-tag apollo-{client,cache-inmemory,link-http} react-apollo @apollo/react-hooks \
  @graphql-codegen/{cli,typescript,typescript-operations,typescript-react-apollo} \
  prettier

## write README
touch README.md
echo "# $1" >>README.md

## write gitignore
touch .gitignore
echo 'node_modules
dist/*
yarn-error.log
.DS_Store
.vscode
' >>.gitignore

## remove this script
find ./ -name "*.sh" | xargs rm
