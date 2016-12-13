const path = require("path");

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
}
