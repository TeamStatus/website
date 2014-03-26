if (process.argv.length <= 2) {
	process.stdout.write("usage: " + process.argv[0] + " " + process.argv[1] + " integrationId")
	process.exit(1);
}

var fs = require('fs');
var integrationId = process.argv[2];
var path = require('path');
var modulePath = './' + integrationId + '/job.js';

if (fs.existsSync(modulePath)) {
	var job = require();
	var loader = require('./integration-api/loader.js');

	var dependencies = {};

	loader.fillDependencies(dependencies);

	var cb = function(err, data) {
		if (err) {
			process.stdout.write(JSON.stringify(err));
			process.exit(1);
		} else {
			process.stdout.write(JSON.stringify(data));
			process.exit(0);
		}
	};

	var configuraton = "";

	process.stdin.setEncoding('utf8');

	process.stdin.on('readable', function(chunk) {
	  var chunk = process.stdin.read();
	  if (chunk !== null) {
	    configuraton += chunk;
	  }
	});

	process.stdin.on('end', function() {
		job(JSON.parse(configuraton), dependencies.dependencies, cb);
	});
} else {
	process.stdout.write(JSON.stringify({
		error: "Module doesn't exist " + integrationId
	}));
	process.exit(111);
}
