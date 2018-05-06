const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

environment.loaders.append('jqueryLibs', {
  test: [
    require.resolve('datatables.net-bs'),
    require.resolve('datatables.net'),
    require.resolve('jquery-ui-timepicker-addon')
  ],
  use: 'imports-loader?define=>false'
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

module.exports = environment
