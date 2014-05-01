/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 07.09.13
 * Time: 12:10
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.display.animation {

    import com.greensock.TweenLite;

    import flash.events.Event;
    import flash.text.TextField;

    public class TextFieldCountAnimation {

        private var value:int = 0;
        private var previousValue:int = 0;
        private var addStep:Number = 0;
        private var animationCount:int = 0;
        private var delayAnimationCount:int = 0;

        private var tfY:Number;

        private var _tf:TextField;

        private var _numAnimationFrames:int = 12;

        private static const TWEEN_TIME:Number = .2;
        private static const TOP_MARGIN:int = -3;
        private static const TO_SCALE:Number = 1.2;

        public function TextFieldCountAnimation (tf:TextField, numAnimationFrames:int = 12) {
            this._numAnimationFrames = numAnimationFrames;
            this._tf = tf;
            tfY = tf.y;
            if (tf) {
                tf.addEventListener (Event.ENTER_FRAME, enterFrameListener);
            }
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function get tf ():TextField {
            return _tf;
        }

        public function get numAnimationFrames ():int {
            return _numAnimationFrames;
        }

        public function setValue (value:int, numDelayFrames:int = 0, previousValue:Number = NaN):void {
            if (!isNaN (previousValue)) {
                this.value = previousValue;
                tf.text = String (previousValue);
            }
            if (this.value != value) {
                this.previousValue = this.value;
                this.value = value;
                delayAnimationCount = numDelayFrames;
                animationCount = _numAnimationFrames;
                addStep = (value - parseInt (_tf.text)) / _numAnimationFrames;
            }
        }

        public function get currentValue ():int {
            return parseInt (_tf.text);
        }

        public function destroy ():void {
            if (_tf) {
                _tf.removeEventListener (Event.ENTER_FRAME, enterFrameListener)
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function enterFrameListener (event:Event):void {
            if (delayAnimationCount > 0) {
                delayAnimationCount--;
            }
            else {
                if (animationCount > 0) {
                    if (_numAnimationFrames == animationCount) {
                        if (addStep > 0) {
                            TweenLite.to (tf, TWEEN_TIME, {scaleX:TO_SCALE, scaleY:TO_SCALE, y:tfY + TOP_MARGIN});
                        }
                    }
                    animationCount--;
                    var newCoinsValue:int = previousValue + addStep * (_numAnimationFrames - animationCount);
                    if (addStep > 0) {
                        newCoinsValue = Math.min (value, newCoinsValue);
                    }
                    else {
                        newCoinsValue = Math.max (value, newCoinsValue);
                    }
                    _tf.text = String (newCoinsValue);
                }
                else {
                    _tf.text = String (value);
                    TweenLite.to (tf, TWEEN_TIME, {scaleX:1, scaleY:1, y:tfY});
                }
            }
        }
    }
}
