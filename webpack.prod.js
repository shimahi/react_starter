const merge = require('webpack-merge')
const common = require('./webpack.common.js')
const { CleanWebpackPlugin } = require('clean-webpack-plugin')

module.exports = merge(common, {
  mode: 'production',
  output: {
    publicPath: '/dist/',
  },
  devtool: 'none',
  plugins: [
    new CleanWebpackPlugin({
      cleanOnceBeforeBuildPatterns: ['**/*.js', '**/*.css', '!.gitkeep'],
    }),
  ],
})
