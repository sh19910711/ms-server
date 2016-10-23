const webpack = require('webpack');
module.exports = Object.assign(require('./webpack.config'), {
  plugins: [ new webpack.optimize.UglifyJsPlugin() ]
});
