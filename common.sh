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

## setting git
rm -rf .git
rm -f .gitignore README.md
touch .gitignore .env
echo 'node_modules
dist/*
yarn-error.log
.DS_Store
.vscode
.env
src/types/graphql.ts
' >>.gitignore
git init &

### import npm packages
yarn add react react-dom @emotion/react @emotion/styled ress twin.macro react-test-renderer @testing-library/react
wait #husky should be installed after '.git' was created.
yarn add -D typescript @types/{node,react,react-dom} \
  webpack webpack-{cli,dev-server} {ts,style,css,babel}-loader dotenv-webpack \
  @emotion/babel-preset-css-prop autoprefixer \
  @babel/{core,preset-env,preset-react,plugin-transform-runtime} \
  prettier eslint eslint-config-{airbnb-typescript,prettier} eslint-plugin-{import,jsx-a11y,prettier,react,react-hooks} \
  @typescript-eslint/eslint-plugin @typescript-eslint/parser \
  lint-staged husky html-webpack-plugin worker-plugin \
  jest ts-jest @types/jest eslint-plugin-jest @types/react-test-renderer

## write README
touch README.md
echo "# $1" >>README.md

## setup tailwindcss
npx tailwindcss init

## setup test folder
mkdir src/__tests__
mkdir src/__tests__/components
mkdir src/__tests__/lib

## remove this script
find ./ -name "common.sh" | xargs rm
