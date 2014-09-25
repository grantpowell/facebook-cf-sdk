/**
* FacebookHelper
*
* Static component with helper functions
*/
component {

    /**
    * Takes a string and a secret key and returns the HmacSHA256-hashed value.
    *
    * @value.hint The input value to be hashed
    * @secretKey.hint Secret key to be used
    * @return Hashed value in ISO-8859-1 encoding
    */
    public string function hashHmacSHA256(required string value, required string secretKey) {
        if (secretKey == "") {
            throw(errorcode="Invalid secretKey", message="Invalid secretKey (cannot be empty)", type=" Security");
        }
        var secretKeySpec = createObject("java", "javax.crypto.spec.SecretKeySpec" ).init(arguments.secretKey.getBytes(), "HmacSHA256");
        var mac = createObject("java", "javax.crypto.Mac").getInstance(secretKeySpec.getAlgorithm());
        mac.init(secretKeySpec);

        return toString(mac.doFinal(arguments.value.getBytes()), "ISO-8859-1");
	}

    /**
    * Takes a struct and converts it into a querystring-like format.
    *
    * @params.hint Input struct
    * @return Querystring-formatted version of the struct's content
    */
	public string function structToQueryString(required struct params) {
        var queryString = "";
        var delim1 = "=";
        var delim2 = "&";

        for (key in params) {
            queryString = ListAppend(queryString, URLEncodedFormat(LCase(key)) & delim1 & URLEncodedFormat(params[key]), delim2);
        }

        return queryString;
    }

    /**
    * Takes a querystring and converts it into a struct
    *
    * @str.hint Input querystring - can contain elements such as ...&abc&def&efg=657...
    * @return Struct
    */
    public struct function parseString(required string str) {
        var parsedString = {};
        var delim1 = "=";
        var delim2 = "&";
        var result = {};
        var params = ListToArray(arguments.str,delim2);

        for (var i=1; i <= ArrayLen(params); i=i+1) {
            if (ListLen(params[i],delim1) == 2) {
                structInsert(result, listGetAt(params[i],1,delim1), listGetAt(params[i],2,delim1));
            }
            else if (ListLen(params[i],delim1) == 1) {
                structInsert(result, listGetAt(params[i],1,delim1), "");
            }
        }

        return result;
    }

    /**
    * Converts Epoch time (Unix) into local Date object
    *
    * @dateSeconds.hint Epoch (Unix) seconds
    * @return DateTime String
    */
    public string function convertEpochTime(required numeric dateSeconds) {
        var startDate = createdatetime('1970','01','01','00','00','00');

        if (!IsNumeric(arguments.dateSeconds)) {
            return "";
        }

        return dateConvert("utc2Local", dateadd('s', arguments.dateSeconds, startDate));
    }

    /**
    * Converts now() into Epoch time (Unix)
    *
    * @return numeric Epoch seconds
    */
    public numeric function epochTime(date dati = now()) {
        var startDate = createdatetime('1970','01','01','00','00','00');
        var datetimeNow = dateConvert("local2Utc",arguments.dati);

        return datediff('s', startdate, datetimeNow);
    }


}
