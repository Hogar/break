package breakdance.battle.view {

    import breakdance.data.video.VideoCollection;

    import com.greensock.TweenLite;
    import com.greensock.loading.VideoLoader;

    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;

    /**
     * Видео-плеер для отображения видео танц. движений.
     */
    public class DanceMoviePlayer {

        private var _template:MovieClip;
        private var container:Sprite;
        private var mcProgress:MovieClip;

        private var _completeCallback:Function;//Функция-обработчик завершения танц. движения.

        private var _danceMovesIds:Vector.<String>;

        private var _counter:int;//Счётчик для движений ожидания.

        private var _videoLoader:VideoLoader;

        private static const TWEEN_TIME:Number = .3;
        private static const TWEEN_DELAY:Number = .2;

        public function DanceMoviePlayer (template:MovieClip) {
            _template = template;

            container = new Sprite ();
            _template.addChild (container);

            _template.visible = false;

            _danceMovesIds = new Vector.<String> ();

            mcProgress = _template ["mcProgress"];
            mcProgress.visible = false;
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        /**
         * Показ видео для движения.
         * @param danceMoveId Id движения.
         * @param completeCallback Функция-обработчик завершения движения.
         */
        public function showMove (danceMoveId:String, completeCallback:Function):void {
//            trace ("Начинаем показ видео для движения " + danceMoveId);
            clear ();
            _completeCallback = completeCallback;

            _danceMovesIds = new Vector.<String> ();
            _danceMovesIds.push (danceMoveId);

            showNextMove ();
        }

        /**
         * Показ видео для движений.
         * @param danceMovesIds Список движений.
         * @param completeCallback Функция-обработчик завершения всех движений.
         */
        public function showMoves (danceMovesIds:Vector.<String>, completeCallback:Function):void {
            clear ();
            _completeCallback = completeCallback;
            _danceMovesIds = new Vector.<String> ();
            _danceMovesIds = _danceMovesIds.concat (danceMovesIds);

            showNextMove ();
        }

        /**
         * Показ видео для движения ожидания.
         * @param count Колличество повторов. Если -1, то повторяется бесконечно.
         * @param completeCallback Функция-обработчик завершения всех движений.
         * Вызывается после завершения всех повторов или каждый раз после завершения движения, если повторы бесконечны.
         */
        public function showStandMove (count:int = -1, completeCallback:Function = null):void {
            clear ();
            _completeCallback = completeCallback;
            _danceMovesIds = new <String> [];
            _counter = count;

            _videoLoader = VideoCollection.instance.getVideo (VideoCollection.STAND_DANCE_MOVE);
            _videoLoader.addEventListener (VideoLoader.VIDEO_COMPLETE, showNextStandMove);
            showVideo (_videoLoader);
        }

        /**
         * Остановка показа видео.
         */
        public function clear ():void {
            clearVideo ();
            clearParams ();
        }

        /**
         * Деактивация.
         */
        public function destroy ():void {
            clearVideo ();

            _danceMovesIds.length = 0;
            _danceMovesIds = null;

            _template = null;

            _completeCallback = null;
        }

/////////////////////////////////////////////
//PRIVATE:
/////////////////////////////////////////////

        private function showNextMove (event:* = null):void {
            clearVideo ();

            if (_danceMovesIds.length == 0) {
                if (_completeCallback != null) {
                    _completeCallback ();
                }
                return;
            }

            var moveId:String = _danceMovesIds [0];
            _danceMovesIds.splice (0, 1);

            _videoLoader = VideoCollection.instance.getVideo (moveId);
            _videoLoader.addEventListener (VideoLoader.VIDEO_COMPLETE, showNextMove);
            showVideo (_videoLoader);
        }

        private function showNextStandMove (event:* = null):void {
            clearVideo ();

            if (_counter == 0) {
                if (_completeCallback != null) {
                    _completeCallback ();
                }
            }
            else {
                if (_counter > 0) {
                    _counter --;
                }
                _videoLoader = VideoCollection.instance.getVideo (VideoCollection.STAND_DANCE_MOVE);
                _videoLoader.addEventListener (VideoLoader.VIDEO_COMPLETE, showNextStandMove);
                showVideo (_videoLoader);
                if (_counter == -1) {
                    if (_completeCallback != null) {
                        _completeCallback ();//Если видео повторяется бесконечно, то вызываем обработчик завершения после каждого движения.
                    }
                }
            }
        }

        private function showVideo (videoLoader:VideoLoader):void {
//            trace ("Отображаем видео.");
            videoLoader.addEventListener (VideoLoader.PLAY_PROGRESS, playProgressListener);
            videoLoader.gotoVideoTime (0, true);
            _template.visible = true;
            var content:DisplayObject = videoLoader.content;
            TweenLite.killTweensOf (content);
            container.addChild (content);
            content.alpha = 0;
            TweenLite.to (content, TWEEN_TIME, {alpha: 1, delay: TWEEN_DELAY});
        }

        private function clearVideo ():void {
            if (_videoLoader) {
//                trace ("Очищаем пердыдущее видео.");
                var content:DisplayObject = _videoLoader.content;
                if (content) {
                    TweenLite.killTweensOf (content);
                    TweenLite.to (content, TWEEN_TIME, {alpha:0, onComplete:onHideContent, onCompleteParams: [content]});
                }
                _videoLoader.removeEventListener (VideoLoader.VIDEO_COMPLETE, showNextMove);
                _videoLoader.removeEventListener (VideoLoader.VIDEO_COMPLETE, showNextStandMove);
                _videoLoader.removeEventListener (VideoLoader.PLAY_PROGRESS, playProgressListener);
                _videoLoader = null;
            }
            _template.visible = false;
        }

        private function onHideContent (content:DisplayObject):void {
//            trace ("Удаляем видео из списка отображения.");
            if (_videoLoader && (_videoLoader.content == content)) {
                return;
            }
            if (container.contains (content)) {
                container.removeChild (content);
            }
        }

        private function playProgressListener (event:Event):void {
            var videoLoader:VideoLoader = VideoLoader (event.currentTarget);
            if (videoLoader.duration - videoLoader.videoTime < TWEEN_TIME) {
                var content:DisplayObject = videoLoader.content;
                if (content) {
                    if (content.alpha == 1) {
//                        trace ("Скрываем видео.");
                        TweenLite.to (content, TWEEN_TIME, {alpha: 0});
                    }
                }
            }
        }

        private function clearParams ():void {
            _danceMovesIds = new <String> [];
            _completeCallback = null;
            _counter = 0;
        }
    }
}