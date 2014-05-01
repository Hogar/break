/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 29.01.14
 * Time: 7:06
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.popups.dailyAwardPopUp {

    import breakdance.BreakdanceApp;
    import breakdance.GlobalConstants;
    import breakdance.core.server.ServerApi;
    import breakdance.core.ui.overlay.OverlayManager;
    import breakdance.data.awards.Award;
    import breakdance.data.awards.AwardCollection;
    import breakdance.template.Template;
    import breakdance.ui.commons.buttons.ButtonWithText;
    import breakdance.ui.popups.basePopUps.TitlePopUp;

    import com.greensock.TweenLite;

    import flash.events.MouseEvent;

    public class DailyAwardPopUp extends TitlePopUp {

        protected var _day:int = 1;
        protected var btnCollect:ButtonWithText;
        private var days:Vector.<Day>;

        private static const NUM_BUTTONS:int = 5;

        public function DailyAwardPopUp () {
            super (Template.createSymbol (Template.DAILY_AWARD_POP_UP));
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        override public function show ():void {
            OverlayManager.instance.addOverlay (this, OverlayManager.TRANSACTION_LAYER_PRIORITY);
            if (mc && useShowAnimation) {
                TweenLite.killTweensOf (mc);
                mc.y = mcY - GlobalConstants.APP_HEIGHT / 2;
                TweenLite.to (mc, TWEEN_TIME, {y:mcY});
            }
            showDay (_day);
        }

        override public function destroy ():void {
            if (btnCollect) {
                btnCollect.removeEventListener (MouseEvent.CLICK, clickListener);
                btnCollect.destroy ();
                btnCollect = null;
            }
            super.destroy ();
        }

        override public function setTexts ():void {
            super.setTexts ();
            tfTitle.text = textsManager.getText ("dailyAward");
            btnCollect.text = textsManager.getText ("collect");
        }

        public function setDay (value:int):void {
            if (_day != value) {
                showDay (value);
            }
            _day = value;
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();
            btnCollect = new ButtonWithText (getElement ("btnCollect"));
            btnCollect.addEventListener (MouseEvent.CLICK, clickListener);
            btnCollect.text = "";

            days = new Vector.<Day> ();
            var i:int;
            for (i = 1; i <= NUM_BUTTONS; i++) {
                var day:Day = new Day (mc ["mcDay" + i]);
                day.day = i;
                days.push (day);
            }

            var dailyAwards:Vector.<String> = AwardCollection.instance.dailyAwards;

            for (i = 0; i < dailyAwards.length; i++) {
                var awardId:String = dailyAwards [i];
                var award:Award = AwardCollection.instance.getAward (awardId);
                if (days.length > i) {
                    days [i].setAward (award);
                }
            }
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function showDay (day:int):void {
//            trace ("showDay: " + day);
            for (var i:int = 0; i < days.length; i++) {
                if (i < day - 1) {
                    days [i].showSelected (i);
                }
                else if (i == day - 1) {
                    days [i].showSelected (i, true);
                }
                else {
                    days [i].hideSelected ();
                }
            }
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        protected function clickListener (event:MouseEvent):void {
            ServerApi.instance.query (ServerApi.DAILY_AWARD_ACTION, {}, onDailyAwardAction);
            hide ();
        }

        private function onDailyAwardAction (response:Object):void {
            BreakdanceApp.instance.appUser.onResponseWithUpdateUserData (response);
        }

    }
}