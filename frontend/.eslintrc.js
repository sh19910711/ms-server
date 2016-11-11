module.exports = {
  'env': { 'browser': true },
  'extends': 'eslint:recommended',
  'rules': {
    'indent': ['error', 2],
    'no-console': 0,
    'linebreak-style': ['error', 'unix'],
    'quotes': ['error', 'single'],
    'semi': ['error', 'always'],
    'no-empty-label': 0
  },
  'parserOptions': { 'sourceType': 'module' }
};
