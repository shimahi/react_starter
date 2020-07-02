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
npx npm-add-script -k start -v "webpack-dev-server --open --hot --inline --config webpack.dev.js  --env=development"
npx npm-add-script -k dev -v "webpack --config webpack.dev.js --env=development"
npx npm-add-script -k build -v "webpack --config webpack.prod.js --env=production"

### prepare bundler and other config files
touch .blowserslistrc .gitignore .postcssrc tsconfig.json webpack.common.js webpack.dev.js webpack.prod.js

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
        exclude: /node_modules/,
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
        test: /.css$/,
        include: /node_modules/,
        use: [
          'style-loader',
          {
            loader: 'css-loader',
            options: {
              modules: false,
              url: true,
              importLoaders: 1,
            },
          },
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
mkdir -p src/assets/css/foundation types
touch src/index.html src/index.tsx \
  src/assets/css/foundation/global.css src/assets/css/foundation/media.css \
  types/style.css.d.ts types/images.d.ts

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

echo 'html {
  width: 100vw;
  overflow-x: hidden;
}

a {
  text-decoration: none;
}
' >>src/assets/css/foundation/global.css

echo '@custom-media --xxs (max-width: 413.8px);
@custom-media --xs (max-width: 575.98px);
@custom-media --sm (min-width: 575.98px);
@custom-media --md (min-width: 767.98px);
@custom-media --lg (min-width: 991.98px);
@custom-media --xl (min-width: 1199.98px);
@custom-media --xxl (min-width: 1599.98px);
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

yarn add -D typescript @types/{node,react,react-dom} \
  webpack webpack-{cli,dev-server,merge} {ts,style,css,url,file,postcss}-loader html-webpack-plugin worker-plugin dotenv-webpack \
  ress autoprefixer strip-ansi doiuse css-mqpacker cssnano postcss-{comment,custom-media,nested,pxtorem,custom-properties}  \
  graphql graphql-tag apollo-{client,cache-inmemory,link-http} react-apollo @apollo/react-hooks

## write README
touch README.md
echo "# $1" >>README.md

## remove this script
find ./ -name "*.sh" | xargs rm
