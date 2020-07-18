const path = require('path')
const { merge } = require('webpack-merge')
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
