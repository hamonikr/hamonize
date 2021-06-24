/*!
 * MockJax - jQuery Plugin to Mock Ajax requests
 *
 * Version:  1.6.2
 * Released:
 * Home:   https://github.com/jakerella/jquery-mockjax
 * Author:   Jonathan Sharp (http://jdsharp.com)
 * License:  MIT,GPL
 *
 * Copyright (c) 2014 appendTo, Jordan Kasper
 * NOTE: This repository was taken over by Jordan Kasper (@jakerella) October, 2014
 *
 * Dual licensed under the MIT or GPL licenses.
 * http://opensource.org/licenses/MIT OR http://www.gnu.org/licenses/gpl-2.0.html
 */
(function(f) {
	var d = f.ajax,
		e = [],
		l = [],
		u = [],
		n = /=\?(&|$)/,
		p = (new Date()).getTime();
	function m(w) {
		if (window.DOMParser == undefined && window.ActiveXObject) {
			DOMParser = function() {};
			DOMParser.prototype.parseFromString = function(C) {
				var B = new ActiveXObject("Microsoft.XMLDOM");
				B.async = "false";B.loadXML(C);return B
			}
		}
		try {
			var y = (new DOMParser()).parseFromString(w, "text/xml");
			if (f.isXMLDoc(y)) {
				var x = f("parsererror", y);
				if (x.length == 1) {
					throw new Error("Error: " + f(y).text())
				}
			} else {
				throw new Error("Unable to parse XML")
			}
			return y
		} catch (z) {
			var A = (z.name == undefined ? z : z.name + ": " + z.message);
			f(document).trigger("xmlParseError", [ A ]);return undefined
		}
	}
	function g(w, x) {
		var y = true;
		if (typeof x === "string") {
			return f.isFunction(w.test) ? w.test(x) : w == x
		}
		f.each(w, function(z) {
			if (x[z] === undefined) {
				y = false;return y
			} else {
				if (typeof x[z] === "object" && x[z] !== null) {
					if (y && f.isArray(x[z])) {
						y = f.isArray(w[z]) && x[z].length === w[z].length
					}
					y = y && g(w[z], x[z])
				} else {
					if (w[z] && f.isFunction(w[z].test)) {
						y = y && w[z].test(x[z])
					} else {
						y = y && (w[z] == x[z])
					}
				}
			}
		});return y
	}
	function b(w, x) {
		return w[x] === f.mockjaxSettings[x]
	}
	function s(w, y) {
		if (f.isFunction(w)) {
			return w(y)
		}
		if (f.isFunction(w.url.test)) {
			if (!w.url.test(y.url)) {
				return null
			}
		} else {
			var x = w.url.indexOf("*");
			if (w.url !== y.url && x === -1 || !new RegExp(w.url.replace(/[-[\]{}()+?.,\\^$|#\s]/g, "\\$&").replace(/\*/g, ".+")).test(y.url)) {
				return null
			}
		}
		if (w.data) {
			if (!y.data || !g(w.data, y.data)) {
				return null
			}
		}
		if (w && w.type && w.type.toLowerCase() != y.type.toLowerCase()) {
			return null
		}
		return w
	}
	function v(y) {
		if (f.isArray(y)) {
			var x = y[0];
			var w = y[1];
			return (typeof x === "number" && typeof w === "number") ? Math.floor(Math.random() * (w - x)) + x : null
		} else {
			return (typeof y === "number") ? y : null
		}
	}
	function h(x, z, w) {
		var y = (function(A) {
			return function() {
				return (function() {
					this.status = x.status;
					this.statusText = x.statusText;
					this.readyState = 1;
					var B = function() {
						this.readyState = 4;
						var C;
						if (z.dataType == "json" && (typeof x.responseText == "object")) {
							this.responseText = JSON.stringify(x.responseText)
						} else {
							if (z.dataType == "xml") {
								if (typeof x.responseXML == "string") {
									this.responseXML = m(x.responseXML);
									this.responseText = x.responseXML
								} else {
									this.responseXML = x.responseXML
								}
							} else {
								if (typeof x.responseText === "object" && x.responseText !== null) {
									x.contentType = "application/json";
									this.responseText = JSON.stringify(x.responseText)
								} else {
									this.responseText = x.responseText
								}
							}
						}
						if (typeof x.status == "number" || typeof x.status == "string") {
							this.status = x.status
						}
						if (typeof x.statusText === "string") {
							this.statusText = x.statusText
						}
						C = this.onreadystatechange || this.onload;
						if (f.isFunction(C)) {
							if (x.isTimeout) {
								this.status = -1
							}
							C.call(this, x.isTimeout ? "timeout" : undefined)
						} else {
							if (x.isTimeout) {
								this.status = -1
							}
						}
					};
					if (f.isFunction(x.response)) {
						if (x.response.length === 2) {
							x.response(w, function() {
								B.call(A)
							});return
						} else {
							x.response(w)
						}
					}
					B.call(A)
				}).apply(A)
			}
		})(this);
		if (x.proxy) {
			d({
				global : false,
				url : x.proxy,
				type : x.proxyType,
				data : x.data,
				dataType : z.dataType === "script" ? "text/plain" : z.dataType,
				complete : function(A) {
					x.responseXML = A.responseXML;
					x.responseText = A.responseText;
					if (b(x, "status")) {
						x.status = A.status
					}
					if (b(x, "statusText")) {
						x.statusText = A.statusText
					}
					this.responseTimer = setTimeout(y, v(x.responseTime) || 0)
				}
			})
		} else {
			if (z.async === false) {
				y()
			} else {
				this.responseTimer = setTimeout(y, v(x.responseTime) || 50)
			}
		}
	}
	function i(y, z, w, x) {
		y = f.extend(true, {}, f.mockjaxSettings, y);
		if (typeof y.headers === "undefined") {
			y.headers = {}
		}
		if (typeof z.headers === "undefined") {
			z.headers = {}
		}
		if (y.contentType) {
			y.headers["content-type"] = y.contentType
		}
		return {
			status : y.status,
			statusText : y.statusText,
			readyState : 1,
			open : function() {},
			send : function() {
				x.fired = true;h.call(this, y, z, w)
			},
			abort : function() {
				clearTimeout(this.responseTimer)
			},
			setRequestHeader : function(B, A) {
				z.headers[B] = A
			},
			getResponseHeader : function(A) {
				if (y.headers && y.headers[A]) {
					return y.headers[A]
				} else {
					if (A.toLowerCase() == "last-modified") {
						return y.lastModified || (new Date()).toString()
					} else {
						if (A.toLowerCase() == "etag") {
							return y.etag || ""
						} else {
							if (A.toLowerCase() == "content-type") {
								return y.contentType || "text/plain"
							}
						}
					}
				}
			},
			getAllResponseHeaders : function() {
				var A = "";
				if (y.contentType) {
					y.headers["Content-Type"] = y.contentType
				}
				f.each(y.headers, function(C, B) {
					A += C + ": " + B + "\n"
				});return A
			}
		}
	}
	function k(C, A, w) {
		c(C);
		C.dataType = "json";
		if (C.data && n.test(C.data) || n.test(C.url)) {
			q(C, A, w);
			var y = /^(\w+:)?\/\/([^\/?#]+)/,
				B = y.exec(C.url),
				z = B && (B[1] && B[1] !== location.protocol || B[2] !== location.host);
			C.dataType = "script";
			if (C.type.toUpperCase() === "GET" && z) {
				var x = o(C, A, w);
				if (x) {
					return x
				} else {
					return true
				}
			}
		}
		return null
	}
	function c(w) {
		if (w.type.toUpperCase() === "GET") {
			if (!n.test(w.url)) {
				w.url += (/\?/.test(w.url) ? "&" : "?") + (w.jsonp || "callback") + "=?"
			}
		} else {
			if (!w.data || !n.test(w.data)) {
				w.data = (w.data ? w.data + "&" : "") + (w.jsonp || "callback") + "=?"
			}
		}
	}
	function o(z, y, w) {
		var x = w && w.context || z,
			A = null;
		if (y.response && f.isFunction(y.response)) {
			y.response(w)
		} else {
			if (typeof y.responseText === "object") {
				f.globalEval("(" + JSON.stringify(y.responseText) + ")")
			} else {
				f.globalEval("(" + y.responseText + ")")
			}
		}
		setTimeout(function() {
			j(z, x, y);r(z, x, y)
		}, v(y.responseTime) || 0);
		if (f.Deferred) {
			A = new f.Deferred();
			if (typeof y.responseText == "object") {
				A.resolveWith(x, [ y.responseText ])
			} else {
				A.resolveWith(x, [ f.parseJSON(y.responseText) ])
			}
		}
		return A
	}
	function q(z, y, w) {
		var x = w && w.context || z;
		var A = z.jsonpCallback || ("jsonp" + p++);
		if (z.data) {
			z.data = (z.data + "").replace(n, "=" + A + "$1")
		}
		z.url = z.url.replace(n, "=" + A + "$1");
		window[A] = window[A] || function(B) {
			data = B;j(z, x, y);r(z, x, y);
			window[A] = undefined;try {
				delete window[A]
			} catch (C) {}
		}
	}
	function j(y, w, x) {
		if (y.success) {
			y.success.call(w, x.responseText || "", status, {})
		}
		if (y.global) {
			(y.context ? f(y.context) : f.event).trigger("ajaxSuccess", [ {}, y ])
		}
	}
	function r(x, w) {
		if (x.complete) {
			x.complete.call(w, {}, status)
		}
		if (x.global) {
			(x.context ? f(x.context) : f.event).trigger("ajaxComplete", [ {}, x ])
		}
		if (x.global && !--f.active) {
			f.event.trigger("ajaxStop")
		}
	}
	function a(y, w) {
		var C,
			B,
			A,
			z;
		if (typeof y === "object") {
			w = y;
			y = undefined
		} else {
			w = w || {};
			w.url = y
		}
		B = f.extend(true, {}, f.ajaxSettings, w);
		z = function(F, E) {
			var D = w[F.toLowerCase()];
			return function() {
				if (f.isFunction(D)) {
					D.apply(this, [].slice.call(arguments))
				}
				E["onAfter" + F]()
			}
		};
		for (var x = 0; x < e.length; x++) {
			if (!e[x]) {
				continue
			}
			A = s(e[x], B);
			if (!A) {
				continue
			}
			l.push(B);f.mockjaxSettings.log(A, B);
			if (B.dataType && B.dataType.toUpperCase() === "JSONP") {
				if( (C = k(B, A, w)) ) {
					return C
				}
			}
			A.cache = B.cache;
			A.timeout = B.timeout;
			A.global = B.global;
			if (A.isTimeout) {
				if (A.responseTime > 1) {
					w.timeout = A.responseTime - 1
				} else {
					A.responseTime = 2;
					w.timeout = 1
				}
				A.isTimeout = false
			}
			if (f.isFunction(A.onAfterSuccess)) {
				w.success = z("Success", A)
			}
			if (f.isFunction(A.onAfterError)) {
				w.error = z("Error", A)
			}
			if (f.isFunction(A.onAfterComplete)) {
				w.complete = z("Complete", A)
			}
			t(A, w);(function(F, G, D, E) {
				C = d.call(f, f.extend(true, {}, D, {
					xhr : function() {
						return i(F, G, D, E)
					}
				}))
			})(A, B, w, e[x]);return C
		}
		u.push(w);
		if (f.mockjaxSettings.throwUnmocked === true) {
			throw new Error("AJAX not mocked: " + w.url)
		} else {
			return d.apply(f, [ w ])
		}
	}
	function t(z, x) {
		if (!(z.url instanceof RegExp)) {
			return
		}
		if (!z.hasOwnProperty("urlParams")) {
			return
		}
		var w = z.url.exec(x.url);
		if (w.length === 1) {
			return
		}
		w.shift();var A = 0,
			y = w.length,
			C = z.urlParams.length,
			D = Math.min(y, C),
			B = {};
		for (A; A < D; A++) {
			var E = z.urlParams[A];
			B[E] = w[A]
		}
		x.urlParams = B
	}
	f.extend({
		ajax : a
	});
	f.mockjaxSettings = {
		log : function(y, A) {
			if (y.logging === false || (typeof y.logging === "undefined" && f.mockjaxSettings.logging === false)) {
				return
			}
			if (window.console && console.log) {
				var x = "MOCK " + A.type.toUpperCase() + ": " + A.url;
				var w = f.extend({}, A);
				if (typeof console.log === "function") {
					console.log(x, w)
				} else {
					try {
						console.log(x + " " + JSON.stringify(w))
					} catch (z) {
						console.log(x)
					}
				}
			}
		},
		logging : true,
		status : 200,
		statusText : "OK",
		responseTime : 500,
		isTimeout : false,
		throwUnmocked : false,
		contentType : "text/plain",
		response : "",
		responseText : "",
		responseXML : "",
		proxy : "",
		proxyType : "GET",
		lastModified : null,
		etag : "",
		headers : {
			etag : "IJF@H#@923uf8023hFO@I#H#",
			"content-type" : "text/plain"
		}
	};
	f.mockjax = function(x) {
		var w = e.length;
		e[w] = x;return w
	};
	f.mockjax.clear = function(w) {
		if (arguments.length == 1) {
			e[w] = null
		} else {
			e = []
		}
		l = [];
		u = []
	};
	f.mockjaxClear = function(w) {
		window.console && window.console.warn && window.console.warn("DEPRECATED: The $.mockjaxClear() method has been deprecated in 1.6.0. Please use $.mockjax.clear() as the older function will be removed soon!");f.mockjax.clear()
	};
	f.mockjax.handler = function(w) {
		if (arguments.length == 1) {
			return e[w]
		}
	};
	f.mockjax.mockedAjaxCalls = function() {
		return l
	};
	f.mockjax.unfiredHandlers = function() {
		var y = [];
		for (var x = 0, w = e.length; x < w; x++) {
			var z = e[x];
			if (z !== null && !z.fired) {
				y.push(z)
			}
		}
		return y
	};
	f.mockjax.unmockedAjaxCalls = function() {
		return u
	}
})(jQuery);