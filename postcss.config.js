const atImport = require("postcss-import");

module.exports = {
  syntax: "postcss-scss",
  parser: "postcss-scss",
  plugins: [atImport, require("postcss-nested"), require("autoprefixer")],
};
