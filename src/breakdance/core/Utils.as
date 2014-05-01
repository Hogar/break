package breakdance.core {

    /**
     * ...
     * @author Alexey Stashin
     */
    public class Utils {

        public static function random (min:Number, max:Number):Number {
            return Math.random () * (max - min) + min;
        }

        public static function randomInt (min:int, max:int):int {
            return Math.floor (Math.random () * (max - min) + min);
        }

        public static function trim (s:String):String {
            return s.replace (/^\s+|\s+$/gs, '');
        }

        public static function getFileExtension (filename:String):String {
            var paramsStart:int = filename.lastIndexOf ('?');
            if (paramsStart >= 0)
                return filename.substring (filename.lastIndexOf ("."), paramsStart);
            else
                return filename.substring (filename.lastIndexOf ("."));
        }

        public static function getXmlAttr (node:XML, attr:String, defaultValue:String):String {
            return (node.attribute (attr).length () == 0) ? defaultValue : node.attribute (attr);
        }

        public static function timeToString (timestamp:Number):String {
            var time:Number = timestamp / 1000.0;
            var h:int = Math.floor (time / 3600);
            var m:int = Math.floor (time / 60) - h * 60;
            var s:int = time - m * 60 - h * 3600;

            var str:String = "";
            //str += (h < 10) ? "0" + h : h;
            str += (m < 10) ? "0" + m : "" + m;
            str += (s < 10) ? ":0" + s : ":" + s;

            return str;
        }

        public static function valueBasedString (value:int, str1:String, str2to4:String, str5more:String):String {
            switch (value % 10) {
                case 1:
                    return str1;
                case 2:
                case 3:
                case 4:
                    return str2to4;
                default:
                    return str5more;
            }
        }

        public static function shuffleArray (arr:Array):Array {
            return [].concat (arr).sort (randomSort);

            function randomSort (a:*, b:*):Number {
                var value:Number = Math.random ();
                var six:Number = Math.round (value * 100000);
                if (value == 0 || Math.floor (six / 2) * 2 == six) {
                    return -1;
                }
                else {
                    return 1;
                }
            }
        }

        public static function parseObject (sourceStr:String):Object {
            if (sourceStr == "") {
                return {};
            }

            var resultObject:Object = {};

            var array:Array = Utils.trim (sourceStr.replace (";", ",")).split (",");
            var id:String;
            var tempArray:Array;
            for each(var str:String in array) {
                if (str.indexOf (":") >= 0) {
                    tempArray = str.split (":");
                    id = Utils.trim (tempArray[0]);
                    resultObject[id] = parseInt (Utils.trim (tempArray[1]));
                }
                else {
                    id = Utils.trim (str);
                    resultObject[id] = 1;
                }
            }

            return resultObject;
        }
    }

}