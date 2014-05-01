/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 04.02.14
 * Time: 6:40
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.tutorial {

    import breakdance.GlobalConstants;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.core.ui.overlay.OverlayManager;
    import breakdance.template.Template;
    import breakdance.tutorial.TutorialManager;
    import breakdance.tutorial.TutorialStep;
    import breakdance.tutorial.events.TutorialStepEvent;
    import breakdance.ui.commons.buttons.ButtonWithText;
    import breakdance.ui.commons.buttons.DebugButton;

    import com.greensock.TweenLite;
    import com.hogargames.Orientation;
    import com.hogargames.display.GraphicStorage;
    import com.hogargames.errors.SingletonError;
    import com.hogargames.utils.StringUtilities;

    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.text.TextField;

    public class TutorialOverlay extends GraphicStorage implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        CONFIG::debug {
            private var btnSkip:DebugButton;
        }

        private static var _instance:TutorialOverlay;

        private var mcArrow:MovieClip;
        private var mcMessage:Sprite;
        private var tf:TextField;
        private var mcBackground:Sprite;
        private var mcBackgroundStartY:Number;
        private var mcBackgroundStartHeight:Number;
        private var tfStartY:Number;
        private var tfStartHeight:Number;
        private var btnNext:ButtonWithText;

        private var lockingBackground:Shape = new Shape ();//Фон для ограничения рабочей области;
        private var hidingBackground:Shape = new Shape ();//Фон для визуального выделения;

        private var tutorialManager:TutorialManager;

        private static const BACKGROUND_COLOR:uint = 0x000000;
        private static const BACKGROUND_ALPHA:Number = .7;
        private static const ELLIPSE:int = 6;

        private static const SETTING_BUTTON_X:int = 739;
        private static const SETTING_BUTTON_Y:int = 570;
        private static const SETTING_BUTTON_WIDTH:int = 56;
        private static const SETTING_BUTTON_HEIGHT:int = 45;

        public function TutorialOverlay (key:SingletonKey = null) {
            tutorialManager = TutorialManager.instance;
            super (Template.createSymbol (Template.TUTORIAL));
            addChildAt (hidingBackground, 0);
            addChildAt (lockingBackground, 0);
            if (!key) {
                throw new SingletonError ();
            }
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        static public function get instance ():TutorialOverlay {
            if (!_instance) {
                _instance = new TutorialOverlay (new SingletonKey ());
            }
            return _instance;
        }

        public function setTexts ():void {
            if (btnNext) {
                var text:String = "";
                var currentStep:String = tutorialManager.currentStep;
                if (!StringUtilities.isNotValueString (currentStep)) {
                    if (currentStep == TutorialStep.FINISH) {
                        text = textsManager.getText ("complete");
                    }
                    else {
                        text = textsManager.getText ("next");
                    }
                    btnNext.text = text;
                }
            }
        }

        override public function destroy ():void {
            tutorialManager.removeEventListener (TutorialStepEvent.SET_TUTORIAL_STEP, setTutorialStepListener);
            if (btnNext) {
                btnNext.destroy ();
                btnNext = null;
            }
            CONFIG::debug {
                if (btnSkip) {
                    if (contains (btnSkip)) {
                        removeChild (btnSkip);
                    }
                    btnSkip.removeEventListener (MouseEvent.CLICK, clickListener_skip);
                    btnSkip.destroy ();
                    btnSkip = null;
                }
            }
            textsManager.removeTextContainer (this);
            super.destroy ();
        }

        public function show ():void {
            OverlayManager.instance.addOverlay (this, OverlayManager.TUTORIAL_LAYER_PRIORITY);
        }

        public function hide ():void {
            OverlayManager.instance.removeOverlay (this);
        }

        public function showNextButton ():void {
            btnNext.visible = true;
        }

        public function hideNextButton ():void {
            btnNext.visible = false;
        }

        /**
         * Показать затемняющий экран.
         */
        public function showHidingBackground (showingAreas:Vector.<Rectangle> = null, showControls:Boolean = true):void {

            var INDENT:int = 20;
            var ELLIPSE_2:int = 160;

            lockingBackground.graphics.clear ();
            hidingBackground.graphics.clear ();
            lockingBackground.graphics.beginFill (0x000000, 0);
            hidingBackground.graphics.beginFill (BACKGROUND_COLOR, BACKGROUND_ALPHA);
            lockingBackground.graphics.drawRect (0, 0, GlobalConstants.APP_WIDTH, GlobalConstants.APP_HEIGHT);
            hidingBackground.graphics.drawRect (0, 0, GlobalConstants.APP_WIDTH, GlobalConstants.APP_HEIGHT);
            if (showingAreas) {
                for (var i:int = 0; i < showingAreas.length; i++) {
                    var area:Rectangle = showingAreas [i];
                    lockingBackground.graphics.drawRoundRect (area.x, area.y, area.width, area.height, ELLIPSE, ELLIPSE);
                    hidingBackground.graphics.drawRoundRect (area.x - INDENT, area.y - INDENT, area.width + INDENT * 2, area.height + INDENT * 2, ELLIPSE_2, ELLIPSE_2);
                }
            }
            //Даём доступ к кнопкам звука, музыки и переключению языков:
            if (showControls) {
                lockingBackground.graphics.drawRoundRect (SETTING_BUTTON_X, SETTING_BUTTON_Y, SETTING_BUTTON_WIDTH, SETTING_BUTTON_HEIGHT, ELLIPSE, ELLIPSE);
                hidingBackground.graphics.drawRoundRect (SETTING_BUTTON_X, SETTING_BUTTON_Y, SETTING_BUTTON_WIDTH, SETTING_BUTTON_HEIGHT, ELLIPSE, ELLIPSE);
            }

            lockingBackground.graphics.endFill ();
            hidingBackground.graphics.endFill ();
        }

        public function backgroundUnvisible ():void {
            hidingBackground.alpha = 0;
            mcArrow.alpha = 0;
        }

        public function backgroundVisible ():void {
            hidingBackground.alpha = 1;
            mcArrow.alpha = 1;
        }

        /**
         * Позиционировать стрелку.
         */
        public function positionArrow (arrowX:int = NaN, arrowY:int = NaN, orientation:String = Orientation.RIGHT):void {
            showArrow ();
            if (!isNaN (arrowX)) {
                mcArrow.x = arrowX;
            }
            if (!isNaN (arrowY)) {
                mcArrow.y = arrowY;
            }
            if (orientation == Orientation.LEFT) {
                mcArrow.scaleX = -1;
            }
            else {
                mcArrow.scaleX = 1;
            }
        }

        /**
         * Показать стрелку.
         */
        public function showArrow ():void {
            mcArrow.visible = true;
        }

        /**
         * Показать стрелку.
         */
        public function showArrowWithDelay (delay:Number):void {
            mcArrow.visible = false;
            TweenLite.to (mcArrow, 0, {visible:true, delay:delay});
        }

        /**
         * Скрыть стрелку.
         */
        public function hideArrow ():void {
            mcArrow.visible = false;
        }

        /**
         * Показать текст.
         */
        public function setText (text:String = ""):void {
            if (!text) {
                text = "";
            }

            mcMessage.visible = (text != "");

            tf.htmlText = text;

//            tf.height = Math.ceil (Math.min (tfStartHeight, tf.textHeight + 4));
//            tf.y = tfStartY + (tfStartHeight - tf.height);
//            mcBackground.height = (mcBackgroundStartHeight - tfStartHeight) + tf.height;
//            mcBackground.y = mcBackgroundStartY + (mcBackgroundStartHeight - mcBackground.height);
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mcArrow = getElement ("mcArrow");
            mcMessage = getElement ("mcMessage");
            tf = getElement ("tf", mcMessage);
            mcBackground = getElement ("mcBackground", mcMessage);

            btnNext = new ButtonWithText (mc ["btnNext"]);

            tf.mouseEnabled = false;
            tfStartY = tf.y;
            tfStartHeight = tf.height;
            mcBackgroundStartY = mcBackground.y;
            mcBackgroundStartHeight = mcBackground.height;

            tutorialManager.addEventListener (TutorialStepEvent.SET_TUTORIAL_STEP, setTutorialStepListener);

            btnNext.addEventListener (MouseEvent.CLICK, clickListener);

            CONFIG::debug {
                btnSkip = new DebugButton ();
                btnSkip.text = "ПРОПУСТИТЬ";
                addChild (btnSkip);
                btnSkip.x = 20;
                btnSkip.y = 600;
                btnSkip.addEventListener (MouseEvent.CLICK, clickListener_skip);
            }

            textsManager.addTextContainer (this);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function setTutorialStepListener (event:TutorialStepEvent):void {
            setTexts ();
        }

        private function clickListener (event:MouseEvent):void {
            tutorialManager.nextStep ();
        }

        CONFIG::debug {
            private function clickListener_skip (event:MouseEvent):void {
                tutorialManager.skip ();
            }
        }

    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}
