// Configuration
require.config({
  paths: {
    jquery: "/static/js/jquery-3.1.1.slim.min",

    // main application
    main: "/static/ts/main"
  }
});

// run main
require(["main"]);
