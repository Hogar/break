/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 13.04.12
 * Time: 5:55
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.display.animation {

    import com.hogargames.debug.Tracer;
    import com.hogargames.errors.SingletonError;

    import flash.display.MovieClip;
    import flash.system.System;

    /**
     * Менеджер растеризированных мувиклипов. Класс предназначен для растеризации и хранения растеризованных мувиклипов.
     *
     * <p>Класс является синглтоном.</p>
     */
    public class CacheMovieClipsManager {

        private static var _instance:CacheMovieClipsManager;

        private static var cacheMovieClips:Object = { };

        public function CacheMovieClipsManager (key:SingletonKey = null) {
            if (!key) {
                throw new SingletonError ();
            }
        }

/////////////////////////////////////////////
//PUBLIC:
/////////////////////////////////////////////

        public static function getInstance ():CacheMovieClipsManager {
            if (!_instance) {
                _instance = new CacheMovieClipsManager (new SingletonKey ());
            }
            return _instance;
        }

        /**
         * Растеризация мувиклипа и добавление его в хранилище растеризованных мувиклипов.
         * @param id Id'шник мувиклипа, для его добавления в хранилище.
         * @param mc Мувиклип для растеризации.
         * @return Растеризованный мувиклип.
         */
        public function addCacheMovieClip (id:String, mc:MovieClip):CacheMovieClip {
            var cmc:CacheMovieClip = new CacheMovieClip ();
            cmc.buildFromMovieClip (mc);
            Tracer.log ("Cache Movie Clip: " + id + "; totalMemory = " + Math.floor (((System.totalMemory / 1024) / 1024) * 10) / 10 + " Mb");
            cacheMovieClips [id] = cmc;
            return cmc;
        }

        /**
         * Получение ранее растеризованного и добавленного в хранилище мувиклипа.
         * @param id Id'шник растеризованного мувиклипа.
         * @return Растеризованный мувиклип. Если мувиклипа с таким id'шником нету в хранилище, возвращает <code>null</code>.
         */
        public function getCacheMovieClip (id:String):CacheMovieClip {
            var clip:CacheMovieClip;
            if (cacheMovieClips [id] != null) {
                clip = new CacheMovieClip ();
                clip.frames = cacheMovieClips [id].frames;
                clip.offsets = cacheMovieClips [id].offsets;
                clip.labels = cacheMovieClips [id].labels;
                clip.gotoAndStop (1);
            }
            else {
                Tracer.log ('CacheMovieClip with id "' + id + '" not found.');
            }
            return clip;
        }

        /**
         * Проверка наличия растеризованного мувиклипа в хранилище.
         * @param id Id'шник растеризованного мувиклипа.
         * @return Если растеризованный мувиклип есть, то возвращает <code>true</code>.
         */
        public function hasCacheMovieClip (id:String):Boolean {
            return (cacheMovieClips [id] != null);
        }

    }
}

// internal class for singleton isolation
internal class SingletonKey {

    public function SingletonKey () {

    }

}