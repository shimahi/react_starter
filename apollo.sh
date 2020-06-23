#!/bin/sh

if [ $# != 1 ]; then
  echo "Please set a one argument"
else
  #rename this directory
  initialDir=basename$(pwd)
  initialDirVal=$(basename ${initialDir})
  mv ../${initialDirVal} ../"$1"
  cd ../"$1"

  # ### remove original git information
  rm -rf -f .git
  rm -f .gitignore
  rm -f README.md

  # ### initialize package.json
  yarn init -y
  npx npm-add-script -k start -v "webpack-dev-server --open --hot --inline --config webpack.dev.js  --env=development"
  npx npm-add-script -k dev -v "webpack --config webpack.dev.js --env=development"
  npx npm-add-script -k build -v "webpack --config webpack.prod.js --env=production"

  ### prepare bundler and other config files
  touch .blowserslistrc
  touch .gitignore
  touch .postcssrc
  touch tsconfig.json
  touch webpack.common.js
  touch webpack.dev.js
  touch webpack.prod.js

  echo 'last 2 version
  > 1%
  ' >>.blowserslistrc

  echo 'node_modules
  dist/*
  yarn-error.log
  .DS_Store
  .vscode
  ' >>.gitignore

  echo '{
    "modules": true,
    "parser": "postcss-comment",
    "plugins": {
      "postcss-pxtorem": {},
      "postcss-nested": {},
      "postcss-custom-media": {
        "importFrom": "./src/assets/css/foundation/media.css"
      },
      "postcss-custom-properties": {},
      "css-mqpacker": {},
      "cssnano": {
        "preset": [
          "default", {"discardComments": {"removeAll": true}}
        ]
      },
      "autoprefixer": {
        "grid": "autoplace"
      },
      "doiuse": {}
    }
  }
  ' >>.postcssrc

  echo '{
    "compilerOptions": {
      "target": "es2019",
      "module": "esnext",
      "moduleResolution": "node",
      "jsx": "react",
      "strict": true,
      "esModuleInterop": true,
      "forceConsistentCasingInFileNames": true,
      "baseUrl": "src",
      "paths": {
        "@/*": ["src/*"]
      },
      "typeRoots": ["types", "mode_modules/@types"],
      "resolveJsonModule": true
    }
  }
  ' >>tsconfig.json

  echo "const path = require('path')
  const WorkerPlugin = require('worker-plugin')

  module.exports = {
    entry: './src/index.tsx',
    output: {
      path: path.resolve(__dirname, 'dist'),
      filename: 'bundle.js',
    },
    module: {
      rules: [
        {
          test: /\.tsx?$/,
          use: {
            loader: 'ts-loader',
            options: {
              transpileOnly: true,
            },
          },
        },
        {
          test: /\.(css|pcss)/,
          use: [
            'style-loader',
            {
              loader: 'css-loader',
              options: {
                modules: true,
                url: true,
                importLoaders: 1,
              },
            },
            'postcss-loader',
          ],
        },
        {
          test: /\.(gif|png|jpg|eot|wof|woff|ttf|svg)$/,
          use: [
            {
              loader: 'url-loader',
              options: {
                limit: 100 * 1024,
                name: './img/[name].[ext]',
              },
            },
          ],
        },
      ],
    },
    resolve: {
      extensions: ['.js', '.ts', '.tsx', '.json', '.mjs', '.wasm'],
      modules: [
        path.resolve(__dirname, 'src'),
        path.resolve(__dirname, 'node_modules'),
      ],
      alias: {
        src: path.resolve(__dirname, 'src'),
      },
    },
    plugins: [new WorkerPlugin()],
  }
  " >>webpack.common.js

  echo "const path = require('path')
  const merge = require('webpack-merge')
  const common = require('./webpack.common.js')
  const HTMLPlugin = require('html-webpack-plugin')
  const Dotenv = require('dotenv-webpack')

  module.exports = merge(common, {
    mode: 'development',
    devtool: 'inline-source-map',
    devServer: {
      watchContentBase: true,
    },
    plugins: [
      new HTMLPlugin({
        template: path.join(__dirname, 'src/index.html'),
      }),
      new Dotenv({
        path: path.join(__dirname, '.env.development'),
      }),
    ],
  })
  " >>webpack.dev.js

  echo "const path = require('path')
  const merge = require('webpack-merge')
  const common = require('./webpack.common.js')
  const Dotenv = require('dotenv-webpack')

  module.exports = merge(common, {
    mode: 'production',
    output: {
      publicPath: '/dist/',
    },
    devtool: 'none',
    plugins: [
      new Dotenv({
        path: path.join(__dirname, '.env.production'),
      }),
    ],
  })
  " >>webpack.prod.js

  ### make source files
  mkdir src
  mkdir src/assets
  mkdir src/assets/css
  mkdir src/assets/css/foundation
  touch src/index.html
  touch src/index.tsx
  touch src/assets/css/foundation/global.css
  touch src/assets/css/foundation/media.css
  mkdir types
  touch types/style.css.d.ts
  touch types/images.d.ts

  echo '<!DOCTYPE html>
  <html lang="ja">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>いぬ</title>
  </head>
  <body>
    <div id="root"></div>
  </body>
  </html>
  ' >>src/index.html

  echo "import 'ress'
  import 'assets/css/foundation/global.css'

  import React from 'react'
  import { render } from 'react-dom'

  const App: React.FC = () => {
    return <h1>Hello React!</h1>
  }

  render(<App />, document.getElementById('root'))
  " >>src/index.tsx

  echo 'a {
    text-decoration: none;
  }
  ' >>src/assets/css/foundation/global.css

  echo '@custom-media --xxs (max-width: 413.8px);
  @custom-media --xs (max-width: 575.98px);

  @custom-media --sm (min-width: 575.98px);
  @custom-media --md (min-width: 767.98px);
  @custom-media --lg (min-width: 991.98px);
  @custom-media --xl (min-width: 1199.98px);
  ' >>src/assets/css/foundation/media.css

  echo "declare module '*.png'
  declare module '*.jpg'
  declare module '*.gif'
  declare module '*.svg'
  " >>types/images.d.ts

  echo "declare module '*.css' {
    interface IClassNames {
      [className: string]: string
    }
    const classNames: IClassNames
    export = classNames
  }

  declare module '*.pcss' {
    interface IClassNames {
      [className: string]: string
    }
    const classNames: IClassNames
    export = classNames
  }
  " >>types/style.css.d.ts

  ### import npm packages

  yarn add react react-dom

  yarn add -D typescript webpack webpack-cli ts-loader webpack-dev-server html-webpack-plugin style-loader css-loader @types/node url-loader file-loader postcss-loader worker-plugin webpack-merge dotenv-webpack @types/react @types/react-dom autoprefixer css-mqpacker cssnano postcss-comment postcss-custom-media postcss-nested postcss-pxtorem postcss-custom-properties ress strip-ansi doiuse apollo-client react-apollo graphql graphql-tag @apollo/react-hooks apollo-cache-inmemory apollo-link-http

  ## write README
  touch README.md
  echo "# $1" >>README.md

  ## remove this script
  rm -f init.sh
fi
