// Configuration
require.config({

  // set js dependency paths manually
  paths: {
    jquery: "/static/js/jquery-3.1.1",
    handlebars: "/static/js/handlebars-v4.0.5",
  },

  // base url for typescript modules
  baseUrl: "/static/ts",
});

// run main
require(["jquery", "main"], function ($, main) {
  $(document).ready(main);
});
