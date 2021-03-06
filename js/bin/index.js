#!/usr/bin/env node

const minimist = require("minimist");
const fs =require('fs');

var args = minimist(process.argv.slice(2), {
    alias: {
        'serve': 's',
        'help': 'h',
        'port': 'p',
    },
    boolean: ['serve', 'help'],
    string: ['port', 'elm-format-path']
});

(function() {
    const elmFormatPath = args['elm-format-path'] || 'elm-format';
    const config = {
        port: args.port || 3000,
        elmFormatPath: elmFormatPath,
    }
    if (args.help) {
      console.log("Usages:");
      console.log("  $ elm-analyse")
      console.log("    # Analyse the project and log messages to the console\n")
      console.log("  $ elm-analyse -s");
      console.log("    # Analyse the project and start a server. Allows inspection of messages through a browser (Default: http://localhost:3000).\n");
      console.log("Options: ")
      console.log("   --help, -h          Print the help output.");
      console.log("   --serve, -s         Enable server mode. Disabled by default.");
      console.log("   --port, -p          The port on which the server should listen. Defaults to 3000.");
      console.log("   --elm-format-path   Path to elm-format. Defaults to `elm-format`.");
      process.exit(1);
    }

    const packageFileExists = fs.existsSync('./elm-package.json');
    if (!packageFileExists) {
      console.log("There is no elm-package.json file in this directory. elm-analyse will only work in directories where such a file is located.");
      return;
    }


    if (args.serve) {
        var server = require('../server/app.js');
        server(config);
        return
    }
    var analyser = require('../analyser.js');
    analyser(config);
})();
