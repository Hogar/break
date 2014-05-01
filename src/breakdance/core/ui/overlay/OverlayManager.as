package breakdance.core.ui.overlay {

    import breakdance.GlobalVariables;

    import com.hogargames.errors.SingletonError;

    import flash.display.DisplayObject;
    import flash.display.Sprite;

    public class OverlayManager {

        // top layer is layer with biggest priority
        static public const DEV_UI_PRIORITY:uint = 200;
        static public const TOOLTIP_LAYER_PRIORITY:uint = 160;
        static public const SETTINGS_LAYER_PRIORITY:uint = 157;
        static public const ERROR_LAYER_PRIORITY:uint = 156;
        static public const TRANSACTION_LAYER_PRIORITY:uint = 155;
        static public const GIFT_LAYER_PRIORITY:uint = 145;
        static public const TUTORIAL_LAYER_PRIORITY:uint = 145;
        static public const DIALOG_LAYER_PRIORITY:uint = 140;
        static public const DIALOG_BACK_LAYER_PRIORITY:uint = 135;
        static public const UI_PRIORITY:uint = 100;
        static public const ELEMENT_PRIORITY:uint = 50;
        static public const SCREEN_PRIORITY:uint = 10;

        private var _overlays:Array = []

        private var _container:Sprite;

        static private var _instance:OverlayManager;

        public function OverlayManager (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }

            _container = new Sprite ();
        }

        public static function get instance ():OverlayManager {
            if (!_instance) {
                _instance = new OverlayManager (new SingletonKey ());
            }
            return _instance;
        }

        public function init ():void {
            GlobalVariables.stage.addChild (_container);
        }

        public function addOverlay (object:DisplayObject, priority:uint):void {
            if (!object) {
                return;
            }

            var overlay:OverlayDescription = null;
            var otherOverlay:OverlayDescription;
            var i:int;

            // ищем, нет ли оверлея в списках
            for (i = 0; i < _overlays.length; i++) {
                otherOverlay = _overlays[i];
                if (object == otherOverlay.object) {
                    // если оверлей уже есть, временно вынимаем его
                    //trace('addOverlay existing');

                    overlay = otherOverlay;
                    _overlays.splice (i, 1);
                    break;
                }
            }

            // если оверлея нет в списках, добавляем его
            if (!overlay) {
                //trace('addOverlay new');

                overlay = new OverlayDescription (object, priority);
                _container.addChild (object);
            }

            // ставим оверлей в правильное место
            for (i = 0; i < _overlays.length; i++) {
                otherOverlay = _overlays[i];

                if (priority < otherOverlay.priority) {
                    _overlays.splice (i, 0, overlay);
                    overlay = null;
                    break;
                }
            }

            // если так и не положили никуда (у объекта приоритет выше всех) - помещаем его в топ
            if (overlay)
                _overlays.push (overlay);


            // выстраиваем оверлеи в правильном порядке
            while (_container.numChildren > 0) {
                _container.removeChildAt (0);
            }
            for (i = 0; i < _overlays.length; i++) {
                overlay = _overlays[i];
                _container.addChild (overlay.object);
            }
        }

        public function removeOverlay (object:DisplayObject):void {
            //trace('removeOverlay');
            var overlay:OverlayDescription;
            for (var i:int = 0; i < _overlays.length; i++) {
                overlay = _overlays[i];
                if (overlay.object == object) {
                    _container.removeChild (object);
                    overlay.object = null;
                    _overlays.splice (i, 1);
                    break;
                }
            }
        }

    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}