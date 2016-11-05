// Configuration
require.config({

  // set js dependency paths manually
  paths: {
    jquery: "/js/jquery-3.1.1",
    handlebars: "/js/handlebars-v4.0.5",
  },

  // base url for typescript modules
  baseUrl: "/ts",
});

// run main
require(["jquery", "main"], function ($, main) {
  $(document).ready(main);
});
