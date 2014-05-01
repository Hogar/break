/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 10.10.13
 * Time: 10:10
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view {

    import breakdance.BreakdanceApp;
    import breakdance.battle.data.BattleDataUtils;
    import breakdance.battle.view.logPanel.LogItem;

    import flash.geom.Point;

    public class DanceMoveLogItem extends LogItem {

        private static const TEXT_INDENT:int = 4;

        private static const POSITION_POINT_X:int = 113;
        private static const POSITION_POINT_Y:int = 16;

        public function DanceMoveLogItem () {

        }

        protected function setDanceMoveTexts (danceMoveName:String, level:int):void {
            caption = danceMoveName;
//            caption = danceMoveName + " (" + level + ")";
//            while (tfCaption.textWidth > tfCaption.width - TEXT_INDENT) {
//                danceMoveName = danceMoveName.substr (0, danceMoveName.length - 2);
//                caption = danceMoveName + ".. (" + level + ")";
//            }
        }

        protected function showToolTip (level:int, stamina:int, points:int, stability:int, positiveBonusPoints:int = 0, negativeBonusPoints:int = 0):void {
            var message:String = BattleDataUtils.getDanceMoveDescription (level, stamina, points, stability, positiveBonusPoints, negativeBonusPoints);
            var positionPoint:Point = localToGlobal (new Point (POSITION_POINT_X, POSITION_POINT_Y));
            BreakdanceApp.instance.showTooltipMessage (message, positionPoint);
        }

    }
}
