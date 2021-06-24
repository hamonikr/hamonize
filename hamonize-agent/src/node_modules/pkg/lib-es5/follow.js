"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.follow = exports.natives = void 0;
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
var resolve_1 = require("resolve");
var assert_1 = __importDefault(require("assert"));
var fs_1 = __importDefault(require("fs"));
var path_1 = __importDefault(require("path"));
var common_1 = require("./common");
Object.keys(resolve_1.core).forEach(function (key) {
    // 'resolve' hardcodes the list to host's one, but i need
    // to be able to allow 'worker_threads' (target 12) on host 8
    assert_1.default(typeof resolve_1.core[key] === 'boolean');
    resolve_1.core[key] = true;
});
exports.natives = resolve_1.core;
var PROOF = 'a-proof-that-main-is-captured.js';
function parentDirectoriesContain(parent, directory) {
    var currentParent = parent;
    while (true) {
        if (currentParent === directory) {
            return true;
        }
        var newParent = path_1.default.dirname(currentParent);
        if (newParent === currentParent) {
            return false;
        }
        currentParent = newParent;
    }
}
function follow(x, opts) {
    // TODO async version
    return new Promise(function (resolve) {
        resolve(resolve_1.sync(x, {
            basedir: opts.basedir,
            extensions: opts.extensions,
            isFile: function (file) {
                if (opts.ignoreFile &&
                    path_1.default.join(path_1.default.dirname(opts.ignoreFile), PROOF) === file) {
                    return true;
                }
                var stat;
                try {
                    stat = fs_1.default.statSync(file);
                }
                catch (e) {
                    if (e && (e.code === 'ENOENT' || e.code === 'ENOTDIR'))
                        return false;
                    throw e;
                }
                return stat.isFile() || stat.isFIFO();
            },
            isDirectory: function (directory) {
                if (opts.ignoreFile &&
                    parentDirectoriesContain(opts.ignoreFile, directory)) {
                    return false;
                }
                var stat;
                try {
                    stat = fs_1.default.statSync(directory);
                }
                catch (e) {
                    if (e && (e.code === 'ENOENT' || e.code === 'ENOTDIR')) {
                        return false;
                    }
                    throw e;
                }
                return stat.isDirectory();
            },
            readFileSync: function (file) {
                if (opts.ignoreFile && opts.ignoreFile === file) {
                    return Buffer.from("{\"main\":\"" + PROOF + "\"}");
                }
                if (opts.readFile) {
                    opts.readFile(file);
                }
                return fs_1.default.readFileSync(file);
            },
            packageFilter: function (config, base) {
                if (opts.packageFilter) {
                    opts.packageFilter(config, base);
                }
                return config;
            },
            /** function to synchronously resolve a potential symlink to its real path */
            // realpathSync?: (file: string) => string;
            realpathSync: function (file) {
                var file2 = common_1.toNormalizedRealPath(file);
                return file2;
            },
        }));
    });
}
exports.follow = follow;
//# sourceMappingURL=follow.js.map