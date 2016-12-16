const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");

module.exports = {
  entry: {
    app: "./ui/main.js",
    vendor: ["vue", "vue-router"]
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
      api:  "js/api",
      progressbar: "js/progressbar",
      vue:  "vue/dist/vue.js"
    }
  },
  module: {
    loaders: [
      { test: /.js$/,    loader: "babel", exclude: /node_modules/ },
      { test: /\.scss$/, loader: "style!css!postcss!sass"},
      { test: /\.html$/, loader: "html" },
      { test: /\.(woff|woff2|ttf|eot|svg)(\?.*)?$/, loader: "file" },
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
