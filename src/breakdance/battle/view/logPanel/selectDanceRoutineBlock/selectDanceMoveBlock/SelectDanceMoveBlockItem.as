/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 26.09.13
 * Time: 11:47
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view.logPanel.selectDanceRoutineBlock.selectDanceMoveBlock {

    import breakdance.BreakdanceApp;
    import breakdance.battle.data.BattleDanceMoveData;
    import breakdance.battle.data.BattleDataUtils;
    import breakdance.battle.model.BattleUtils;
    import breakdance.battle.model.IBattlePlayer;
    import breakdance.battle.view.logPanel.selectDanceRoutineBlock.*;
    import breakdance.data.danceMoves.DanceMoveType;

    import com.greensock.TweenLite;

    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    /**
     * Элемент блока выбора танц. движений для обычных танц. движений.
     */
    public class SelectDanceMoveBlockItem extends SelectPanelItem {

        protected var _player:IBattlePlayer;//Ссылка на модель игрока в бою.

        private var _battleDanceMoveData:BattleDanceMoveData;

        private var selector:Sprite = new Sprite ();
        private var _showHighlight:Boolean = true;

        private const TWEEN_TIME:Number = .6;
        private const ITEM_HEIGHT:int = 19;
        private const SELECTOR_COLOR:uint = 0xffffff;
        private const SELECTOR_ALPHA:Number = .3;
        private const SELECTOR_WIDTH:int = 216;
        private const SELECTION_ELLIPSE_SIZE:int = 24;

        private static const POSITION_POINT_X:int = 113;
        private static const POSITION_POINT_Y:int = 16;

        public function SelectDanceMoveBlockItem () {
            selector.graphics.beginFill (SELECTOR_COLOR, SELECTOR_ALPHA);
            selector.graphics.drawRoundRect (0, 0, SELECTOR_WIDTH, ITEM_HEIGHT, SELECTION_ELLIPSE_SIZE, SELECTION_ELLIPSE_SIZE);
            selector.graphics.endFill ();
            selector.mouseEnabled = false;
            showHighlight = false;
            addChildAt (selector, 0);
        }

        /**
         * Ссылка на модель игрока в бою.
         */
        public function get player ():IBattlePlayer {
            return _player;
        }

        public function set player (value:IBattlePlayer):void {
            _player = value;
        }

        override public function setTexts ():void {
            if (_battleDanceMoveData) {
                var danceMoveType:DanceMoveType = _battleDanceMoveData.getDanceMoveType ();
                if (danceMoveType) {
                    var danceMoveName:String = danceMoveType.name;
                    text = "<b>" + danceMoveName + "</b>";
//                    text = "<b>" + danceMoveName + " (" + _battleDanceMoveData.level + ")" + "</b>";
//                    while (tf.textWidth > tf.width) {
//                        danceMoveName = danceMoveName.substr (0, danceMoveName.length - 2);
//                        text = "<b>" + danceMoveName + ".. (" + _battleDanceMoveData.level + ")" + "</b>";
//                    }
                    var masteryPoints:String = String (_battleDanceMoveData.masteryPoints);
                    if (_player) {
                        var shopItemsBonus:int = BattleUtils.getItemsBonus (_battleDanceMoveData.getDanceMoveType (), _player);
                        if (shopItemsBonus > 0) {
                            masteryPoints += " +" + shopItemsBonus;
                        }
                    }
                    text2 = "<b>" + masteryPoints + "</b>";
                }
            }
        }

        public function get battleDanceMoveData ():BattleDanceMoveData {
            return _battleDanceMoveData;
        }

        public function set battleDanceMoveData (value:BattleDanceMoveData):void {
            _battleDanceMoveData = value;
            setTexts ();
        }

        public function get showHighlight ():Boolean {
            return _showHighlight;
        }

        public function set showHighlight (value:Boolean):void {
            _showHighlight = value;
            var toAlpha:int = _showHighlight ? 1 : 0;
            TweenLite.to (selector, TWEEN_TIME, {alpha:toAlpha});
        }

        override public function destroy ():void {
            TweenLite.killTweensOf (selector);
            player = null;
            super.destroy ();
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        override protected function rollOverListener (event:MouseEvent):void {
            super.rollOverListener (event);
            if (_battleDanceMoveData) {
                var danceMoveType:DanceMoveType = _battleDanceMoveData.getDanceMoveType ();
                if (danceMoveType) {
                    var positiveBonus:int = 0;
                    if (_player) {
                        positiveBonus = BattleUtils.getItemsBonus (danceMoveType, _player);
                    }
                    var message:String = BattleDataUtils.getDanceMoveDescription (
                            _battleDanceMoveData.level,
                            _battleDanceMoveData.stamina,
                            _battleDanceMoveData.masteryPoints,
                            _battleDanceMoveData.basicStability,
                            positiveBonus,
                            0
                    );
                    var positionPoint:Point = localToGlobal (new Point (POSITION_POINT_X, POSITION_POINT_Y));
                    BreakdanceApp.instance.showTooltipMessage (message, positionPoint);
                }
            }
        }

        override protected function rollOutListener (event:MouseEvent):void {
            super.rollOutListener (event);
            BreakdanceApp.instance.hideTooltip ();
        }
    }
}
