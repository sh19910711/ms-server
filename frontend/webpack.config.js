const APP_PATH = require('path').join(__dirname, 'app');
module.exports = {
  context: APP_PATH,
  entry: ['main'],
  output: { path: __dirname + '/public/js', publicPath: 'js/', filename: 'bundle.js' },
  resolve: {
    extensions: ['', '.js'],
    root: [APP_PATH],
    alias: {
      'vue': 'vue/dist/vue.min.js',
      'vue-router': 'vue-router/dist/vue-router.min.js',
    }
  },
  module: {
    loaders: [
      { test: /\.vue$/, loader: 'vue' },
      { test: /\.js$/,  loader: 'babel', exclude: /node_modules/ },
      { test: /\.scss$/, loader: 'style!css!sass' }
    ],
    preLoaders: [
      { test: /\.js$/, loader: 'eslint', exclude: /node_modules/ }
    ]
  },
  babel: { presets: ['es2015'], plugins: ['transform-runtime'] },
  vue: { loaders: { sass: 'style!css!sass' } },
  watchOptions: { poll: 1000 }
};
