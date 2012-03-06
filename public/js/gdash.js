

function parseUri (str) {
    var o   = parseUri.options,
        m   = o.parser[o.strictMode ? "strict" : "loose"].exec(str),
        uri = {},
        i   = 14;

    while (i--) uri[o.key[i]] = m[i] || "";

    uri[o.q.name] = {};
    uri[o.key[12]].replace(o.q.parser, function ($0, $1, $2) {
        if ($1) uri[o.q.name][$1] = $2;
    });

    return uri;
};

parseUri.options = {
    strictMode: false,
    key: ["source","protocol","authority","userInfo","user","password","host","port","relative","path","directory","file","query","anchor"],
    q:   {
        name:   "queryKey",
        parser: /(?:^|&)([^&=]*)=?([^&]*)/g
    },
    parser: {
        strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/,
        loose:  /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/
    }
};

function constructUri(uri) {
    uri_str = uri.protocol + "://" + uri.host + ":" + uri.port + uri.path + '?';
    for (k in parsedUri.queryKey) {
        uri_str += k + '=' + parsedUri.queryKey[k];
    }
    return uri_str;
}

(function($)
{
    /* get key code */
    function getKeyCode(key)
    {
        //return the key code
        return (key == null) ? event.keyCode : key.keyCode;
    }
     /* get key character */
    function getKey(key)
    {
        //return the key
        return String.fromCharCode(getKeyCode(key)).toLowerCase();
    }

    function inputFinished() {
        // console.log("Input finished. String is '" + string + "'");

        parsedUri = parseUri(window.location.href);
        queryKey = parsedUri.queryKey;

        matches = inputString.match(/^(\d+)d/);
        if (matches) {
            queryKey['from'] = '-' + matches[1] + 'days';
            parsedUri.queryKey = queryKey;
            window.location = constructUri(parsedUri);
        }

        matches = inputString.match(/^(\d+)h/);
        if (matches) {
            queryKey['from'] = '-' + matches[1] + 'hours';
            parsedUri.queryKey = queryKey;
            window.location = constructUri(parsedUri);
        }

        matches = inputString.match(/^(\d+)w/);
        if (matches) {
            queryKey['from'] = '-' + matches[1] + 'weeks';
            parsedUri.queryKey = queryKey;
            window.location = constructUri(parsedUri);
        }

        matches = inputString.match(/^(\d+)m/);
        if (matches) {
            queryKey['from'] = '-' + matches[1] + 'minutes';
            parsedUri.queryKey = queryKey;
            window.location = constructUri(parsedUri);
        }

        matches = inputString.match(/^0/);
        if (matches) {
            delete queryKey['from'];
            parsedUri.queryKey = queryKey;
            window.location = constructUri(parsedUri);
        }

        inputString = "";
    }

    var inputString="";
    var inputTimeout = null;

   $(document).ready(function()
    {
        $(document).keydown(function (eventObj)
        {
            inputString = inputString + getKey(eventObj);
            clearTimeout(inputTimeout);
            inputTimeout = setTimeout(inputFinished, 600);
        });
    });
 }(jQuery));