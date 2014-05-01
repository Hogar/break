/**
 * Created with IntelliJ IDEA.
 * User: Hogar
 * Date: 17.07.13
 * Time: 9:52
 * To change this template use File | Settings | File Templates.
 */
package breakdance.ui.screens.danceMovesWindow {

    import breakdance.data.danceMoves.DanceMoveTypeConditionType;
    import breakdance.ui.commons.AbstractList;
    import breakdance.ui.screens.danceMovesWindow.events.SelectDanceMove;
    import breakdance.user.UserDanceMove;

    import com.hogargames.display.scrolls.BasicScrollWithTweenLite;
    import com.hogargames.display.scrolls.MotionType;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class DanceMoviesList extends AbstractList {

        private var danceMoviesListItems:Vector.<DanceMovesListItem> = new Vector.<DanceMovesListItem> ();

        private var danceMovieForLearning:UserDanceMove;

        private static const NUM_VISIBLE_ITEMS:int = 2;
        private static const STEP:int = 135;
        private static const WIDTH:int = 533;
        private static const HEIGHT:int = 322;
        private static const NUM_ITEMS_IN_ROW:int = 4;

        public function DanceMoviesList (mc:MovieClip) {
            //создаём скролл-бар:
            var mcScrollBar:Sprite = getElement ("mcScrollBar", mc);
            var mcScrollBase:Sprite = getElement ("mcScrollBase", mc);
            var scroll:BasicScrollWithTweenLite = new BasicScrollWithTweenLite ();
            scroll.x = mcScrollBase.x;
            scroll.y = mcScrollBase.y;
            scroll.setExternalScrollBar (mcScrollBar, true);
            scroll.setExternalScrollBase (mcScrollBase, true);
            addChild (scroll);

            super (mc, NUM_VISIBLE_ITEMS, STEP, WIDTH, HEIGHT, scroll);
            motionType = MotionType.Y;


        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public function init (userDanceMovies:Vector.<UserDanceMove>):void {
            clear ();

            var numUserDanceMovies:int = userDanceMovies.length;

            var i:int;
            var j:int;
            var k:int;
            var userDanceMoveId:String;

            var currentUserDanceMove:UserDanceMove;
            var allDanceMoviesIds:Vector.<String> = new Vector.<String> ();
            var list:Vector.<Vector.<UserDanceMove>> = new Vector.<Vector.<UserDanceMove>> ();//Дерево, хранилище в котором формируется список для правильного отображения дерева танц. движений.
            var dependentUserDanceMoviesAsObject:Object = [];//Объект-хранилище зависимых движений (ключами выступает id'шники движений-условий).
            var additionIndependentDanceMovies:Vector.<UserDanceMove> = new Vector.<UserDanceMove> ();
            var row:Vector.<UserDanceMove>;

            var topRow:Vector.<UserDanceMove> = new Vector.<UserDanceMove> ();
            list.push (topRow);

            for (i = 0; i < numUserDanceMovies; i++) {
                currentUserDanceMove = userDanceMovies [i];
                allDanceMoviesIds.push (currentUserDanceMove.type.id);
            }

            //Форминуем верхний ряд дерева (topRow в объекте list).
            //Создаём хранилище зависимых движений (dependentUserDanceMoviesAsObject).
            //Создаём хранилище оставшиеся (не вошедших в первый ряд) независимых движений (additionIndependentDanceMovies):
            for (i = 0; i < numUserDanceMovies; i++) {
                currentUserDanceMove = userDanceMovies [i];
                if (currentUserDanceMove.type.conditionType == DanceMoveTypeConditionType.STEP) {
                    var conditionValueAsArray:Array = currentUserDanceMove.type.conditionValue.split (":");
                    var conditionStepId:String = conditionValueAsArray [0];
                    if (allDanceMoviesIds.indexOf (conditionStepId) == -1) {
                        if (topRow.length < NUM_ITEMS_IN_ROW) {
                            topRow.push (currentUserDanceMove);
                        }
                        else {
                            additionIndependentDanceMovies.push (currentUserDanceMove);
                        }
                    }
                    else {
                        dependentUserDanceMoviesAsObject [conditionStepId] = currentUserDanceMove;
                    }
                }
                else {
                    if (topRow.length < NUM_ITEMS_IN_ROW) {
                        topRow.push (currentUserDanceMove);
                    }
                    else {
                        additionIndependentDanceMovies.push (currentUserDanceMove);
                    }
                }
            }

//            trace ("-----------0----------");
//            traceList (list);
//            trace ("----------------------");

            topRow.length = NUM_ITEMS_IN_ROW;

//            trace ("-----------1----------");
//            traceList (list);
//            trace ("----------------------");

            //добавляем в дерево (list) зависимые движения:
            for (i = 0; i < topRow.length; i++) {
                currentUserDanceMove = topRow [i];
                if (currentUserDanceMove) {
                    andAddDependentDanceMovieToList (currentUserDanceMove, i, 0, list, dependentUserDanceMoviesAsObject);
                }
            }

//            trace ("-----------2----------");
//            traceList (list);
//            trace ("----------------------");

            //добавляем в список оставшиеся независимых движений недобавленные зависимые движения:
            for (userDanceMoveId in dependentUserDanceMoviesAsObject) {
                currentUserDanceMove = dependentUserDanceMoviesAsObject [userDanceMoveId];
                if (currentUserDanceMove) {
                    additionIndependentDanceMovies.push (currentUserDanceMove);
                }
            }

//            trace ("-----------3----------");
//            traceList (list);
//            trace ("----------------------");

            //добавляем в дерево оставшиеся независимые движения:
            for (i = 0; i < additionIndependentDanceMovies.length; i++) {
                currentUserDanceMove = additionIndependentDanceMovies [i];
                for (j = 0; j < list.length; j++) {
                    row = list [j];
                    for (k = 0; k < row.length; k++) {
                        if (row [k] == null) {
                            addDanceMovieToList (currentUserDanceMove, k, j, list);
                            currentUserDanceMove = null;
                            break;
                        }
                    }
                    if (currentUserDanceMove == null) {
                        break;
                    }
                }
            }

//            trace ("-----------4----------");
//            traceList (list);
//            trace ("----------------------");

            //Формируем список на основе дерева:
            for (j = 0; j < list.length; j++) {
                row = list [j];
                for (k = 0; k < row.length; k++) {
                    currentUserDanceMove = row [k];
                    if (currentUserDanceMove != null) {
                        var danceMoviesListItem:DanceMovesListItem = new DanceMovesListItem ();
                        danceMoviesListItem.addEventListener (MouseEvent.CLICK, clickListener);
                        danceMoviesListItem.userDanceMove = currentUserDanceMove;
                        var danceMovieId:String = currentUserDanceMove.type.id;
                        if (dependentUserDanceMoviesAsObject.hasOwnProperty (danceMovieId)) {
                            if (dependentUserDanceMoviesAsObject [danceMovieId] == null) /*двжение было добавлено*/ {
                                danceMoviesListItem.showArrowDown ();
                            }
                        }
                        danceMoviesListItem.x = k * STEP;
                        danceMoviesListItem.y = j * STEP;
                        container.addChild (danceMoviesListItem);
                        danceMoviesListItems.push (danceMoviesListItem);
                    }
                }
            }

            //set scroll params:
            this.numItems = list.length;
            moveTo (0);

            container.graphics.clear ();
            container.graphics.beginFill (0x00ff00, 0);
            container.graphics.drawRect (0, 0, WIDTH, container.height);
            container.graphics.endFill ();

            danceMovieForLearning = null;
        }

        public function updateInfo ():void {
            for (var i:int = 0; i < danceMoviesListItems.length; i++) {
                danceMoviesListItems [i].updateInfo ();
            }
        }

        public function lockMouseWheel ():void {
            useMouseWheel = false;
        }

        public function unLockMouseWheel ():void {
            useMouseWheel = true;
        }

        override public function clear ():void {
            for (var i:int = 0; i < danceMoviesListItems.length; i++) {
                var danceMoviesListItem:DanceMovesListItem = danceMoviesListItems [i];
                danceMoviesListItem.removeEventListener (MouseEvent.CLICK, clickListener);
                if (container.contains (danceMoviesListItem)) {
                    container.removeChild (danceMoviesListItem);
                }
                danceMoviesListItem.destroy ();
            }
            danceMoviesListItems = new Vector.<DanceMovesListItem> ();
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function traceList (list:Vector.<Vector.<UserDanceMove>>):void {
            for (var j:int = 0; j < list.length; j++) {
                var row:Vector.<UserDanceMove> = list [j];
                var rowString:String = "";
                for (var k:int = 0; k < row.length; k++) {
                    var currentUserDanceMove:UserDanceMove = row [k];
                    if (currentUserDanceMove != null) {
                        rowString += "[" + currentUserDanceMove.type.id + "]";
                    }
                    else {
                        rowString += "[null]";
                    }
                }
                trace (rowString);
            }
        }

        private static function andAddDependentDanceMovieToList (userDanceMovie:UserDanceMove, posX:int, posY:int, list:Vector.<Vector.<UserDanceMove>>, dependentUserDanceMoviesAsObject:Object):void {
            var stepId:String = userDanceMovie.type.id;
            var dependentUserDanceMove:UserDanceMove = dependentUserDanceMoviesAsObject [stepId];
            if (dependentUserDanceMove) {
                addDanceMovieToList (dependentUserDanceMove, posX, posY + 1, list);
                dependentUserDanceMoviesAsObject [stepId] = null;
                andAddDependentDanceMovieToList (dependentUserDanceMove, posX, posY + 1, list, dependentUserDanceMoviesAsObject);
            }
        }

        private static function addDanceMovieToList (userDanceMovie:UserDanceMove, posX:int, posY:int, list:Vector.<Vector.<UserDanceMove>>):void {
            var row:Vector.<UserDanceMove>;
            if (list.length >= posY + 1) {
                row = list [posY];
            }
            else {
                row = new Vector.<UserDanceMove> ();
                row.length = NUM_ITEMS_IN_ROW;
                list [posY] = row;
            }
            row [posX] = userDanceMovie;
        }

/////////////////////////////////////////////
//LISTENERS:
/////////////////////////////////////////////

        private function clickListener (event:MouseEvent):void {
            var danceMoviesListItem:DanceMovesListItem = DanceMovesListItem (event.currentTarget);
            var danceMove:UserDanceMove = danceMoviesListItem.userDanceMove;
            if (danceMove) {
                dispatchEvent (new SelectDanceMove (danceMove));
            }
        }

    }
}
