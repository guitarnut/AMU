var sovrn = sovrn || {};

sovrn.utils = (function () {

    //This is a list of ad-server patterns that we are able to extract the 'real' pub URL from. @see extractLoc()
    var ad_url_regxs = [
        {
            dmn: "?(apr|ap|www)?\\.lijit\\.(com|dev)",
            pat: ".*([?]|&)(loc)=([^\"&;, ]+)"
        },
        {
            dmn: "?googleusercontent\\.com",
            pat: ".*?u=([^\"&;, ]+)"
        },
        {
            dmn: "webcache.googleusercontent.com/search",
            pat: "[?]q=cache:[^:]+:([^\"&;, \\+]+)"
        },
        {
            dmn: "?doubleclick.*?",
            pat: "(url|admu|click|dc_ref)=([^\"&;, ]+)"
        },
        {
            dmn: "?yieldmanager\\.com",
            pat: ".*?==,,([^,]+)"
        },
        {
            dmn: "?yieldmanager\\.com",
            pat: ".*?pub_url=(\\$)?([^\"&;, ]+)"
        },
        {
            dmn: "?openx.*",
            pat: "([?]|&)loc=([^\"&;, ]+)"
        },
        {
            dmn: "?admeld.com.*",
            pat: "?url=([^\"&;, ]+)"
        },
        {
            dmn: "?adnxs.com.*",
            pat: "?referrer=([^\"&;, ]+)"
        },
        {
            dmn: "?ro2\\.biz.*",
            pat: "?rf=([^\"&;, ]+)"
        },
        {
            dmn: "?ads.micklemedia\\.com",
            pat: ".*?&r=([^\"&;, ]+)"
        },
        {
            dmn: "?c\\.lqw\\.me.*?",
            pat: "\"url\":\"([^\"& ]+)"
        },
        {
            dmn: "?mb\\.zam\\.com",
            pat: ".*?tr=([^\"&;, ]+)"
        },
        {
            dmn: "?rubiconproject\\.com",
            pat: ".*?rf=([^\"&;, ]+)"
        },
        {
            dmn: "?moocowads\\.com",
            pat: ".*?url=([^\"&;, ]+)"
        },
        {
            dmn: "?pubmatic\\.com",
            pat: ".*?([?]|&)(refurl|kadpageurl)=([^\"&;, ]+)"
        },
        {
            dmn: "?tagcade\\.com",
            pat: ".*?([?]|&)src=([^\"&;, ]+)"
        },
        {
            dmn: "?burstdirectads\\.com",
            pat: ".*?([?]|&)(pub_url|src)=([^\"&;, ]+)"
        },
        {
            dmn: "?localpages\\.com",
            pat: ".*?([?]|&)(pageUrl)=([^\"&;, ]+)"
        },
        {
            dmn: "?888media\\.net",
            pat: ".*?([?]|&)(page_address|uadr)=([^\"&;, ]+)"
        }
    ];

    var dupe = 0;

    var http_rgx = "^http(s)?:\\/\\/.*";

    var other_url_regxs = [{
        dmn: "",
        pat: "^{(.*)}$"
    }];

    function isInIframe() {
        return self !== top;
    }

    // we're not going to have this config object for video
    function isAsync() {
        return false;
    }

    function urlCheck(url) {
        var result = true;
        if (!url ||
            url.indexOf('.') === -1 ||
            url.length < 4 ||
            url.indexOf('file:') === 0 ||
            url.indexOf('javascript:') >= 0 ||
            url.indexOf('data:') >= 0
        ) {
            result = false;
        }

        //If a URI is not syntactically valid, decoding it will throw an exception
        try {
            decodeURI(url);
        } catch (e) {
            result = false;
        }
        return result;
    }

    function extractLoc(input_url) {
        var pats, ue_pat, h, i, exec_result, out, pre, match = '',
            http_enc, d, url_regxs;
        if (!input_url) {
            return '';
        }
        http_enc = /^http(s)?%/i;
        d = decodeURIComponent;
        url_regxs = [ad_url_regxs, other_url_regxs];

        try {
            // some urls have encoded query strings while the host/path is not
            try {
                pats = [
                    "/^http(s)?:\/\/.*?adnxs.com\/bounce.*referrer.*/"
                ];
                for (i = 0; i < pats.length; i++) {
                    if (new RegExp(pats[i]).test(input_url)) {
                        try {
                            input_url = d(input_url);
                        } catch (e) {
                            reportError(e);
                        }
                        break;
                    }
                }
            } catch (ex) {
                reportError(ex);
            }

            //Deal with URL-encoded locations
            while (http_enc.test(input_url)) {
                try {
                    input_url = d(input_url);
                } catch (e) {
                    reportError(e);
                }
            }

            for (h = 0; h < url_regxs.length; h++) {
                for (i = 0; i < url_regxs[h].length; i++) {
                    pre = url_regxs[h][i]['dmn'] ? http_rgx : ''; //prepend the 'http://' regex matcher if the 'dmn' prop is not empty
                    ue_pat = new RegExp(pre + url_regxs[h][i]['dmn'] + url_regxs[h][i]['pat'], 'i'); //Case insensitive
                    exec_result = ue_pat.exec(input_url);
                    if (exec_result && exec_result.length >= 1) {
                        match = d(exec_result[exec_result.length - 1]);
                        break;
                    }
                }
            }
        } catch (exx) {
            reportError(exx);
        }
        out = extractLoc(match); // Run recursively
        return urlCheck(out) ? out : input_url;
    }

    function getUserLoc() {
        var loc, href = document.location.href;

        try {
            //We're in an iframe or async tag is in iframe; attempt to determine referrer
            if (isInIframe()) {
                //console.log("iframe detected");
                loc = getTopParentLoc();
                if (document.referrer) {
                    //console.log("checking document.referrer");
                    loc = loc || document.referrer;
                } //single iframe
            }
            if (!urlCheck(loc)) {
                //console.log("url check failed, using document.location.href");
                loc = href;
            }
            loc = extractLoc(loc);
        } catch (e) {
            reportError('getLoc failure', e);
        }
        loc = urlCheck(loc) ? loc : href;

        //TODO: this is not SSL compatible
        return 'http://' + loc.replace('http://', '').substr(0, 1024);
    }

    function getTopParentLoc() {
        var loc = '';
        try {
            if (window['$sf']) {
                loc = getCurrentDocument().referrer;
            } else {
                var window_loc = getCurrentDocument().location;
                if (window_loc && window_loc.ancestorOrigins && window_loc.ancestorOrigins.length > 1) {
                    var ancestors = window_loc.ancestorOrigins;
                    loc = ancestors[ancestors.length - 1];
                } else if (window_loc && window_loc.hasOwnProperty('ancestorOrigins') === false) {
                    loc = getNonWebKitTopParentLoc();
                }
            }
        } catch (e) {
            reportError('getTopParentLoc failure', e);
        }
        return loc;
    }

    function getCurrentDocument() {
        return document;
    }

    function getNonWebKitTopParentLoc() {
        var undefinedLoc = '',
            referrerLoc = '',
            currentWindow;
        do {
            currentWindow = currentWindow ? currentWindow.parent : window;
            try {
                referrerLoc = currentWindow.document.referrer;
            } catch (securityException) {
                return referrerLoc; //this will always hit when it reaches the top parent.
            }
        }
        while (currentWindow !== window.top);
        return undefinedLoc;
    }

    // ---------------------------------------------------------------- //
    // ------- logging --------------- //
    // ---------------------------------------------------------------- //

    function log(m, o) {
        try {
            if (console.log) {
                (o) ? console.log("%c" + m, "background-color: #FFDA91", o) : console.log("%c" + m, "background-color: #FFDA91");
            }
        } catch (e) {
            console.log("Unable to log message: " + e.toString);
        }

    }

    // ---------------------------------------------------------------- //
    // ------- client info --------------- //
    // ---------------------------------------------------------------- //

    function referrer() {
        try {
            return (document) ? document.referrer : "";
        } catch (e) {
            return "";
        }
    }

    // ---------------------------------------------------------------- //
    // ------- beacon call --------------- //
    // ---------------------------------------------------------------- //

    // builds beacon url with required beacon params
    function fireBeacon(uri) {
        log('formatting beacon uri');

        if (addDOMElement(window.document.body, createDOMElement('iframe', {src: uri}))) {
            log('Beacon sent');
        } else {
            log('Beacon failed');
        }
    }

    // ---------------------------------------------------------------- //
    // ------- dom --------------- //
    // ---------------------------------------------------------------- //

    function createDOMElement(type, attributes) {
        var element = null;

        try {
            element = document.createElement(type);

            if (attributes) {
                Object.keys(attributes).map(function (val) {
                    element.setAttribute(val, attributes[val]);
                });
            }

        } catch (e) {
            log('could not create DOM element ' + type);
        }

        return element;
    }

    function addDOMElement(target, el) {

        this.el = el;
        this.target = target;

        try {
            this.target.appendChild(this.el);
            return true;
        } catch (err) {
            log('failed to attach element to ', this.target + err);
            return false;
        }

    }

    return {
        loc: getUserLoc,
        referrer: referrer,
        beacon: fireBeacon,
        log: log
    }

})();