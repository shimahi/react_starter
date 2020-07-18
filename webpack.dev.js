const path = require('path')
const { merge } = require('webpack-merge')
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
