"use strict";
/* eslint-disable operator-linebreak */
/* eslint-disable prefer-const */
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
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
Object.defineProperty(exports, "__esModule", { value: true });
exports.detect = exports.parse = exports.visitor_USESCWD = exports.visitor_MALFORMED = exports.visitor_NONLITERAL = exports.visitor_SUCCESSFUL = void 0;
var escodegen_1 = require("escodegen");
// eslint-disable-next-line import/no-extraneous-dependencies
var babelTypes = __importStar(require("@babel/types"));
var babel = __importStar(require("@babel/parser"));
var common_1 = require("./common");
function isLiteral(
// eslint-disable-next-line @typescript-eslint/no-explicit-any
node) {
    // TODO: this function is a lie and can probably be better
    // I was using babelTypes.isStringLiteral but that broke a bunch of tests
    return (node &&
        (node.type === 'Literal' ||
            (node.type === 'TemplateLiteral' && node.expressions.length === 0)));
}
function getLiteralValue(node) {
    if (node.type === 'TemplateLiteral') {
        return node.quasis[0].value.raw;
    }
    return node.value;
}
function reconstructSpecifiers(specs) {
    var e_1, _a, e_2, _b;
    if (!specs || !specs.length) {
        return '';
    }
    var defaults = [];
    try {
        for (var specs_1 = __values(specs), specs_1_1 = specs_1.next(); !specs_1_1.done; specs_1_1 = specs_1.next()) {
            var spec = specs_1_1.value;
            if (babelTypes.isImportDefaultSpecifier(spec)) {
                defaults.push(spec.local.name);
            }
        }
    }
    catch (e_1_1) { e_1 = { error: e_1_1 }; }
    finally {
        try {
            if (specs_1_1 && !specs_1_1.done && (_a = specs_1.return)) _a.call(specs_1);
        }
        finally { if (e_1) throw e_1.error; }
    }
    var nonDefaults = [];
    try {
        for (var specs_2 = __values(specs), specs_2_1 = specs_2.next(); !specs_2_1.done; specs_2_1 = specs_2.next()) {
            var spec = specs_2_1.value;
            if (babelTypes.isImportSpecifier(spec)) {
                var importedName = babelTypes.isIdentifier(spec.imported)
                    ? spec.imported.name
                    : spec.imported.value;
                if (spec.local.name === importedName) {
                    nonDefaults.push(spec.local.name);
                }
                else {
                    nonDefaults.push(importedName + " as " + spec.local.name);
                }
            }
        }
    }
    catch (e_2_1) { e_2 = { error: e_2_1 }; }
    finally {
        try {
            if (specs_2_1 && !specs_2_1.done && (_b = specs_2.return)) _b.call(specs_2);
        }
        finally { if (e_2) throw e_2.error; }
    }
    if (nonDefaults.length) {
        defaults.push("{ " + nonDefaults.join(', ') + " }");
    }
    return defaults.join(', ');
}
function reconstruct(node) {
    var v = escodegen_1.generate(node).replace(/\n/g, '');
    var v2;
    // eslint-disable-next-line no-constant-condition
    while (true) {
        v2 = v.replace(/\[ /g, '[').replace(/ \]/g, ']').replace(/ {2}/g, ' ');
        if (v2 === v) {
            break;
        }
        v = v2;
    }
    return v2;
}
function forge(pattern, was) {
    return pattern
        .replace('{c1}', ', ')
        .replace('{v1}', "\"" + was.v1 + "\"")
        .replace('{c2}', was.v2 ? ', ' : '')
        .replace('{v2}', was.v2 ? "\"" + was.v2 + "\"" : '')
        .replace('{c3}', was.v3 ? ' from ' : '')
        .replace('{v3}', was.v3 ? was.v3 : '');
}
function valid2(v2) {
    return (v2 === undefined ||
        v2 === null ||
        v2 === 'must-exclude' ||
        v2 === 'may-exclude');
}
function visitor_REQUIRE_RESOLVE(n) {
    if (!babelTypes.isCallExpression(n)) {
        return null;
    }
    if (!babelTypes.isMemberExpression(n.callee)) {
        return null;
    }
    var ci = n.callee.object.type === 'Identifier' &&
        n.callee.object.name === 'require' &&
        n.callee.property.type === 'Identifier' &&
        n.callee.property.name === 'resolve';
    if (!ci) {
        return null;
    }
    if (!n.arguments || !isLiteral(n.arguments[0])) {
        return null;
    }
    return {
        v1: getLiteralValue(n.arguments[0]),
        v2: isLiteral(n.arguments[1]) ? getLiteralValue(n.arguments[1]) : null,
    };
}
function visitor_REQUIRE(n) {
    if (!babelTypes.isCallExpression(n)) {
        return null;
    }
    if (!babelTypes.isIdentifier(n.callee)) {
        return null;
    }
    if (n.callee.name !== 'require') {
        return null;
    }
    if (!n.arguments || !isLiteral(n.arguments[0])) {
        return null;
    }
    return {
        v1: getLiteralValue(n.arguments[0]),
        v2: isLiteral(n.arguments[1]) ? getLiteralValue(n.arguments[1]) : null,
    };
}
function visitor_IMPORT(n) {
    if (!babelTypes.isImportDeclaration(n)) {
        return null;
    }
    return { v1: n.source.value, v3: reconstructSpecifiers(n.specifiers) };
}
function visitor_PATH_JOIN(n) {
    if (!babelTypes.isCallExpression(n)) {
        return null;
    }
    if (!babelTypes.isMemberExpression(n.callee)) {
        return null;
    }
    var ci = n.callee.object &&
        n.callee.object.type === 'Identifier' &&
        n.callee.object.name === 'path' &&
        n.callee.property &&
        n.callee.property.type === 'Identifier' &&
        n.callee.property.name === 'join';
    if (!ci) {
        return null;
    }
    var dn = n.arguments[0] &&
        n.arguments[0].type === 'Identifier' &&
        n.arguments[0].name === '__dirname';
    if (!dn) {
        return null;
    }
    var f = n.arguments && isLiteral(n.arguments[1]) && n.arguments.length === 2; // TODO concat them
    if (!f) {
        return null;
    }
    return { v1: getLiteralValue(n.arguments[1]) };
}
function visitor_SUCCESSFUL(node, test) {
    if (test === void 0) { test = false; }
    var was = visitor_REQUIRE_RESOLVE(node);
    if (was) {
        if (test) {
            return forge('require.resolve({v1}{c2}{v2})', was);
        }
        if (!valid2(was.v2)) {
            return null;
        }
        return {
            alias: was.v1,
            aliasType: common_1.ALIAS_AS_RESOLVABLE,
            mustExclude: was.v2 === 'must-exclude',
            mayExclude: was.v2 === 'may-exclude',
        };
    }
    was = visitor_REQUIRE(node);
    if (was) {
        if (test) {
            return forge('require({v1}{c2}{v2})', was);
        }
        if (!valid2(was.v2)) {
            return null;
        }
        return {
            alias: was.v1,
            aliasType: common_1.ALIAS_AS_RESOLVABLE,
            mustExclude: was.v2 === 'must-exclude',
            mayExclude: was.v2 === 'may-exclude',
        };
    }
    was = visitor_IMPORT(node);
    if (was) {
        if (test) {
            return forge('import {v3}{c3}{v1}', was);
        }
        return { alias: was.v1, aliasType: common_1.ALIAS_AS_RESOLVABLE };
    }
    was = visitor_PATH_JOIN(node);
    if (was) {
        if (test) {
            return forge('path.join(__dirname{c1}{v1})', was);
        }
        return { alias: was.v1, aliasType: common_1.ALIAS_AS_RELATIVE, mayExclude: false };
    }
    return null;
}
exports.visitor_SUCCESSFUL = visitor_SUCCESSFUL;
function nonLiteralRequireResolve(n) {
    if (!babelTypes.isCallExpression(n)) {
        return null;
    }
    if (!babelTypes.isMemberExpression(n.callee)) {
        return null;
    }
    var ci = n.callee.object.type === 'Identifier' &&
        n.callee.object.name === 'require' &&
        n.callee.property.type === 'Identifier' &&
        n.callee.property.name === 'resolve';
    if (!ci) {
        return null;
    }
    if (isLiteral(n.arguments[0])) {
        return null;
    }
    var m = n.arguments[1];
    if (!m) {
        return { v1: reconstruct(n.arguments[0]) };
    }
    if (!isLiteral(n.arguments[1])) {
        return null;
    }
    return {
        v1: reconstruct(n.arguments[0]),
        v2: getLiteralValue(n.arguments[1]),
    };
}
function nonLiteralRequire(n) {
    if (!babelTypes.isCallExpression(n)) {
        return null;
    }
    if (!babelTypes.isIdentifier(n.callee)) {
        return null;
    }
    if (n.callee.name !== 'require') {
        return null;
    }
    if (isLiteral(n.arguments[0])) {
        return null;
    }
    var m = n.arguments[1];
    if (!m) {
        return { v1: reconstruct(n.arguments[0]) };
    }
    if (!isLiteral(n.arguments[1])) {
        return null;
    }
    return {
        v1: reconstruct(n.arguments[0]),
        v2: getLiteralValue(n.arguments[1]),
    };
}
function visitor_NONLITERAL(n) {
    var was = nonLiteralRequireResolve(n) || nonLiteralRequire(n);
    if (was) {
        if (!valid2(was.v2)) {
            return null;
        }
        return {
            alias: was.v1,
            mustExclude: was.v2 === 'must-exclude',
            mayExclude: was.v2 === 'may-exclude',
        };
    }
    return null;
}
exports.visitor_NONLITERAL = visitor_NONLITERAL;
function isRequire(n) {
    if (!babelTypes.isCallExpression(n)) {
        return null;
    }
    if (!babelTypes.isIdentifier(n.callee)) {
        return null;
    }
    if (n.callee.name !== 'require') {
        return null;
    }
    var f = n.arguments && n.arguments[0];
    if (!f) {
        return null;
    }
    return { v1: reconstruct(n.arguments[0]) };
}
function isRequireResolve(n) {
    if (!babelTypes.isCallExpression(n)) {
        return null;
    }
    if (!babelTypes.isMemberExpression(n.callee)) {
        return null;
    }
    var ci = n.callee.object.type === 'Identifier' &&
        n.callee.object.name === 'require' &&
        n.callee.property.type === 'Identifier' &&
        n.callee.property.name === 'resolve';
    if (!ci) {
        return null;
    }
    var f = n.type === 'CallExpression' && n.arguments && n.arguments[0];
    if (!f) {
        return null;
    }
    return { v1: reconstruct(n.arguments[0]) };
}
function visitor_MALFORMED(n) {
    var was = isRequireResolve(n) || isRequire(n);
    if (was) {
        return { alias: was.v1 };
    }
    return null;
}
exports.visitor_MALFORMED = visitor_MALFORMED;
function visitor_USESCWD(n) {
    // eslint-disable-line camelcase
    if (!babelTypes.isCallExpression(n)) {
        return null;
    }
    if (!babelTypes.isMemberExpression(n.callee)) {
        return null;
    }
    var ci = n.callee.object.type === 'Identifier' &&
        n.callee.object.name === 'path' &&
        n.callee.property.type === 'Identifier' &&
        n.callee.property.name === 'resolve';
    if (!ci) {
        return null;
    }
    var was = { v1: n.arguments.map(reconstruct).join(', ') };
    if (was) {
        return { alias: was.v1 };
    }
    return null;
}
exports.visitor_USESCWD = visitor_USESCWD;
function traverse(ast, visitor) {
    // modified esprima-walk to support
    // visitor return value and "trying" flag
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    var stack = [[ast, false]];
    for (var i = 0; i < stack.length; i += 1) {
        var item = stack[i];
        var _a = __read(item, 1), node = _a[0];
        if (node) {
            var trying = item[1] || babelTypes.isTryStatement(node);
            if (visitor(node, trying)) {
                for (var key in node) {
                    if (node[key]) {
                        var child = node[key];
                        if (child instanceof Array) {
                            for (var j = 0; j < child.length; j += 1) {
                                stack.push([child[j], trying]);
                            }
                        }
                        else if (child && typeof child.type === 'string') {
                            stack.push([child, trying]);
                        }
                    }
                }
            }
        }
    }
}
function parse(body) {
    return babel.parse(body, {
        allowImportExportEverywhere: true,
        allowReturnOutsideFunction: true,
        plugins: ['estree', 'bigInt', 'classPrivateProperties', 'classProperties'],
    });
}
exports.parse = parse;
function detect(body, visitor) {
    var json = parse(body);
    if (!json) {
        return;
    }
    traverse(json, visitor);
}
exports.detect = detect;
//# sourceMappingURL=detector.js.map