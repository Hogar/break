package com.hogargames.debug {

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import flash.text.TextFormat;

    /**
     * Отправляется при нажатии на кнопку закрытия окна.
     *
     * @eventType flash.events.Event.CLOSE
     */
    [Event(name="close", type="flash.events.Event")]

    /**
     * Класс окна для вывода одиночных сообщений об ошибке.
     *
     * <p>В классе рисуется подложка для текстового поля, кнопка закрытия окна и
     * создается текстовое поле. Также создается небольшой анимационный эффект свечения окна.</p>
     */
    public class ErrorScreen extends Sprite {


        private var box:Sprite = new Sprite ();
        private var errorTF:TextField = new TextField ();
        private var btnClose:Sprite = new Sprite ();

        //disign & animation:
        private var glowFilter:GlowFilter;
        private var redGlowFilter:GlowFilter;
        private var dropShadowFilter:DropShadowFilter;

        private var upAlpha:Boolean = true;

        //sizes:
        private var screenWidth:Number;
        private var screenHeight:Number;

        private const TF_INDENT:int = 5;

        private const ANIMATION_STEP_ALPHA:Number = .004;
        private const ANIMATION_MIN_ALPHA:Number = 0;
        private const ANIMATION_MAX_ALPHA:Number = .5;

        private const GLOW_FILTER_COLOR:uint = 0xee0000;
        private const GLOW_FILTER_COLOR_ALPHA:Number = .1;

        private const RED_GLOW_FILTER_COLOR:uint = 0xff0000;
        private const RED_GLOW_FILTER_BLUR:Number = 12;

        private const CLOSE_BUTTON_COLOR:uint = 0xbb0000;
        private const CLOSE_BUTTON_ALPHA:Number = 1;
        private const CLOSE_BUTTON_STEP:Number = 6;

        private const LOCK_SCREEN_COLOR:uint = 0xffffff;
        private const LOCK_SCREEN_ALPHA:Number = .6;

        private const BACKGROUND_COLOR:uint = 0x999999;
        private const BACKGROUND_ALPHA:Number = 1;

        /**
         * @param message Текст сообщения.
         * @param screenWidth Ширина окна.
         * @param screenHeight Высота окна.
         */
        public function ErrorScreen (message:String = "something wrong", screenWidth:Number = 350, screenHeight:Number = 250) {
            //set filters:
            glowFilter = new GlowFilter ();
            glowFilter.color = GLOW_FILTER_COLOR;
            glowFilter.alpha = GLOW_FILTER_COLOR_ALPHA;

            redGlowFilter = new GlowFilter (RED_GLOW_FILTER_COLOR, 0, RED_GLOW_FILTER_BLUR, RED_GLOW_FILTER_BLUR);
            redGlowFilter.alpha = 0;

            dropShadowFilter = new DropShadowFilter ();

            box.filters = [glowFilter, dropShadowFilter, redGlowFilter];

            //set text field props:
            errorTF.multiline = true;
            errorTF.wordWrap = true;
            var format:TextFormat = new TextFormat ();
            format.align = "center";
            format.size = 14;
            format.font = "Arial";
            format.color = 0xffffff;
            errorTF.defaultTextFormat = format;
            addChild (box);
            box.addChild (errorTF);
            box.addChild (btnClose);
            btnClose.buttonMode = true;
            btnClose.useHandCursor = true;

            //set add to stage listener:
            if (stage) {
                addToStageListener (null);
            }
            else {
                this.addEventListener (Event.ADDED_TO_STAGE, addToStageListener);
            }

            //set message:
            setMessage (message);

            //set sizes:
            setSizes (screenWidth, screenHeight);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Вывод сообщения.
         *
         * @param message Текст сообщения.
         */
        public function setMessage (message:String):void {
            errorTF.htmlText = message;
        }

        /**
         * Установка размеров окна.
         *
         * @param screenWidth Ширина окна
         * @param screenHeight Высота окна
         */
        public function setSizes (screenWidth:Number = 350, screenHeight:Number = 250):void {
            this.screenWidth = screenWidth;
            this.screenHeight = screenHeight;
            draw ();
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function draw ():void {
            var stageW:Number;
            var stageH:Number;
            if (stage) {
                stageW = stage.stageWidth;
                stageH = stage.stageHeight;
            }
            else {
                stageW = screenWidth;
                stageH = screenHeight;
            }
            graphics.clear ();
            graphics.beginFill (LOCK_SCREEN_COLOR, LOCK_SCREEN_ALPHA);
            graphics.drawRect (0, 0, stageW, stageH);
            box.graphics.clear ();
            box.graphics.beginFill (BACKGROUND_COLOR, BACKGROUND_ALPHA);
            box.graphics.drawRoundRect ((stageW - screenWidth) / 2, (stageH - screenHeight) / 2, screenWidth, screenHeight, int (Math.min (screenWidth, screenHeight) / 10));

            errorTF.width = screenWidth - TF_INDENT * 2;
            errorTF.height = Math.min ((errorTF.textHeight + 5), (screenHeight - TF_INDENT * 2));

            errorTF.x = (stageW - errorTF.width) / 2 + TF_INDENT;
            errorTF.y = (stageH - errorTF.height) / 2 + TF_INDENT;

            btnClose.graphics.clear ();
            btnClose.graphics.beginFill (CLOSE_BUTTON_COLOR, CLOSE_BUTTON_ALPHA);
            var step:int = CLOSE_BUTTON_STEP;
            btnClose.graphics.moveTo (0 * step, 1 * step);
            btnClose.graphics.lineTo (0 * step, 1 * step);
            btnClose.graphics.lineTo (1 * step, 0 * step);
            btnClose.graphics.lineTo (2 * step, 1 * step);
            btnClose.graphics.lineTo (3 * step, 0 * step);
            btnClose.graphics.lineTo (4 * step, 1 * step);
            btnClose.graphics.lineTo (3 * step, 2 * step);
            btnClose.graphics.lineTo (4 * step, 3 * step);
            btnClose.graphics.lineTo (3 * step, 4 * step);
            btnClose.graphics.lineTo (2 * step, 3 * step);
            btnClose.graphics.lineTo (1 * step, 4 * step);
            btnClose.graphics.lineTo (0 * step, 3 * step);
            btnClose.graphics.lineTo (1 * step, 2 * step);
            btnClose.graphics.lineTo (0 * step, 1 * step);

            btnClose.x = (stageW - screenWidth) / 2 + screenWidth - btnClose.width + CLOSE_BUTTON_STEP * 2;
            btnClose.y = (stageH - screenHeight) / 2 - btnClose.width + CLOSE_BUTTON_STEP * 2;
        }

        private function enterFrameListener (event:Event):void {
            if (upAlpha) {
                redGlowFilter.alpha += ANIMATION_STEP_ALPHA;
                if (redGlowFilter.alpha >= ANIMATION_MAX_ALPHA) {
                    upAlpha = Boolean (!upAlpha);
                }
            }
            else {
                redGlowFilter.alpha -= ANIMATION_STEP_ALPHA;
                if (redGlowFilter.alpha <= ANIMATION_MIN_ALPHA) {
                    upAlpha = Boolean (!upAlpha);
                }
            }
            box.filters = [glowFilter, dropShadowFilter, redGlowFilter];
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function addToStageListener (event:Event):void {
            draw ();
            this.addEventListener (Event.REMOVED_FROM_STAGE, removeFromStageListener);
            this.addEventListener (Event.ENTER_FRAME, enterFrameListener);
            stage.addEventListener (Event.RESIZE, resizeListener);
            btnClose.addEventListener (MouseEvent.CLICK, clickListener);
        }

        private function removeFromStageListener (event:Event):void {
            this.removeEventListener (Event.REMOVED_FROM_STAGE, removeFromStageListener);
            this.removeEventListener (Event.ENTER_FRAME, enterFrameListener);
            stage.removeEventListener (Event.RESIZE, resizeListener);
            btnClose.removeEventListener (MouseEvent.CLICK, clickListener);
        }

        private function clickListener (event:MouseEvent):void {
            dispatchEvent (new Event (Event.CLOSE));
        }

        private function resizeListener (event:Event):void {
            draw ();
        }

    }

}