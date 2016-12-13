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
  devServer: {
    contentBase: 'public',
    port: 8080
  }
}
