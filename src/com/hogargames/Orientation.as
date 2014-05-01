/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 16.01.12
 * Time: 10:09
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames {

    import flash.geom.Point;

    /**
     * Класс для работы с направлениями. Хранит все возможные направления в виде констант. Описывает статические методы для определения направления, инверсии направления и т.д.
     */
    public class Orientation {

        /**
         * Нету направления
         */
        public static const NO_ORIENTATION:String = "no orientation";
        /**
         * Вверх
         */
        public static const UP:String = "up";
        /**
         * Вправо
         */
        public static const RIGHT:String = "right";
        /**
         * Вниз
         */
        public static const DOWN:String = "down";
        /**
         * Влево
         */
        public static const LEFT:String = "left";

        /**
         * Вправо-вверх
         */
        public static const RIGHT_UP:String = "right_up";
        /**
         * Вправо-вниз
         */
        public static const RIGHT_DOWN:String = "right_down";
        /**
         * Влево-вниз
         */
        public static const LEFT_DOWN:String = "left_down";
        /**
         * Влево-вверх
         */
        public static const LEFT_UP:String = "left_up";

        private static const orientations:Array = [UP, RIGHT, DOWN, LEFT, RIGHT_UP, RIGHT_DOWN, LEFT_DOWN, LEFT_UP];

        /**
         * Получение угола, кратного 45°, соответствующего заданному направлению.
         * Например, если направление равно <code>Orientation.RIGHT</code>, то угол будет равен 0°, Orientation.RIGHT_UP - 45° и т.д.
         * @param orientation Направление.
         * @return Угол, кратный 45°.
         */
        public static function getAngle (orientation:String):Number {
            var angle:Number = 0;
            switch (orientation) {
                case RIGHT:
                    angle = 0;
                    break;
                case RIGHT_UP:
                    angle = -45;
                    break;
                case UP:
                    angle = -90;
                    break;
                case LEFT_UP:
                    angle = -135;
                    break;
                case LEFT:
                    angle = 180;
                    break;
                case LEFT_DOWN:
                    angle = 135;
                    break;
                case DOWN:
                    angle = 90;
                    break;
                case RIGHT_DOWN:
                    angle = 45;
                    break;
            }
            return angle;
        }

        /**
         * Получение случайного направления.
         * @return Случайное направление. Например, <code>Orientation.RIGHT</code>.
         */
        public static function getRandomOrientation ():String {
            var randomOrientation:String = orientations [Math.round (Math.random () * (orientations.length - 1))];
            return randomOrientation;
        }

        /**
         * Определение направления по двум точкам.
         * @param point1 Первая точка, относительно которой определяется направление.
         * @param point2 Вторая точка.
         * Например, если координата <code>x</code> второй точки больше координаты <code>x</code> первой точки,
         * и координата <code>y</code> второй точки больше координаты <code>y</code> первой точки, то направление <code>Orientation.RIGHT_DOWN</code> и т.д.
         * @return Направление.
         */
        public static function getOrientationByTwoPoint (point1:Point, point2:Point):String {
            if (point1.x > point2.x) {
                if (point1.y > point2.y) {
                    return LEFT_UP;
                }
                else if (point1.y == point2.y) {
                    return LEFT;
                }
                else {
                    return LEFT_DOWN;
                }
            }
            else if (point1.x < point2.x) {
                if (point1.y > point2.y) {
                    return RIGHT_UP;
                }
                else if (point1.y == point2.y) {
                    return RIGHT;
                }
                else {
                    return RIGHT_DOWN;
                }
            }
            else {
                if (point1.y > point2.y) {
                    return UP;
                }
                else if (point1.y == point2.y) {
                    return NO_ORIENTATION;
                }
                else {
                    return DOWN;
                }
            }
        }

        /**
         * Получение противоположного направления.
         * @param orientation Направление.
         * @return Противоположное направление.
         */
        public static function inverseOrientation (orientation:String):String {
            switch (orientation) {
                case RIGHT:
                    return LEFT;
                case RIGHT_UP:
                    return LEFT_DOWN;
                case UP:
                    return DOWN;
                case LEFT_UP:
                    return RIGHT_DOWN;
                case LEFT:
                    return RIGHT;
                case LEFT_DOWN:
                    return RIGHT_UP;
                case DOWN:
                    return UP;
                case RIGHT_DOWN:
                    return LEFT_UP;
            }
            return NO_ORIENTATION;
        }

    }
}
