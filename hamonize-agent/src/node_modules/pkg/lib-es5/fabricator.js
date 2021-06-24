"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.shutdown = exports.fabricateTwice = exports.fabricate = void 0;
var child_process_1 = require("child_process");
var log_1 = require("./log");
var script = "\n  var vm = require('vm');\n  var module = require('module');\n  var stdin = Buffer.alloc(0);\n  process.stdin.on('data', function (data) {\n    stdin = Buffer.concat([ stdin, data ]);\n    if (stdin.length >= 4) {\n      var sizeOfSnap = stdin.readInt32LE(0);\n      if (stdin.length >= 4 + sizeOfSnap + 4) {\n        var sizeOfBody = stdin.readInt32LE(4 + sizeOfSnap);\n        if (stdin.length >= 4 + sizeOfSnap + 4 + sizeOfBody) {\n          var snap = stdin.toString('utf8', 4, 4 + sizeOfSnap);\n          var body = Buffer.alloc(sizeOfBody);\n          var startOfBody = 4 + sizeOfSnap + 4;\n          stdin.copy(body, 0, startOfBody, startOfBody + sizeOfBody);\n          stdin = Buffer.alloc(0);\n          var code = module.wrap(body);\n          var s = new vm.Script(code, {\n            filename: snap,\n            produceCachedData: true,\n            sourceless: true\n          });\n          if (!s.cachedDataProduced) {\n            console.error('Pkg: Cached data not produced.');\n            process.exit(2);\n          }\n          var h = Buffer.alloc(4);\n          var b = s.cachedData;\n          h.writeInt32LE(b.length, 0);\n          process.stdout.write(h);\n          process.stdout.write(b);\n        }\n      }\n    }\n  });\n  process.stdin.resume();\n";
var children = {};
function fabricate(bakes, fabricator, snap, body, cb) {
    var activeBakes = bakes.filter(function (bake) {
        // list of bakes that don't influence the bytecode
        var bake2 = bake.replace(/_/g, '-');
        return !['--prof', '--v8-options', '--trace-opt', '--trace-deopt'].includes(bake2);
    });
    var cmd = fabricator.binaryPath;
    var key = JSON.stringify([cmd, activeBakes]);
    var child = children[key];
    if (!child) {
        var stderr = log_1.log.debugMode ? process.stdout : 'ignore';
        children[key] = child_process_1.spawn(cmd, activeBakes.concat('-e', script), {
            stdio: ['pipe', 'pipe', stderr],
            env: { PKG_EXECPATH: 'PKG_INVOKE_NODEJS' },
        });
        child = children[key];
    }
    function kill() {
        delete children[key];
        child.kill();
    }
    var stdout = Buffer.alloc(0);
    function onError(error) {
        // eslint-disable-next-line no-use-before-define
        removeListeners();
        kill();
        cb(new Error("Failed to make bytecode " + fabricator.nodeRange + "-" + fabricator.arch + " for file " + snap + " error (" + error.message + ")"));
    }
    function onClose(code) {
        // eslint-disable-next-line no-use-before-define
        removeListeners();
        kill();
        if (code !== 0) {
            return cb(new Error("Failed to make bytecode " + fabricator.nodeRange + "-" + fabricator.arch + " for file " + snap));
        }
        // eslint-disable-next-line no-console
        console.log(stdout.toString());
        return cb(new Error(cmd + " closed unexpectedly"));
    }
    function onData(data) {
        stdout = Buffer.concat([stdout, data]);
        if (stdout.length >= 4) {
            var sizeOfBlob = stdout.readInt32LE(0);
            if (stdout.length >= 4 + sizeOfBlob) {
                var blob = Buffer.alloc(sizeOfBlob);
                stdout.copy(blob, 0, 4, 4 + sizeOfBlob);
                // eslint-disable-next-line no-use-before-define
                removeListeners();
                return cb(undefined, blob);
            }
        }
    }
    function removeListeners() {
        child.removeListener('error', onError);
        child.removeListener('close', onClose);
        child.stdin.removeListener('error', onError);
        child.stdout.removeListener('error', onError);
        child.stdout.removeListener('data', onData);
    }
    child.on('error', onError);
    child.on('close', onClose);
    child.stdin.on('error', onError);
    child.stdout.on('error', onError);
    child.stdout.on('data', onData);
    var h = Buffer.alloc(4);
    var b = Buffer.from(snap);
    h.writeInt32LE(b.length, 0);
    child.stdin.write(h);
    child.stdin.write(b);
    b = body;
    h.writeInt32LE(b.length, 0);
    child.stdin.write(h);
    child.stdin.write(b);
}
exports.fabricate = fabricate;
function fabricateTwice(bakes, fabricator, snap, body, cb) {
    fabricate(bakes, fabricator, snap, body, function (error, buffer) {
        // node0 can not produce second time, even if first time produced fine,
        // probably because of 'filename' cache. also, there are wierd cases
        // when node4 can not compile as well, for example file 'lib/js-yaml/dumper.js'
        // of package js-yaml@3.9.0 does not get bytecode second time on node4-win-x64
        if (error)
            return fabricate(bakes, fabricator, snap, body, cb);
        cb(undefined, buffer);
    });
}
exports.fabricateTwice = fabricateTwice;
function shutdown() {
    for (var key in children) {
        if (children[key]) {
            var child = children[key];
            delete children[key];
            child.kill();
        }
    }
}
exports.shutdown = shutdown;
//# sourceMappingURL=fabricator.js.map