const { environment } = require('@rails/webpacker')
const erb = require('./loaders/erb')
const coderay = require('./loaders/coderay')
const webpack = require('webpack')

const babelLoader = environment.loaders.get('babel')
babelLoader.exclude = /node_modules\/(?!tributejs)/;

environment.loaders.append('erb', erb)

environment.loaders.append('coderay', coderay)

environment.loaders.append('jqueryLibs', {
  test: [
    require.resolve('datatables.net-bs4'),
    require.resolve('datatables.net'),
    require.resolve('jquery-ui-timepicker-addon')
  ],
  use: 'imports-loader?define=>false'
})

environment.loaders.append('jQueryExpose', {
  test: require.resolve('jquery'),
  use: [
    {
      loader: 'expose-loader',
      options: 'jQuery'
    },
    {
      loader: 'expose-loader',
      options: '$'
    }
  ]
})

environment.loaders.append('momentExpose', {
  test: require.resolve('moment'),
  use: [
    {
      loader: 'expose-loader',
      options: 'moment'
    }
  ]
})

// Add an additional plugin of your choosing : ProvidePlugin
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    _: 'underscore',
    $: 'jquery',
    jQuery: 'jquery',
    'window.$': 'jquery',
    'window.jQuery': 'jquery'
  })
)

environment.plugins.prepend(
  'momentLocales',
  new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/)
)

environment.config.set('optimization', {
  splitChunks: {
    cacheGroups: {
      // default: false,
      commons: {
        test: /[\\/](node_modules|vendor)[\\/]/,
        name: 'vendor',
        chunks: 'all'
      }
    }
  },
  runtimeChunk: {
    name: 'runtime'
  }
})

module.exports = environment
