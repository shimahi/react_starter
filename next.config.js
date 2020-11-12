const path = require('path')

module.exports = (phase, { defaultConfig }) => {
  return {
    webpack: (config, { isServer }) => {
      if (!isServer) {
        config.node = {
          fs: 'empty',
        }
      }

      config.resolve.alias['@'] = path.join(__dirname, 'src')
      return config
    },
    reactStrictMode: true,
  }
}
