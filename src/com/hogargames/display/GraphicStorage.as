package com.hogargames.display {

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.display.Sprite;

    /**
     * Базовый класс для элементов, инициализируемых графическим ресурсом.
     *
     * <p>Основной задачей класса является инициализация графическим ресурсом и
     * присвоение его отдельных элементов переменным класса.</p>
     */
    public class GraphicStorage extends Sprite {

        private var _mc:MovieClip;

        /**
         * Элемент определяющий размеры.
         * <p>Если в используемом для инициализации класса MovieClip'е присутвует ребенок с именем <code>GraphicStorage.MC_HIT</code>,
         * то этот ребенок присваивается переменной hit.
         * В этом случае размеры переменной hit будут переопределять свойства класса
         * <code>height</code> и <code>width</code>.</p>
         *
         * #see #MC_HIT
         */
        protected var hit:Sprite;

        public static const MC_HIT:String = "mcHit";

        /**
         * @param mc Графический ресурс
         */
        public function GraphicStorage (mc:MovieClip):void {
            initGraphic (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Инициализация графическим ресурсом.
         *
         * @param mc Графический ресурс
         * @throw Error Отправляется, если <code>mc</code> равен <code>null</code>.
         */
        protected function initGraphic (mc:MovieClip):void {
            if (mc == null) {
                throw new Error ("Init null MovieClip.");
            }
            if (_mc != null) {
                destroy ();
            }
            _mc = mc;
            hit = Sprite (mc.getChildByName (MC_HIT));
            var mcParent:DisplayObjectContainer = mc.parent;
            var index:int = 0;
            if (mcParent != null && !(mcParent is Loader)) {
                index = mcParent.getChildIndex (mc);
                mcParent.addChildAt (this, index);
            }
            addChild (mc);
            imitateGraphicProperties ();
            initGraphicElements ();
        }

        /**
         * Инициализация отдельных элементов графического ресурса.
         */
        protected function initGraphicElements ():void {

        }

        /**
         * Графический ресурс.
         */
        public function get mc ():MovieClip {
            return _mc;
        }

        /**
         * Деактивация слушателей.
         */
        public function destroy ():void {
            if (_mc != null && contains (_mc)) {
                removeChild (_mc);
            }
            _mc = null;
        }

        /**
         * Переопределяется высотой переменной hit, в случае, если она не равна <code>null</code>.
         */
        override public function get height ():Number {
            if (hit != null) {
                return hit.height;
            }
            return super.height;
        }

        /**
         * Переопределяется шириной переменной hit, в случае, если она не равна <code>null</code>.
         */
        override public function get width ():Number {
            if (hit != null) {
                return hit.width;
            }
            return super.width;
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        /**
         * Получение элемента графического ресурса по названию.
         *
         * @param name Имя элемента.
         * @param parentMc Объект для поиска. Если <code>parentMc</code> равен <code>null</code>, поиск производится в <code>mc</code>.
         * @return Элемент графического ресурса.
         *
         * @throw Error Отправляется, если элемент с таким именем не найден (равен <code>null</code>).
         *
         * @see #mc
         */
        protected function getElement (name:String, parentMc:DisplayObjectContainer = null):* {
            if (parentMc == null) {
                parentMc = mc;
            }
            var child:DisplayObject = parentMc.getChildByName (name);
            if (child == null) {
                throw new Error ("get null element");
            }
            return child;
        }

        /**
         * Присвоение свойств графического ресурса экземпляру класса, сброс этих свойств у графического ресурса.
         */
        protected function imitateGraphicProperties ():void {
            //set properties by mc properties:
            this.x = mc.x;
            this.y = mc.y;
            this.alpha = mc.alpha;
            this.blendMode = mc.blendMode;
            this.buttonMode = mc.buttonMode;
            this.useHandCursor = mc.useHandCursor;
            this.cacheAsBitmap = mc.cacheAsBitmap;
            this.filters = mc.filters;
            this.mask = mc.mask;
            this.rotation = mc.rotation;
            this.scaleX = mc.scaleX;
            this.scaleY = mc.scaleY;
            this.tabEnabled = mc.tabEnabled;
            this.tabIndex = mc.tabIndex;
            this.name = mc.name;

            //set basic mc properties:
            var sprite:Sprite = new Sprite ();
            mc.x = sprite.x;
            mc.y = sprite.y;
            mc.alpha = sprite.alpha;
            mc.blendMode = sprite.blendMode;
            mc.buttonMode = sprite.buttonMode;
            mc.useHandCursor = sprite.useHandCursor;
            mc.cacheAsBitmap = sprite.cacheAsBitmap;
            mc.filters = sprite.filters;
            mc.mask = sprite.mask;
            mc.rotation = sprite.rotation;
            mc.scaleX = sprite.scaleX;
            mc.scaleY = sprite.scaleY;
            mc.tabEnabled = sprite.tabEnabled;
            mc.tabIndex = sprite.tabIndex;
        }

    }

}