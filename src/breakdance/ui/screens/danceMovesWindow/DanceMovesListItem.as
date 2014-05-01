/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 17.07.13
 * Time: 9:36
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.danceMovesWindow {

    import breakdance.BreakdanceApp;
    import breakdance.core.sound.SoundManager;
    import breakdance.core.staticData.StaticData;
    import breakdance.core.texts.ITextContainer;
    import breakdance.core.texts.TextsManager;
    import breakdance.data.danceMoves.DanceMoveLevel;
    import breakdance.data.danceMoves.DanceMoveSubType;
    import breakdance.data.danceMoves.DanceMoveType;
    import breakdance.data.danceMoves.DanceMoveTypeCollection;
    import breakdance.data.danceMoves.DanceMoveTypeConditionType;
    import breakdance.template.Template;
    import breakdance.ui.commons.tooltip.TooltipData;
    import breakdance.user.UserDanceMove;

    import com.hogargames.display.GraphicStorage;
    import com.hogargames.utils.TextFieldUtilities;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.text.TextField;

    public class DanceMovesListItem extends GraphicStorage implements ITextContainer {

        private var textsManager:TextsManager = TextsManager.instance;

        private var _userDanceMove:UserDanceMove;

        private var tfTitle:TextField;
        private var tfLevel:TextField;
        private var tfLevelTitle:TextField;
        private var tfPoints:TextField;
        private var tfStability:TextField;
        private var tfStamina:TextField;
        private var tfCondition:TextField;
        private var mcProgress:MovieClip;
        private var mcArrow:Sprite;
        private var mcLock:Sprite;

        private var mcHighlight:MovieClip;

        private var _enable:Boolean;

        private static const TOOLTIP_INDENT_X:int = 63;
        private static const TOOLTIP_INDENT_Y:int = 115;

        public function DanceMovesListItem () {
            super (Template.createSymbol (Template.DANCE_MOVIES_LIST_ITEM));

            buttonMode = true;
            useHandCursor = true;
            mouseChildren = false;

            hideArrowDown ();
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function get userDanceMove ():UserDanceMove {
            return _userDanceMove;
        }

        public function set userDanceMove (value:UserDanceMove):void {
            _userDanceMove = value;
            updateInfo ();
        }

        public function updateInfo ():void {
            enable = true;
            if (_userDanceMove) {
                tfTitle.text = _userDanceMove.type.name;
                tfLevel.text = String (userDanceMove.level);
                var points:int = 0;
                mcProgress.gotoAndStop (0);
                var danceMoveType:DanceMoveType = _userDanceMove.type;
                if (danceMoveType) {
                    var energyForCurrentLevel:int = 0;
                    var currentDanceMoveLevel:DanceMoveLevel = danceMoveType.getLevel (_userDanceMove.level);
                    if (currentDanceMoveLevel) {
                        points = currentDanceMoveLevel.masteryPoints;
                        if (_userDanceMove.level < danceMoveType.numLevels) {
                            energyForCurrentLevel = _userDanceMove.level == 0 ? 0 : currentDanceMoveLevel.energyRequired;
                        }
                    }
                    var nextDanceMoveLevel:DanceMoveLevel = danceMoveType.getLevel (_userDanceMove.level + 1);
                    if (nextDanceMoveLevel) {
                        var energyForNextLevel:int = nextDanceMoveLevel.energyRequired;
                    }
                    if ((energyForNextLevel - energyForCurrentLevel) > 0) {
                        mcProgress.gotoAndStop (Math.floor (100 * (userDanceMove.energySpent) / (energyForNextLevel - energyForCurrentLevel)) + 1);
                    }
                }
                tfPoints.text = String (points);
                tfStability.text = String (userDanceMove.getStability ()) + "%";
                tfStamina.text = String (userDanceMove.type.stamina);

                switch (_userDanceMove.type.conditionType) {
                    case (DanceMoveTypeConditionType.STEP):
                        var conditionValueAsArray:Array = _userDanceMove.type.conditionValue.split(":");
                        var stepId:String = conditionValueAsArray [0];
                        var stepLevel:int = parseInt (conditionValueAsArray [1]);
                        if (BreakdanceApp.instance.appUser.getDanceMoveLevel (stepId) < stepLevel) {
                            enable = false;
                        }
                        break;
                }
            }
            else {
                enable = false;
            }
            updateConditionText ();
        }

        public function setTexts ():void {
            tfLevelTitle.text = textsManager.getText ("level_2");
            tfLevelTitle.width = tfLevelTitle.textWidth + 4;
            tfLevel.x = Math.ceil (tfLevelTitle.x + tfLevelTitle.width);
            updateInfo ();
        }

        public function showArrowDown ():void {
            mcArrow.visible = true;
        }

        public function hideArrowDown ():void {
            mcArrow.visible = false;
        }

        public function get enable ():Boolean {
            return _enable;
        }

        public function set enable (value:Boolean):void {
            _enable = value;
            var toAlpha:Number = _enable ? 1 : .5;
            tfTitle.alpha = toAlpha;
            mcArrow.alpha = toAlpha;
            mcLock.visible = !_enable;
            updateConditionText ();
            mouseEnabled = _enable;
        }

        override public function destroy ():void {
            removeEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            removeEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            removeEventListener (MouseEvent.MOUSE_DOWN, mouseDownListener);

            textsManager.removeTextContainer (this);

            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            tfTitle = getElement ('tfTitle');
            tfLevel = getElement ('tfLevel');
            tfLevelTitle = getElement ('tfLevelTitle');
            tfPoints = getElement ('tfPoints');
            tfStability = getElement ('tfStability');
            tfStamina = getElement ('tfStamina');

            TextFieldUtilities.setBold (tfTitle);
            TextFieldUtilities.setBold (tfLevel);
            TextFieldUtilities.setBold (tfStamina);

            mcArrow = getElement ('mcArrow');
            mcProgress = getElement ('mcProgress');
            mcHighlight = getElement ('mcHighlight');
            mcLock = getElement ('mcLock');
            tfCondition = getElement ('tfCondition', mcLock);

            mcHighlight.gotoAndStop (1);
            mcLock.visible = false;

            addEventListener (MouseEvent.ROLL_OVER, rollOverListener);
            addEventListener (MouseEvent.ROLL_OUT, rollOutListener);
            addEventListener (MouseEvent.MOUSE_DOWN, mouseDownListener);

            textsManager.addTextContainer (this);
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function updateConditionText ():void {
            var conditionText:String = "";
            if (_userDanceMove) {
                switch (_userDanceMove.type.conditionType) {
                    case (DanceMoveTypeConditionType.STEP):
                        var conditionValueAsArray:Array = _userDanceMove.type.conditionValue.split(":");
                        var stepId:String = conditionValueAsArray [0];
                        var stepLevel:int = parseInt (conditionValueAsArray [1]);
                        if (BreakdanceApp.instance.appUser.getDanceMoveLevel (stepId) < stepLevel) {
                            var ttNeedStep:String = textsManager.getText ("ttNeedStep");
                            var danceMoveType:DanceMoveType = DanceMoveTypeCollection.instance.getDanceMoveType (stepId);
                            var danceMoveName:String = "";
                            if (danceMoveType) {
                                danceMoveName = danceMoveType.name;
                            }
                            ttNeedStep = ttNeedStep.replace ("#1", danceMoveName);
                            ttNeedStep = ttNeedStep.replace ("#2", stepLevel);
                            conditionText += ttNeedStep + "\n";
                        }
                        break;
                }
            }
            tfCondition.text = conditionText;
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function rollOverListener (event:MouseEvent):void {
            if (_userDanceMove) {
                var tooltipText:String = null;
                var tooltipText2:String = null;
                var priceCoins:int = 0;
                var priceBucks:int = 0;
                var priceText:String = null;
                var danceMoveType:DanceMoveType = _userDanceMove.type;

                if (danceMoveType) {
                    if (danceMoveType.subType != DanceMoveSubType.ORIGINAL) {
                        var availableTransitionMoves:Vector.<String> = _userDanceMove.getAvailableTransitionMoves ();
                        tooltipText2 = '<p align="center">' + textsManager.getText ("ttLine") + "</p>";
                        if (availableTransitionMoves) {
                            if (availableTransitionMoves.length > 0) {
                                tooltipText2 += "\n" + textsManager.getText ("ttAvailableTransitions") + "\n";
                                for (var i:int = 0; i < availableTransitionMoves.length; i++) {
                                    var danceMoveId:String = availableTransitionMoves [i];
                                    var currentDanceMoveType:DanceMoveType = DanceMoveTypeCollection.instance.getDanceMoveType (danceMoveId);
                                    if (currentDanceMoveType) {
    //                                    tooltipText2 += "\n- " + danceMoveType.name;
                                        tooltipText2 += currentDanceMoveType.name;
                                    }
                                    if (i < availableTransitionMoves.length - 1) {
                                        tooltipText2 += ", ";
                                    }
                                }
                            }
                            else {
                                tooltipText2 += "\n" + textsManager.getText ("ttNoAvailableTransitions");
                            }
                        }
                    }
                    var energyForTrainDanceMove:int = parseInt (StaticData.instance.getSetting ("energy_for_train_dance_move"));
                    var nextDanceMoveLevel:DanceMoveLevel;
                    var previousEnergySpent:int = 0;
                    if (danceMoveType) {
                        var currentDanceMoveLevel:DanceMoveLevel = danceMoveType.getLevel (_userDanceMove.level);
                        if (currentDanceMoveLevel) {
                            previousEnergySpent = currentDanceMoveLevel.energyRequired;
                        }
                        nextDanceMoveLevel = danceMoveType.getLevel (_userDanceMove.level + 1);
                    }
                    if (nextDanceMoveLevel) {
                        var energy:String = _userDanceMove.energySpent + "/" + (nextDanceMoveLevel.energyRequired - previousEnergySpent);
                        energy = "<b>" + energy + "</b>";
                        tooltipText = textsManager.getText ("energy") + " " + energy;
//                        if (_userDanceMove.energySpent == (nextDanceMoveLevel.energyRequired - previousEnergySpent - energyForTrainDanceMove)) {
                            priceCoins = nextDanceMoveLevel.coins;
                            priceBucks = nextDanceMoveLevel.bucks;
                            if ((priceCoins > 0) || (priceBucks > 0)) {
                                priceText = textsManager.getText ("ttNextDanceMoveLevelPrice");
                                priceText = priceText.replace ("#1", _userDanceMove.level + 1);
                            }
//                        }
                    }
                    else {
                        if (danceMoveType) {
                            if (danceMoveType.numLevels == _userDanceMove.level) {
                                tooltipText = textsManager.getText ("ttMaxDanceMoveLevel");
                            }
                        }
                    }
                }
                var positionPoint:Point = this.localToGlobal (new Point (TOOLTIP_INDENT_X, TOOLTIP_INDENT_Y));
                BreakdanceApp.instance.showTooltip (new TooltipData (tooltipText, priceCoins, priceBucks, priceText, tooltipText2), positionPoint);
            }
//            SoundManager.instance.playSound (Template.SND_BUTTON_OVER);
        }

        private function mouseDownListener (event:MouseEvent):void {
            SoundManager.instance.playSound (Template.SND_BUTTON_DOWN);
            mcHighlight.gotoAndPlay (1);
        }

        private function rollOutListener (event:MouseEvent):void {
            BreakdanceApp.instance.hideTooltip ();
//            mcHighlight.visible = false;
        }

    }
}
