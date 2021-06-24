"use strict";
var __values = (this && this.__values) || function(o) {
    var s = typeof Symbol === "function" && Symbol.iterator, m = s && o[s], i = 0;
    if (m) return m.call(o);
    if (o && typeof o.length === "number") return {
        next: function () {
            if (o && i >= o.length) o = void 0;
            return { value: o && o[i++], done: !o };
        }
    };
    throw new TypeError(s ? "Object is not iterable." : "Symbol.iterator is not defined.");
};
var __read = (this && this.__read) || function (o, n) {
    var m = typeof Symbol === "function" && o[Symbol.iterator];
    if (!m) return o;
    var i = m.call(o), r, ar = [], e;
    try {
        while ((n === void 0 || n-- > 0) && !(r = i.next()).done) ar.push(r.value);
    }
    catch (error) { e = { error: error }; }
    finally {
        try {
            if (r && !r.done && (m = i["return"])) m.call(i);
        }
        finally { if (e) throw e.error; }
    }
    return ar;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var path_1 = __importDefault(require("path"));
var chalk_1 = __importDefault(require("chalk"));
var common_1 = require("./common");
var log_1 = require("./log");
var win32 = process.platform === 'win32';
function hasParent(file, records) {
    var dirname = path_1.default.dirname(file);
    // root directory
    if (dirname === file) {
        return false;
    }
    return Boolean(records[dirname]);
}
function purgeTopDirectories(records) {
    // eslint-disable-next-line no-constant-condition
    while (true) {
        var found = false;
        for (var file in records) {
            if (records[file]) {
                var record = records[file];
                var links = record[common_1.STORE_LINKS];
                if (links && links.length === 1) {
                    if (!hasParent(file, records)) {
                        var file2 = path_1.default.join(file, links[0]);
                        var record2 = records[file2];
                        var links2 = record2[common_1.STORE_LINKS];
                        if (links2 && links2.length === 1) {
                            var file3 = path_1.default.join(file2, links2[0]);
                            var record3 = records[file3];
                            var links3 = record3[common_1.STORE_LINKS];
                            if (links3) {
                                delete records[file];
                                log_1.log.debug(chalk_1.default.cyan('Deleting record file :', file));
                                found = true;
                            }
                        }
                    }
                }
            }
        }
        if (!found)
            break;
    }
}
function denominate(records, entrypoint, denominator, symLinks) {
    var e_1, _a;
    var newRecords = {};
    var makeSnap = function (file) {
        var snap = common_1.substituteDenominator(file, denominator);
        if (win32) {
            if (snap.slice(1) === ':')
                snap += '\\';
        }
        else if (snap === '') {
            snap = '/';
        }
        return snap;
    };
    for (var file in records) {
        if (records[file]) {
            var snap = makeSnap(file);
            newRecords[snap] = records[file];
        }
    }
    var tmpSymLinks = symLinks;
    symLinks = {};
    try {
        for (var _b = __values(Object.entries(tmpSymLinks)), _c = _b.next(); !_c.done; _c = _b.next()) {
            var _d = __read(_c.value, 2), key = _d[0], value = _d[1];
            var key1 = makeSnap(key);
            var value1 = makeSnap(value);
            symLinks[key1] = value1;
        }
    }
    catch (e_1_1) { e_1 = { error: e_1_1 }; }
    finally {
        try {
            if (_c && !_c.done && (_a = _b.return)) _a.call(_b);
        }
        finally { if (e_1) throw e_1.error; }
    }
    return {
        records: newRecords,
        entrypoint: common_1.substituteDenominator(entrypoint, denominator),
        symLinks: symLinks,
    };
}
function refiner(records, entrypoint, symLinks) {
    purgeTopDirectories(records);
    var denominator = common_1.retrieveDenominator(Object.keys(records));
    return denominate(records, entrypoint, denominator, symLinks);
}
exports.default = refiner;
//# sourceMappingURL=refiner.js.map