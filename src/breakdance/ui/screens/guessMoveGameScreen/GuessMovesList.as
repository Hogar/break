package breakdance.ui.screens.guessMoveGameScreen {

    import breakdance.data.danceMoves.DanceMoveSubType;
    import breakdance.data.danceMoves.DanceMoveType;
    import breakdance.data.danceMoves.DanceMoveTypeCollection;
    import breakdance.ui.screens.guessMoveGameScreen.events.SelectDanceMoveTypeEvent;

    import com.greensock.TweenLite;
    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class GuessMovesList extends GraphicStorage {

        private var mcSelector:Sprite;
        private var itemsContainer:Sprite;
        private var items:Vector.<GuessMovesListItem>;
        private var trueDanceMoveType:DanceMoveType;
        private var lock:Boolean = false;
        private static const NUM_ITEMS:int = 8;
        private static const DISTANCE_Y:int = 36;
        private static const SELECTOR_TWEEN_TIME:Number = 0.3;
        private static const SHOW_ITEMS_DELAY:Number = 0.03;
        private static const SHOW_ITEMS_TWEEN_TIME:Number = 0.05;

        public function GuessMovesList (mc:MovieClip) {
            itemsContainer = new Sprite ();
            items = new Vector.<GuessMovesListItem>;
            super (mc);

        }

        public function init (danceMoveType:DanceMoveType):void {
            var toY:* = 0;
            clear ();
            trueDanceMoveType = danceMoveType;
            var totalDanceMoveTypesList:Vector.<DanceMoveType> = DanceMoveTypeCollection.instance.getDanceMoveTypesOfSubtype (DanceMoveSubType.NORMAL);
            totalDanceMoveTypesList = totalDanceMoveTypesList.concat (DanceMoveTypeCollection.instance.getDanceMoveTypesOfSubtype (DanceMoveSubType.START));
            var randomDanceMoveTypesList:Vector.<DanceMoveType> = new Vector.<DanceMoveType>;
            while (randomDanceMoveTypesList.length < NUM_ITEMS) {
                var randomIndex:int = Math.round (Math.random () * (totalDanceMoveTypesList.length - 1));
                var randomDanceMoveType:DanceMoveType = totalDanceMoveTypesList[randomIndex];
                if (randomDanceMoveTypesList.indexOf (randomDanceMoveType) == -1) {
                }
                if (randomDanceMoveType != danceMoveType) {
                    randomDanceMoveTypesList.push (randomDanceMoveType);
                }
            }
            randomIndex = Math.round (Math.random () * (randomDanceMoveTypesList.length - 1));
            randomDanceMoveTypesList[randomIndex] = danceMoveType;
            for (var i:int = 0; i < randomDanceMoveTypesList.length; i++) {
                var item:GuessMovesListItem = new GuessMovesListItem ();
                item.addEventListener (MouseEvent.CLICK, clickListener);
                item.addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                item.addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
                toY = i * DISTANCE_Y;
                item.y = toY - 20;
                item.danceMoveType = randomDanceMoveTypesList[i];
                item.alpha = 0;
                TweenLite.to (item, SHOW_ITEMS_TWEEN_TIME, {alpha: 1, y: toY, delay: SHOW_ITEMS_DELAY * i});
                itemsContainer.addChild (item);
                items.push (item);
            }
            lock = false;
        }

        public function clear ():void {
            var guessMovesListItem:GuessMovesListItem = null;
            for (var i:int = 0; i < items.length; i++) {

                guessMovesListItem = items[i];
                if (itemsContainer.contains (guessMovesListItem)) {
                    itemsContainer.removeChild (guessMovesListItem);
                }
                guessMovesListItem.removeEventListener (MouseEvent.CLICK, clickListener);
                guessMovesListItem.removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
                guessMovesListItem.removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            }
            items = new Vector.<GuessMovesListItem>;
            TweenLite.killTweensOf (mcSelector);
            mcSelector.alpha = 0;
            mcSelector.y = -DISTANCE_Y;

        }

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            mc.addChild (itemsContainer);
            mcSelector = getElement ("mcSelector");

        }

        private function clickListener (event:MouseEvent):void {
            if (!lock) {
                var item:GuessMovesListItem = GuessMovesListItem (event.currentTarget);
                var danceMoveType:DanceMoveType = item.danceMoveType;
                if (danceMoveType) {
                    if (danceMoveType == trueDanceMoveType) {
                        item.trueMarker ();
                    }
                    else {
                        item.falseMarker ();
                        for (var i:int; i < items.length; i++) {
                            var currentItem:GuessMovesListItem = items[i];
                            if (currentItem.danceMoveType == trueDanceMoveType) {
                                currentItem.selectedAsTrue = true;
                            }
                        }
                    }
                    lock = true;
                    dispatchEvent (new SelectDanceMoveTypeEvent (danceMoveType));
                }
            }

        }

        private function rollOverListener (event:MouseEvent):void {
            if (!lock) {
                var index:int = items.indexOf (event.currentTarget);
                var toY:int = index * DISTANCE_Y;
                TweenLite.to (mcSelector, SELECTOR_TWEEN_TIME, {y: toY, alpha: 1});
            }

        }

        private function rollOutListener (event:MouseEvent):void {
            if (!lock) {
            }

        }

    }
}
