/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 26.03.12
 * Time: 4:05
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.geom {

    import flash.geom.Point;

    /**
     * Класс, описывающий прямую, заданнную уравнением y = k ~~ x + b.
     */
    public class Line {

        /**
         * Коэффициент <code>k</code> в уравнении прямой <code>y = k ~~ x + b</code>.
         */
        public var k:Number = 0;
        /**
         * Коэффициент <code>b</code> в уравнении прямой <code>y = k ~~ x + b</code>.
         */
        public var b:Number = 0;

        /**
         * Создание новой прямой, заданной уравнением <code>y = k ~~ x + b</code>.
         * @param k Коэффициент <code>k</code>.
         * @param b Коэффициент <code>b</code>.
         */
        public function Line (k:Number = 0, b:Number = 0) {
            this.k = k;
            this.b = b;
        }

        /**
         * Получение прямой по двум точкам.
         * @param point1 Первая точка.
         * @param point2 Вторая точка.
         * @return  Прямая.
         */
        public static function getLineForTwoPoints (point1:Point, point2:Point):Line {
            var line:Line = new Line ();
            if (point1.x == point2.x) {
                line.k = NaN;
                line.b = point1.x;
            }
            else {
                line.k = ((point1.y - point2.y) / (point1.x - point2.x));
                line.b = (point1.x * point2.y - point2.x * point1.y) / (point1.x - point2.x);
            }
            return line;
        }

        /**
         * Получение <code>y</code> по <code>x</code>.
         * @param x Координата <code>x</code>.
         * @return Координата <code>y</code>.
         */
        public function getY (x:Number):Number {
            return k * x + b;
        }

        /**
         * Получение <code>x</code> по <code>y</code>.
         * @param y Координата <code>y</code>.
         * @return Координата <code>x</code>.
         */
        public function getX (y:Number):Number {
            if (isParallelToYAxis ()) {
                return b;
            }
            else {
                return (y - b) / k;
            }
        }

        /**
         * Проверка, паралельна ли прямая оси Y.
         * @return Возвращает <code>true</code>, если прямая паралельна оси Y.
         */
        public function isParallelToYAxis ():Boolean {
            return (isNaN (k));
        }

    }
}
