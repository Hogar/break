/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 02.10.13
 * Time: 8:50
 * To change this template use File | Settings | File Templates.
 */
package breakdance.battle.view.roundIndicator {

    import com.hogargames.display.GraphicStorage;

    import flash.display.MovieClip;

    public class RoundsIndicatorContainer extends GraphicStorage {

        private var roundIndicators:Vector.<RoundIndicator>;

        private static const NUM_INDICATORS:int = 6;

        public function RoundsIndicatorContainer (mc:MovieClip) {
            super (mc);
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Показ заданного кол-ва индикаторов раундов.
         * @param numRounds Кол-во раундов.
         */
        public function showRounds (numRounds:int):void {
            for (var i:int = 0; i < roundIndicators.length; i++) {
                var roundIndicator:RoundIndicator = roundIndicators [i];
                roundIndicator.enable = (i < numRounds);
            }
        }

        /**
         * Подсветка заданного индикатора раунда.
         * @param round Номер раунда.
         */
        public function selectRound (round:int):void {
            for (var i:int = 0; i < roundIndicators.length; i++) {
                var roundIndicator:RoundIndicator = roundIndicators [i];
                roundIndicator.selected = (i == round);
            }
        }

        /**
         * Выделение заданного кол-ва индикаторов раунда, как завершённых.
         * @param numRounds Кол-во раундов.
         */
        public function completeRounds (numRounds:int):void {
            for (var i:int = 0; i < roundIndicators.length; i++) {
                var roundIndicator:RoundIndicator = roundIndicators [i];
                roundIndicator.completed = (i <= numRounds);
            }
        }

        /**
         * Очистка выделения всех индикаторов раунда.
         */
        public function deselectAllRounds ():void {
            selectRound (-1);
        }

        override public function destroy ():void {
            if (roundIndicators) {
                for (var i:int = 0; i < roundIndicators.length; i++) {
                    var roundIndicator:RoundIndicator = roundIndicators [i];
                    roundIndicator.destroy ();
                }
                roundIndicators = null;
            }
            super.destroy ();
        }

/////////////////////////////////////////////
//PROTECTED:
/////////////////////////////////////////////

        override protected function initGraphicElements ():void {
            super.initGraphicElements ();

            roundIndicators = new Vector.<RoundIndicator> ();
            for (var i:int = 1; i <= NUM_INDICATORS; i++) {
                var roundIndicator:RoundIndicator = new RoundIndicator (getElement ("mcRoundIndicator" + i));
                roundIndicators.push (roundIndicator);
            }
        }
    }
}
