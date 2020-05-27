//汎用設定
const path = require('path')
const HTMLPlugin = require('html-webpack-plugin')
const WorkerPlugin = require('worker-plugin')
const webpack = require('webpack')

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
        exclude: /node_modules/,
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
  plugins: [
    new HTMLPlugin({
      template: path.join(__dirname, 'src/index.html'),
    }),
    new WorkerPlugin(),
  ],
  resolve: {
    extensions: ['.js', '.ts', '.tsx', '.json', '.mjs', '.wasm'],
    modules: [
      path.resolve(__dirname, 'src'),
      path.resolve(__dirname, 'node_modules'),
    ],
  },
}
