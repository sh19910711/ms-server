if (!process.env['SERVER_URL']) throw 'SERVER_URL is empty';
const port = process.env['PORT'] || 8080;

const webpack = require('webpack');
const config = require('./webpack.config');
config.entry.unshift('webpack/hot/dev-server', `webpack-dev-server/client?http://localhost:${port}`);
config.plugins = config.plugins || [];
config.plugins.push(new webpack.HotModuleReplacementPlugin());

const WebpackDevServer = require('webpack-dev-server');
const devServer = new WebpackDevServer(webpack(config), {
  hot: true,
  inline: true,
  stats: { colors: true, chunks: false },
  contentBase: '/disable/directory/listing',
  publicPath: '/js',
  proxy: { '/api/*': process.env['SERVER_URL'] }
});
devServer.use('*', (req, res) => res.sendFile(__dirname + '/frontend/main.html'));
devServer.listen(port);
