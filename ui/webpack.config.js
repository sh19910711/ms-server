const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");

module.exports = {
  entry: {
    app: "./ui/main.js",
  },
  output: {
    path: "public",
    publicPath: "/",
    filename: "[name].[chunkhash].js"
  },
  resolve: {
    extensions: ["", ".js"],
    root: path.resolve("ui"),
    alias: {
      api: "js/api",
      vue: "vue/dist/vue.js"
    }
  },
  module: {
    loaders: [
      { test: /.js$/,    loader: "babel", exclude: /node_modules/ },
      { test: /\.scss$/, loader: "style!css!sass"},
      { test: /\.html$/, loader: "html-loader"},
    ]
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: "./ui/index.html",
      inject: true
    })
  ],
  babel: {
    presets: ['es2015'],
    plugins: ['transform-runtime']
  },
  sassLoader: {
    includePaths: [path.resolve("ui/css")]
  },
  devServer: {
    contentBase: 'public',
    port: 8080,
    historyApiFallback: true,
    inline: true,
    proxy: {
      '/api/*': "http://localhost:3000"
    }
  }
}
