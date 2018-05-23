const ExtractTextPlugin = require('extract-text-webpack-plugin')
const path = require('path')

const postcssConfigPath = path.resolve(process.cwd(), '.postcssrc.yml')
const isProduction = process.env.NODE_ENV === 'production'

module.exports = {
  test: path.resolve(process.cwd(), 'app/javascript/vendor/coderay.css.erb'),
  exclude: /node_modules/,
  use: ExtractTextPlugin.extract({
    fallback: {
      loader: 'style-loader',
      options: {
        sourceMap: true
        // hmr: isHMR
      }
    },
    use: [
      {
        loader: 'css-loader',
        options: {
          minimize: isProduction,
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
  })
}
