const { environment } = require('@rails/webpacker')
const erb = require('./loaders/erb')
const coderay = require('./loaders/coderay')
const webpack = require('webpack')

environment.loaders.append('erb', erb)

environment.loaders.append('coderay', coderay)

environment.loaders.append('jqueryLibs', {
  test: [
    require.resolve('datatables.net-bs'),
    require.resolve('datatables.net'),
    require.resolve('jquery-ui-timepicker-addon')
  ],
  use: 'imports-loader?define=>false'
})

environment.loaders.append('jQueryExpose', {
  test: require.resolve('jquery'),
  use: {
    loader: 'expose-loader',
    options: '$'
  }
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

environment.plugins.append(
  'CommonChunkVendor',
  new webpack.optimize.CommonsChunkPlugin({
    name: 'vendor',
    minChunks: module =>
      module.context &&
      (module.context.indexOf('node_modules') !== -1 ||
        module.context.indexOf('vendor') !== -1)
  })
)

environment.plugins.append(
  'CommonsChunkManifest',
  new webpack.optimize.CommonsChunkPlugin({
    name: 'manifest',
    minChunks: Infinity
  })
)

module.exports = environment
