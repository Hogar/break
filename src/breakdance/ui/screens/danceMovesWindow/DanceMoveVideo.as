/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 17.07.13
 * Time: 13:30
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.danceMovesWindow {

    import breakdance.BreakdanceApp;
    import breakdance.battle.view.DanceMoviePlayer;
    import breakdance.data.danceMoves.DanceMoveType;
    import breakdance.ui.tutorial.TutorialOverlay;

    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;
    import flash.events.TimerEvent;
    import flash.text.TextField;
    import flash.utils.Timer;

    /**
     * Элемент, показывающий видео танц. движения и название танц. движения определённое время.
     */
    public class DanceMoveVideo extends GraphicStorage {

        private var tfTitle:TextField;

        private var danceMoviePlayer:DanceMoviePlayer;
        private var danceMovieId:String;

        private var showsMinimumTime:Boolean = false;
        private var timer:Timer = new Timer (SHOW_TIME * 1000);

        private static const SHOW_TIME:Number = 4;

        public function DanceMoveVideo (mc:MovieClip) {
            super (mc);
            timer.addEventListener (TimerEvent.TIMER, timerListener);
        }

        override public function destroy ():void {
            danceMoviePlayer.destroy ();
            danceMoviePlayer = null;
            super.destroy ();
        }

        public function show (danceMovieType:DanceMoveType):void {
            visible = true;
            TutorialOverlay.instance.backgroundUnvisible ();
            if (danceMovieType) {
                danceMovieId = danceMovieType.id;
                tfTitle.text = danceMovieType.name + "\n" + BreakdanceApp.instance.appUser.getDanceMoveLevel (danceMovieType.id);
                showsMinimumTime = false;
                timer.start ();
                danceMoviePlayer.showMove (danceMovieId, onCompleteVideo);
            }
            else {
                hide ();
            }
        }

        public function hide ():void {
            TutorialOverlay.instance.backgroundVisible ();
            danceMoviePlayer.clear () ;
            visible = false;
        }

        override protected function initGraphicElements ():void {
            tfTitle = getElement ("tfTitle");
            danceMoviePlayer = new DanceMoviePlayer (getElement ("mcVideoDummy"))
        }

        private function timerListener (event:TimerEvent):void {
            showsMinimumTime = true;
            timer.stop ();
        }

        private function onCompleteVideo ():void {
            if (!showsMinimumTime) {
                danceMoviePlayer.showMove (danceMovieId, onCompleteVideo);
            }
            else {
                hide ();
            }
        }

    }
}
