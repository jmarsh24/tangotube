const atImport = require("postcss-import");

module.exports = {
<<<<<<< HEAD
  syntax: "postcss-scss",
  parser: "postcss-scss",
  plugins: [atImport, require("postcss-nested"), require("autoprefixer")],
=======
  plugins: [atImport, require("postcss-nesting"), require("autoprefixer")],
>>>>>>> c05ceed4 (Fix login header)
};
