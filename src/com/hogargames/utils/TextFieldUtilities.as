/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 12.07.13
 * Time: 22:09
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.utils {

    import flash.text.TextField;
    import flash.text.TextFormat;

    public class TextFieldUtilities {

        public function TextFieldUtilities () {

        }

        public static function setBold (tf:TextField):void {
            var textFormat:TextFormat = tf.getTextFormat ();
            textFormat.bold = true;
            tf.setTextFormat (textFormat);
            tf.defaultTextFormat = textFormat;
        }
    }
}
