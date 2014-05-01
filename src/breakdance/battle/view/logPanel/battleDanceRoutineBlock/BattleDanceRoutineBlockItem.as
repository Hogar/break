/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 26.09.13
 * Time: 14:47
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view.logPanel.battleDanceRoutineBlock {

    import breakdance.BreakdanceApp;
    import breakdance.battle.events.BattleDanceMoveEvent;
    import breakdance.battle.model.BattleDanceMove;
    import breakdance.battle.model.BattleUtils;
    import breakdance.battle.model.IBattlePlayer;
    import breakdance.battle.view.DanceMoveLogItem;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.danceMoves.DanceMoveSubType;
    import breakdance.data.danceMoves.DanceMoveType;

    import com.greensock.TweenLite;

    import flash.events.MouseEvent;
    import flash.geom.Point;

    /**
     * Элемент блока связки танц. движений с динамическими данными (ссылка на модель).
     * Содержит ссылку на модель (на конкретное танц. движение в связке).
     */
    public class BattleDanceRoutineBlockItem extends DanceMoveLogItem implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        protected var _player:IBattlePlayer;//Ссылка на модель игрока в бою.

        private var _battleDanceMove:BattleDanceMove;

        private var _selected:Boolean;

        private static const SELECTED_COLOR:uint = 0xddbb00;
        private static const DESELECTED_COLOR:uint = 0xffffff;
        private static const DESELECTED_COLOR_ORIGINAL:uint = 0x00ff00;
        private static const MESSAGE_X:int = 176;
        private static const MESSAGE_Y:int = 10;

        private static const HIDE_TWEEN_TIME:Number = .3;
        private static const SHOW_TWEEN_TIME:Number = .3;
        private static const MIN_ALPHA:Number = .7;

        public function BattleDanceRoutineBlockItem () {

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
            setTexts ();
        }

        public function setTexts ():void {
            caption = "";
            amount = "";
            if (_battleDanceMove) {
                var danceMoveType:DanceMoveType = _battleDanceMove.getDanceMoveType ();
                if (danceMoveType) {
                    setDanceMoveTexts (danceMoveType.name, _battleDanceMove.level);
                    var masteryPoints:String = "";
                    if (_battleDanceMove.wasProcessed) {
                        masteryPoints = String (_battleDanceMove.masteryPoints);
//                        masteryPoints = String (_battleDanceMove.masteryPoints - _battleDanceMove.positiveBonus);
//                        if (_battleDanceMove.positiveBonus > 0) {
//                            masteryPoints += "+" + _battleDanceMove.positiveBonus;
//                        }
                    }
                    else {
                        masteryPoints = String (_battleDanceMove.basicMasteryPoints);
                        if (_player) {
                            var shopItemsBonus:int = BattleUtils.getItemsBonus (_battleDanceMove.getDanceMoveType (), _player);
                            if (shopItemsBonus > 0) {
                                masteryPoints += " +" + shopItemsBonus;
                            }
                        }
                    }
                    amount = masteryPoints;
                }
            }
        }

        /**
         * Данные о танц. движении (модель).
         */
        public function get battleDanceMove ():BattleDanceMove {
            return _battleDanceMove;
        }

        public function set battleDanceMove (value:BattleDanceMove):void {
            if (_battleDanceMove) {
                _battleDanceMove.removeEventListener (BattleDanceMoveEvent.SET_POINTS, setPointListener);
            }
            _battleDanceMove = value;
            if (_battleDanceMove) {
                _battleDanceMove.addEventListener (BattleDanceMoveEvent.SET_POINTS, setPointListener);
            }
            setTexts ();
            selected = selected;
        }


        public function get selected ():Boolean {
            return _selected;
        }

        public function set selected (value:Boolean):void {
            _selected = value;
            bold = _selected;
            arrowVisible = _selected;
            if (_selected) {
                textColor = SELECTED_COLOR;
            }
            else {
                textColor = DESELECTED_COLOR;
                if (_battleDanceMove) {
                    var danceMoveType:DanceMoveType = _battleDanceMove.getDanceMoveType ();
                    if (danceMoveType) {
                        if (danceMoveType.subType == DanceMoveSubType.ORIGINAL) {
                            textColor = DESELECTED_COLOR_ORIGINAL;
                        }
                    }
                }
            }
        }

        public function highlight ():void {
            TweenLite.killTweensOf (mc);
            TweenLite.to (mcContainer, HIDE_TWEEN_TIME, {alpha:0, onComplete:onHide});
        }


        private function onHide ():void {
            var toAlpha:Number = 1;
            if (_battleDanceMove) {
                toAlpha = Math.max (MIN_ALPHA, (1 - .1 * _battleDanceMove.repeat));
            }
            TweenLite.to (mcContainer, SHOW_TWEEN_TIME, {alpha:toAlpha});
        }

        override public function set bold (value:Boolean):void {
            super.bold = value;
            setTexts ();
        }

        override public function destroy ():void {
            textsManager.removeTextContainer (this);
            if (_battleDanceMove) {
                _battleDanceMove.removeEventListener (BattleDanceMoveEvent.SET_POINTS, setPointListener);
            }
            _battleDanceMove = null;
            removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
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

        private function setPointListener (event:BattleDanceMoveEvent):void {
            if (_battleDanceMove) {
                var danceMoveType:DanceMoveType = _battleDanceMove.getDanceMoveType ();
                if (danceMoveType) {
                    if (_battleDanceMove.wasProcessed) {
//                        var masteryPoints:int = _battleDanceMove.masteryPoints;
//                        var difference:int = _battleDanceMove.basicMasteryPoints - _battleDanceMove.masteryPoints;
                        var masteryPointsAsString:String;
//                        if (difference < 0) {
//                            masteryPointsAsString = "+" + String (Math.abs (difference));
//                        }
//                        else if (difference > 0) {
//                            masteryPointsAsString = String (_battleDanceMove.masteryPoints);
//                        }
                        if (_battleDanceMove.basicMasteryPoints != _battleDanceMove.masteryPoints) {
                            masteryPointsAsString = String (_battleDanceMove.basicMasteryPoints);
                            if (_battleDanceMove.negativeBonus > 0) {
                                masteryPointsAsString += " -" + _battleDanceMove.negativeBonus;
                            }
                            if (_battleDanceMove.positiveBonus > 0) {
                                masteryPointsAsString += " +" + _battleDanceMove.positiveBonus;
                            }
                            if (masteryPointsAsString) {
                                var positionPoint:Point = this.localToGlobal (new Point (MESSAGE_X, MESSAGE_Y));
                                BreakdanceApp.instance.showInfoMessage (masteryPointsAsString, positionPoint);
                            }
                        }
                    }
                }
            }
            setTexts ();
        }

        private function rollOverListener (event:MouseEvent):void {
            if (_battleDanceMove) {
                var danceMoveType:DanceMoveType = _battleDanceMove.getDanceMoveType ();
                if (danceMoveType) {
                    var positiveBonus:int = 0;
                    if (_player) {
                        positiveBonus = BattleUtils.getItemsBonus (danceMoveType, _player);
                    }
                    var negativeBonus:int = 0;
                    if (_battleDanceMove.wasProcessed) {
                        positiveBonus = _battleDanceMove.positiveBonus;
                        negativeBonus = _battleDanceMove.negativeBonus;
                    }
                    showToolTip (
                            _battleDanceMove.level,
                            _battleDanceMove.stamina,
                            _battleDanceMove.basicMasteryPoints,
                            _battleDanceMove.basicStability,
                            positiveBonus,
                            negativeBonus
                    );
                }
            }
        }

        private function rollOutListener (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();
        }
    }
}
