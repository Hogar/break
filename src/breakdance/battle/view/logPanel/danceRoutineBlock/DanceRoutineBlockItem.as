/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 26.09.13
 * Time: 15:46
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view.logPanel.danceRoutineBlock {

    import breakdance.BreakdanceApp;
    import breakdance.battle.data.BattleDanceMoveData;
    import breakdance.battle.model.BattleUtils;
    import breakdance.battle.model.IBattlePlayer;
    import breakdance.battle.view.DanceMoveLogItem;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.danceMoves.DanceMoveSubType;
    import breakdance.data.danceMoves.DanceMoveType;

    import flash.events.MouseEvent;

    /**
     * Элемент блока связки танц. движений со статичными данными.
     */
    public class DanceRoutineBlockItem extends DanceMoveLogItem implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        protected var _player:IBattlePlayer;//Ссылка на модель игрока в бою.

        private var _battleDanceMoveData:BattleDanceMoveData;

        private static const COLOR_NORMAL:uint = 0xffffff;
        private static const COLOR_ORIGINAL:uint = 0x00ff00;

        public function DanceRoutineBlockItem () {

        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Ссылка на модель игрока в бою.
         */
        public function get player ():IBattlePlayer {
            return _player;
        }

        public function set player (value:IBattlePlayer):void {
            _player = value;
        }

        /**
         * Данные о танц. движении.
         */
        public function get battleDanceMoveData ():BattleDanceMoveData {
            return _battleDanceMoveData;
        }

        public function set battleDanceMoveData (value:BattleDanceMoveData):void {
            _battleDanceMoveData = value;
            setTexts ();
        }

        override public function set bold (value:Boolean):void {
            super.bold = value;
            setTexts ();
        }

        public function setTexts ():void {
            if (_battleDanceMoveData) {
                var danceMoveType:DanceMoveType = _battleDanceMoveData.getDanceMoveType ();
                if (danceMoveType) {
                    setDanceMoveTexts (danceMoveType.name, _battleDanceMoveData.level);
                    var masteryPoints:String = String (_battleDanceMoveData.masteryPoints);
                    if (_player) {
                        var shopItemsBonus:int = BattleUtils.getItemsBonus (_battleDanceMoveData.getDanceMoveType (), _player);
                        if (shopItemsBonus > 0) {
                            masteryPoints += " +" + shopItemsBonus;
                        }
                    }
                    amount = String (masteryPoints);
                    if (danceMoveType.subType == DanceMoveSubType.ORIGINAL) {
                        textColor = COLOR_ORIGINAL;
                    }
                    else {
                        textColor = COLOR_NORMAL;
                    }
                }
            }
        }

        override public function destroy ():void {
            textsManager.removeTextContainer (this);
            battleDanceMoveData = null;
            removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            player = null;
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            textsManager.addTextContainer (this);
            addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function rollOverListener (event:MouseEvent):void {
            if (_battleDanceMoveData) {
                var danceMoveType:DanceMoveType = _battleDanceMoveData.getDanceMoveType ();
                if (danceMoveType) {
                    var positiveBonus:int = 0;
                    if (_player) {
                        positiveBonus = BattleUtils.getItemsBonus (danceMoveType, _player);
                    }
                    showToolTip (
                            _battleDanceMoveData.level,
                            _battleDanceMoveData.stamina,
                            _battleDanceMoveData.masteryPoints,
                            _battleDanceMoveData.basicStability,
                            positiveBonus,
                            0
                    );
                }
            }
        }

        private function rollOutListener (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();
        }
    }
}
