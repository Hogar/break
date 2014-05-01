package com.hogargames.app.popups {

    import com.hogargames.app.popups.events.PopUpEvent;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.Event;

    /**
     * Менеджер всплывающих окон.
     */
    public class PopUpContainer {

        private var container:DisplayObjectContainer;
        private var popUpsContainer:Sprite = new Sprite ();
        private var lockScreenArea:Sprite;
        private var lockPopUpArea:Sprite = new Sprite ();

        private var popUps:Vector.<DisplayObject> = new Vector.<DisplayObject> ();

        /**
         * @param container Контейнер для отображения попапов.
         */
        public function PopUpContainer (container:DisplayObjectContainer):void {
            //validation:
            if (container == null) {
                BaseAppManager.getInstance ().outputError ("Error! PopUpManager container is null!");
            }

            //remove old listeners:
            if (this.container) {
                this.container.removeEventListener (Event.ADDED_TO_STAGE, addedToStageListener);
                if (this.container.stage) {
                    this.container.stage.removeEventListener (Event.RESIZE, resizeListener);
                }
            }

            //init elements:
            this.container = container;
            container.addChild (lockPopUpArea);
            container.addChild (popUpsContainer);
            lockScreenArea = null;

            //add resize listener:
            if (container.stage) {
                container.stage.addEventListener (Event.RESIZE, resizeListener);
            }
            else {
                container.addEventListener (Event.ADDED_TO_STAGE, addedToStageListener);
            }
        }

        /**
         * Добавление (отображение) попапа.
         *
         * @param popUp Попап для отображения.
         */
        public function showPopUp (popUp:DisplayObject):void {
            popUp.addEventListener (PopUpEvent.CLOSE, closePopUpListener);
            popUpsContainer.addChild (popUp);
            if (popUps.indexOf (popUp) == -1) {
                popUps.push (popUp);
            }
            redrawPopUpsLock ();
        }

        /**
         * Удаление (скрытие) попапа.
         *
         * @param popUp Попап для удаления.
         */
        public function hidePopUp (popUp:DisplayObject):void {
            if (popUps.indexOf (popUp) != -1) {
                destroyPopUp (popUp)
            }
        }

        /**
         * Блокировка контейнера, используется для блокировки экрана приложения.
         */
        public function lockScreen ():void {
            if (lockScreenArea != null) {
                return;
            }
            lockScreenArea = new Sprite ();
            container.addChild (lockScreenArea);
            redrawScreenLock ();
        }

        /**
         * Разблокировка контейнера, используется для разблокировки экрана приложения после установленной блокировки.
         */
        public function unlockScreen ():void {
            if (lockScreenArea != null) {
                lockScreenArea.graphics.clear ();
                if (container.contains (lockScreenArea)) {
                    container.removeChild (lockScreenArea);
                }
                lockScreenArea = null;
            }
        }

        /**
         * Определяет, все ли попапы закрыты.
         */
        public function get isEmpty ():Boolean {
            return (popUps.length == 0 && lockScreenArea == null);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function destroyPopUp (popUp:DisplayObject):void {
            var popUpIndex:int = popUps.indexOf (popUp);
            if (popUpIndex != -1) {
                popUps.splice (popUpIndex, 1);
            }
            if (popUp.parent != null) {
                popUp.parent.removeChild (popUp);
            }
            redrawPopUpsLock ();
        }

        private function redrawPopUpsLock ():void {
            lockPopUpArea.graphics.clear ();
            if (popUps.length > 0) {
                lockPopUpArea.graphics.beginFill (0x00ff00, 0);
                if (container.stage) {
                    lockPopUpArea.graphics.drawRect (0, 0, container.stage.stageWidth, container.stage.stageHeight);
                }
                lockPopUpArea.graphics.endFill ();
            }
        }

        private function redrawScreenLock ():void {
            if (lockScreenArea != null) {
                lockScreenArea.graphics.clear ();
                lockScreenArea.graphics.beginFill (0x00ff00, 0);
                if (container.stage) {
                    lockScreenArea.graphics.drawRect (0, 0, container.stage.stageWidth, container.stage.stageHeight);
                }
                lockScreenArea.graphics.endFill ();
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function closePopUpListener (event:Event):void {
            destroyPopUp (DisplayObject (event.currentTarget));
        }

        private function addedToStageListener (event:Event):void {
            container.removeEventListener (Event.ADDED_TO_STAGE, addedToStageListener);
            container.stage.addEventListener (Event.RESIZE, resizeListener);
        }

        private function resizeListener (event:Event):void {
            redrawScreenLock ();
            redrawPopUpsLock ();
        }

    }
}