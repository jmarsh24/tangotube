const atImport = require("postcss-import");

module.exports = {
  plugins: [atImport, require("postcss-nesting"), require("autoprefixer")],
};
