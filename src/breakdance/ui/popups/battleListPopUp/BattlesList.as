/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 27.07.13
 * Time: 23:33
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.battleListPopUp {

    import breakdance.battle.data.BattleData;
    import breakdance.ui.commons.AbstractList;
    import breakdance.ui.popups.battleListPopUp.events.SelectBattleEvent;

    import com.hogargames.display.scrolls.BasicScrollWithTweenLite;
    import com.hogargames.display.scrolls.MotionType;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class BattlesList extends AbstractList {

        private var localBattleListItem:BattlesListItem;
        private var battlesListItems:Vector.<BattlesListItem> = new Vector.<BattlesListItem> ();

        private static const NUM_VISIBLE_ITEMS:int = 5;
        private static const STEP:int = 56;
        private static const WIDTH:int = 540;

        public function BattlesList (mc:MovieClip) {
            //создаём скролл-бар:
            var mcScrollBar:Sprite = getElement ("mcScrollBar", mc);
            var mcScrollBase:Sprite = getElement ("mcScrollBase", mc);
            var scroll:BasicScrollWithTweenLite = new BasicScrollWithTweenLite ();
            scroll.x = mcScrollBase.x;
            scroll.y = mcScrollBase.y;
            scroll.setExternalScrollBar (mcScrollBar, true);
            scroll.setExternalScrollBase (mcScrollBase, true);
            scroll.baseAlpha = 0;
            addChild (scroll);

            super (mc, NUM_VISIBLE_ITEMS, STEP, WIDTH, NUM_VISIBLE_ITEMS * STEP, scroll);
            motionType = MotionType.Y;

            localBattleListItem = new BattlesListItem ();
            localBattleListItem.y = battlesListItems.length * STEP;
            localBattleListItem.addEventListener (MouseEvent.CLICK, clickListener);
            container.addChild (localBattleListItem);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function init (battles:Vector.<BattleData>, localBattleData:BattleData, withClear:Boolean = false):void {
            if (withClear) {
                clear ();
            }

            localBattleListItem.battleData = localBattleData;

            var i:int;

            trace ("************");
            trace ("Инициализируем список игроков. Всего " + battles.length + " игроков.");
            trace ("В списке " + battlesListItems.length + " пунктов.");

            //Убираем игроков первого уровня.
            var no1levelsBattles:Vector.<BattleData> = new Vector.<BattleData> ();
            for (i = 0; i < battles.length; i++) {
                if (battles [i].player1.level > 1) {
                    no1levelsBattles.push (battles [i]);
                }
                else {
                    trace ("Проигнорировали игрока 1 уровня " + i + ".");
                }
            }

            battles = no1levelsBattles;

            //add scroll elements:
            var battleData:BattleData;
            var unusedBattles:Vector.<BattleData> = new Vector.<BattleData>();
            var usedBattleListItems:Vector.<BattlesListItem> = new Vector.<BattlesListItem>();
            var battlesListItem:BattlesListItem;
            for (i = 0; i < battles.length; i++) {
                battleData = battles [i];
                var battleDataAsString:String = battleData.toString ();
                var used:Boolean = false;
                for (var j:int = 0; j < battlesListItems.length; j++) {
                    battlesListItem = battlesListItems [j];
                    if (battlesListItem.battleDataAsString == battleDataAsString) {
                        usedBattleListItems.push (battlesListItem);
                        battlesListItem.enabled = true;
                        used = true;
                        break;
                    }
                }
                if (!used) {
                    unusedBattles.push (battleData);
                }
            }
            trace ("Уже инициализированных пунктов списка " + usedBattleListItems.length + ".");
            trace ("Новых битв " + unusedBattles.length + ".");

            var unusedBattleListItems:Vector.<BattlesListItem> = new Vector.<BattlesListItem>();
            for (i = 0; i < battlesListItems.length; i++) {
                battlesListItem = battlesListItems [i];
                if (usedBattleListItems.indexOf (battlesListItem) == -1) {
                    unusedBattleListItems.push (battlesListItem);
                    battlesListItem.enabled = false;
                }
            }
            trace ("Выключенных пунктов списка " + unusedBattleListItems.length + ".");

            for (i = 0; i < unusedBattles.length; i++) {
                battleData = unusedBattles [i];
                if (unusedBattleListItems.length > 0) {
                    battlesListItem = unusedBattleListItems.shift ();
                    battlesListItem.battleData = battleData;
                    trace ("Для новой битвы " + i + " используем выключенный пункт списка. Осталось " + unusedBattleListItems.length + " выключенных пунктов списка.");
                }
                else {
                    trace ("Для новой битвы " + i + " создаём новый пункт списка.");
                    addNewBattlesListItem (battleData);
                }
            }


            //set scroll params:
            this.numItems = battlesListItems.length;

//            basicScroll.setPositionAt (currentMovingIndex / getMaxMovingIndex());
//            moveTo (0);
        }

        public function addNewBattlesListItem (battleData:BattleData):void {
            var battlesListItem:BattlesListItem = new BattlesListItem ();
            battlesListItem.battleData = battleData;
            battlesListItem.y = (battlesListItems.length + 1) * STEP;
            battlesListItem.addEventListener (MouseEvent.CLICK, clickListener);
            container.addChild (battlesListItem);
            battlesListItems.push (battlesListItem);
        }

        override public function clear ():void {
            for (var i:int = 0; i < battlesListItems.length; i++) {
                var battlesListItem:BattlesListItem = battlesListItems [i];
                battlesListItem.removeEventListener (MouseEvent.CLICK, clickListener);
                if (container.contains (battlesListItem)) {
                    container.removeChild (battlesListItem);
                }
                battlesListItem.destroy ();
            }
            battlesListItems = new Vector.<BattlesListItem> ();
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            var battlesListItem:BattlesListItem = BattlesListItem (event.currentTarget);
            if (battlesListItem.battleData) {
                dispatchEvent (new SelectBattleEvent (battlesListItem.battleData));
            }
        }
    }
}
