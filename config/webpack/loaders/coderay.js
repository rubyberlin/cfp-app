const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const path = require('path')

const postcssConfigPath = path.resolve(process.cwd(), '.postcssrc.yml')
const isProduction = process.env.NODE_ENV === 'production'

module.exports = {
  // '/\\.(js|jsx)?(\\.erb)?$/',
  test: path.resolve(process.cwd(), 'app/javascript/vendor/coderay.css.erb'),
  use: [
    MiniCssExtractPlugin.loader,
    {
      loader: 'css-loader',
      options: {
        sourceMap: true,
        importLoaders: 2,
        modules: false
      }
    },
    {
      loader: 'postcss-loader',
      options: {
        sourceMap: true,
        config: { path: postcssConfigPath }
      }
    }
  ]
}
