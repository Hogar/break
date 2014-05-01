/**
 * Created by IntelliJ IDEA.
 * User: Hogar
 * Date: 08.02.12
 * Time: 11:18
 * To change this template use File | Settings | File Templates.
 */
package com.hogargames.utils {

    import com.hogargames.geom.Line;

    import flash.geom.Point;

    /**
     * Утилиты для работы с геометрическими объектами.
     */
    public class GeometricUtilities {

        /**
         * Пересечение окружности и прямой. Прямая задаётся по двум точкам.
         *
         * @param lineX1 Координата x первой точки прямой.
         * @param lineY1 Координата y первой точки прямой.
         * @param lineX2 Координата x второй точки прямой.
         * @param lineY2 Координата y второй точки прямой.
         * @param circleX Координата x окружности.
         * @param circleY Координата y окружности.
         * @param circleRadius Радиус окружности.
         *
         * @return Точки пересечения окружности и прямой.
         */
        public static function getCircleAndLineIntersection (lineX1:Number, lineY1:Number, lineX2:Number, lineY2:Number, circleX:Number, circleY:Number, circleRadius:Number):Vector.<Point> {

            var a:Number;
            var b:Number;
            var c:Number;

            var line:Line = Line.getLineForTwoPoints (new Point (lineX1, lineY1), new Point (lineX2, lineY2));

            if (line.isParallelToYAxis ()) {
                a = 1;
                b = (-2 * circleY);
                c = Math.pow (circleY, 2) + Math.pow (lineX1 - circleX, 2) - Math.pow (circleRadius, 2);
            }
            else {
                a = 1 + Math.pow (line.k, 2);
                b = (-2 * circleX) + (-2 * circleY) * (line.k) + 2 * (line.k) * (line.b);
                c = Math.pow ((line.b), 2) + (-2 * circleY) * (line.b) + Math.pow (circleX, 2) +
                    Math.pow (circleY, 2) - Math.pow (circleRadius, 2);
            }

            //calculate 2 roots of the equation:
            var result_1:Number;
            var result_2:Number;
            var d:Number = Math.pow (b, 2) - 4 * a * c;
            if (d > 0) {
                result_1 = (-b + Math.sqrt (d)) / (2 * a);
                result_2 = (-b - Math.sqrt (d)) / (2 * a);
            }
            else if (d == 0) {
                result_1 = -b / 2 * a;
            }

            var points:Vector.<Point> = new Vector.<Point> ();
            var results:Array/*of Number*/ = [result_1, result_2];
            for (var i:int = 0; i < results.length; i++) {
                if (!isNaN (results [i])) {
                    var pointX:Number;
                    var pointY:Number;
                    if (line.isParallelToYAxis ()) {
                        pointX = lineX1;
                        pointY = results [i];
                    }
                    else {
                        pointX = results [i];
                        pointY = line.getY (pointX);
                    }
                    var point:Point = new Point (pointX, pointY);
                    points.push (point);
                }
            }

            return points;
        }

        /**
         * Пересечение окружности и параболы.
         *
         * <p>Формула параболы:</p>
         * <p><code>y = A ~~ (x + B) ^ 2 + C</code></p>
         *
         * @param parabolaA Коэффициент A параболы.
         * @param parabolaB Коэффициент B параболы.
         * @param parabolaC Коэффициент C параболы.
         * @param circleX Координата x окружности.
         * @param circleY Координата y окружности.
         * @param circleRadius Радиус окружности.
         *
         * @return Точки пересечения окружности и параболы.
         */
        public static function getCircleAndParabolaIntersection (parabolaA:Number, parabolaB:Number, parabolaC:Number, circleX:Number, circleY:Number, circleRadius:Number):Vector.<Point> {

            if (parabolaB == -circleX) {
                parabolaB += .001;
            }

            var a:Number = Math.pow (parabolaA, 2);
            var b:Number = 4 * Math.pow (parabolaA, 2) * parabolaB;
            var c:Number = 1 + 2 * parabolaA * (3 * parabolaA * Math.pow (parabolaB, 2) + parabolaC - circleY);
            var d:Number = -2 * circleX + 4 * parabolaA * parabolaB * (parabolaA * Math.pow (parabolaB, 2) +
                                                                       parabolaC - circleY);
            var e:Number = parabolaA * Math.pow (parabolaB, 2) * (parabolaA * Math.pow (parabolaB, 2) + 2 * parabolaC -
            2 * circleY) + Math.pow ((parabolaC - circleY), 2) + Math.pow (circleX, 2) - Math.pow (circleRadius, 2);


            //calculate 4 roots of the equation:
            var result_1:Number = -.5 * Math.sqrt (Math.pow (b, 2) / (4 * Math.pow (a, 2)) + Math.pow ((Math.sqrt (
            Math.pow (( -72 * a * c * e + 27 * a * Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d +
            2 * Math.pow (c, 3)), 2) - 4 * Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a *
            c * e + 27 * a * Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)),
            (1 / 3)) / (3 * Math.pow (2, (1 / 3)) * a) + (Math.pow (2, (1 / 3)) * (12 * a * e - 3 * b * d +
            Math.pow (c, 2))) / (3 * a * Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 *
            Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3))) -
            (2 * c) / (3 * a)) - .5 * Math.sqrt (Math.pow (b, 2) / (2 * Math.pow (a, 2)) - ( -Math.pow (b, 3) /
            Math.pow (a, 3) + (4 * b * c) / Math.pow (a, 2) - (8 * d) / a) / (4 * Math.sqrt (Math.pow (b, 2) /
            (4 * Math.pow (a, 2)) + Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 *
            Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3)) /
            (3 * Math.pow (2, (1 / 3)) * a) + (Math.pow (2, (1 / 3)) * (12 * a * e - 3 * b * d +
            Math.pow (c, 2))) / (3 * a * Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 *
            Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3))) -
            (2 * c) / (3 * a))) - Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 *
            Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3)) / (3 *
            Math.pow (2, (1 / 3)) * a) - (Math.pow (2, (1 / 3)) * (12 * a * e - 3 * b * d + Math.pow (c, 2))) /
            (3 * a * Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a * Math.pow (d, 2) + 27 *
            Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 * Math.pow ((12 * a * e - 3 * b *
            d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a * Math.pow (d, 2) + 27 * Math.pow (b, 2) * e -
            9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3))) - (4 * c) / (3 * a)) - b / (4 * a);


            var result_2:Number = -.5 * Math.sqrt (Math.pow (b, 2) / (4 * Math.pow (a, 2)) + Math.pow ((Math.sqrt (
            Math.pow (( -72 * a * c * e + 27 * a * Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d +
            2 * Math.pow (c, 3)), 2) - 4 * Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a *
            c * e + 27 * a * Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)),
            (1 / 3)) / (3 * Math.pow (2, (1 / 3)) * a) + (Math.pow (2, (1 / 3)) * (12 * a * e - 3 * b * d +
            Math.pow (c, 2))) / (3 * a * Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 *
            Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3))) -
            (2 * c) / (3 * a)) + .5 * Math.sqrt (Math.pow (b, 2) / (2 * Math.pow (a, 2)) - ( -Math.pow (b, 3) /
            Math.pow (a, 3) + (4 * b * c) / Math.pow (a, 2) - (8 * d) / a) / (4 * Math.sqrt (Math.pow (b, 2) /
            (4 * Math.pow (a, 2)) + Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 *
            Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3)) /
            (3 * Math.pow (2, (1 / 3)) * a) + (Math.pow (2, (1 / 3)) * (12 * a * e - 3 * b * d +
            Math.pow (c, 2))) / (3 * a * Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 *
            Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3))) -
            (2 * c) / (3 * a))) - Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 *
            Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3)) / (3 *
            Math.pow (2, (1 / 3)) * a) - (Math.pow (2, (1 / 3)) * (12 * a * e - 3 * b * d + Math.pow (c, 2))) /
            (3 * a * Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a * Math.pow (d, 2) + 27 *
            Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 * Math.pow ((12 * a * e - 3 * b *
            d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a * Math.pow (d, 2) + 27 * Math.pow (b, 2) * e -
            9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3))) - (4 * c) / (3 * a)) - b / (4 * a);

            var result_3:Number = .5 * Math.sqrt (Math.pow (b, 2) / (4 * Math.pow (a, 2)) + Math.pow ((Math.sqrt (
            Math.pow (( -72 * a * c * e + 27 * a * Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d +
            2 * Math.pow (c, 3)), 2) - 4 * Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a *
            c * e + 27 * a * Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)),
            (1 / 3)) / (3 * Math.pow (2, (1 / 3)) * a) + (Math.pow (2, (1 / 3)) * (12 * a * e - 3 * b * d +
            Math.pow (c, 2))) / (3 * a * Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 *
            Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3))) -
            (2 * c) / (3 * a)) - .5 * Math.sqrt (Math.pow (b, 2) / (2 * Math.pow (a, 2)) + ( -Math.pow (b, 3) /
            Math.pow (a, 3) + (4 * b * c) / Math.pow (a, 2) - (8 * d) / a) / (4 * Math.sqrt (Math.pow (b, 2) /
            (4 * Math.pow (a, 2)) + Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 *
            Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3)) /
            (3 * Math.pow (2, (1 / 3)) * a) + (Math.pow (2, (1 / 3)) * (12 * a * e - 3 * b * d +
            Math.pow (c, 2))) / (3 * a * Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 *
            Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3))) -
            (2 * c) / (3 * a))) - Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 *
            Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3)) / (3 *
            Math.pow (2, (1 / 3)) * a) - (Math.pow (2, (1 / 3)) * (12 * a * e - 3 * b * d + Math.pow (c, 2))) /
            (3 * a * Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a * Math.pow (d, 2) + 27 *
            Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 * Math.pow ((12 * a * e - 3 * b *
            d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a * Math.pow (d, 2) + 27 * Math.pow (b, 2) * e -
            9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3))) - (4 * c) / (3 * a)) - b / (4 * a);


            var result_4:Number = .5 * Math.sqrt (Math.pow (b, 2) / (4 * Math.pow (a, 2)) + Math.pow ((Math.sqrt (
            Math.pow (( -72 * a * c * e + 27 * a * Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d +
            2 * Math.pow (c, 3)), 2) - 4 * Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a *
            c * e + 27 * a * Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)),
            (1 / 3)) / (3 * Math.pow (2, (1 / 3)) * a) + (Math.pow (2, (1 / 3)) * (12 * a * e - 3 * b * d +
            Math.pow (c, 2))) / (3 * a * Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 *
            Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3))) -
            (2 * c) / (3 * a)) + .5 * Math.sqrt (Math.pow (b, 2) / (2 * Math.pow (a, 2)) + ( -Math.pow (b, 3) /
            Math.pow (a, 3) + (4 * b * c) / Math.pow (a, 2) - (8 * d) / a) / (4 * Math.sqrt (Math.pow (b, 2) /
            (4 * Math.pow (a, 2)) + Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 *
            Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3)) /
            (3 * Math.pow (2, (1 / 3)) * a) + (Math.pow (2, (1 / 3)) * (12 * a * e - 3 * b * d +
            Math.pow (c, 2))) / (3 * a * Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 *
            Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3)))
            - (2 * c) / (3 * a))) - Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 *
            Math.pow ((12 * a * e - 3 * b * d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a *
            Math.pow (d, 2) + 27 * Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3)) / (3 *
            Math.pow (2, (1 / 3)) * a) - (Math.pow (2, (1 / 3)) * (12 * a * e - 3 * b * d + Math.pow (c, 2))) /
            (3 * a * Math.pow ((Math.sqrt (Math.pow (( -72 * a * c * e + 27 * a * Math.pow (d, 2) + 27 *
            Math.pow (b, 2) * e - 9 * b * c * d + 2 * Math.pow (c, 3)), 2) - 4 * Math.pow ((12 * a * e - 3 * b *
            d + Math.pow (c, 2)), 3)) - 72 * a * c * e + 27 * a * Math.pow (d, 2) + 27 * Math.pow (b, 2) * e -
            9 * b * c * d + 2 * Math.pow (c, 3)), (1 / 3))) - (4 * c) / (3 * a)) - b / (4 * a);

            var points:Vector.<Point> = new Vector.<Point> ();
            var results:Array/*of Number*/ = [result_1, result_2, result_3, result_4];
            for (var i:int = 0; i < results.length; i++) {
                //trace ("result [" + i + "] = " + results [i]);
                if (!isNaN (results [i]) && isFinite (results [i])) {
                    var pointX:Number = results [i];
                    var pointY:Number = parabolaA * Math.pow (pointX + parabolaB, 2) + parabolaC;
                    var point:Point = new Point (pointX, pointY);
                    points.push (point);
                }
            }

//            trace ("----");
//            trace ("parabolaA = " + parabolaA);
//            trace ("parabolaB = " + parabolaB);
//            trace ("parabolaC = " + parabolaC);
//            trace ("circleX = " + circleX);
//            trace ("circleY = " + circleY);
//            trace ("circleRadius = " + circleRadius);
//            trace ("a = " + a);
//            trace ("b = " + b);
//            trace ("c = " + c);
//            trace ("d = " + d);
//            trace ("e = " + e);
//            trace ("result_1 = " + result_1);
//            trace ("result_2 = " + result_2);
//            trace ("result_3 = " + result_3);
//            trace ("result_4 = " + result_4);

            return points;
        }

        /**
         * Получение угла образованого прямой и осью X.
         *
         * @param lineX1 Координата x первой точки прямой.
         * @param lineY1 Координата y первой точки прямой.
         * @param lineX2 Координата x второй точки прямой.
         * @param lineY2 Координата y второй точки прямой.
         *
         * @return Угол образованый прямой и осью X (в градусах).
         */
        public static function getLineAndXAxisAngle (lineX1:Number, lineY1:Number, lineX2:Number, lineY2:Number):Number {
            var rotate:Number = Math.atan2 (lineY2 - lineY1, lineX2 - lineX1);
            var degrees:Number = Math.floor (rotate * 180 / Math.PI);
            return degrees;
        }

        /**
         * Получение точки пересечения двух прямых.
         *
         * @param line1Point1 Первая точка первой прямой.
         * @param line1Point2 Вторая точка первой прямой.
         * @param line2Point1 Первая точка второй прямой.
         * @param line2Point2 Вторая точка второй прямой.
         *
         * @return Точка пересечения двух прямых. Возвращает <code>null</code>, если прямые не пересекаются.
         */
        public static function getTwoLinesIntersection (line1Point1:Point, line1Point2:Point, line2Point1:Point, line2Point2:Point):Point {
            var point:Point = new Point ();
            var line1:Line = Line.getLineForTwoPoints (line1Point1, line1Point2);
            var line2:Line = Line.getLineForTwoPoints (line2Point1, line2Point2);
            if (line1.isParallelToYAxis ()) {
                if (line2.isParallelToYAxis ()) {
                    return null;
                }
                else {
                    point.x = line1.b;
                    point.y = line2.getY (point.x);
                }
            }
            else {
                if (line2.isParallelToYAxis ()) {
                    point.x = line2.b;
                    point.y = line1.getY (point.x);
                }
                else {
                    if (line1.k == line2.k) {
                        return null;
                    }
                    else {
                        point.x = (line1.b - line2.b) / (line2.k - line1.k);
                        point.y = (line2.k * line1.b - line1.k * line2.b) / (line2.k - line1.k);
                    }
                }
            }
            return point;
        }

        /**
         * Получение точек пересечения прямой и параболы.
         *
         * <p>Формула параболы:</p>
         * <p><code>y = A ~~ (x + B) ^ 2 + C</code></p>
         *
         * @param linePoint1 Первая точка прямой.
         * @param linePoint1 Вторая точка прямой.
         * @param parabolaA Коэффициент A параболы.
         * @param parabolaB Коэффициент B параболы.
         * @param parabolaC Коэффициент C параболы.
         *
         * @return Точки пересечения прямой и параболы.
         */
        public static function getLineAndParabolaIntersection (linePoint1:Point, linePoint2:Point, parabolaA:Number, parabolaB:Number, parabolaC:Number):Vector.<Point> {
            var line:Line = Line.getLineForTwoPoints (linePoint1, linePoint2);
            var points:Vector.<Point> = new Vector.<Point> ();
            var point:Point;
            if (line.isParallelToYAxis ()) {
                point = new Point (line.b, parabolaA * Math.pow ((line.b + parabolaB), 2) + parabolaC);
                points.push (point);
            }
            else {
                var a:Number = parabolaA;
                var b:Number = 2 * parabolaA * parabolaB - line.k;
                var c:Number = parabolaA * Math.pow (parabolaB, 2) + parabolaC - line.b;

                //calculate 2 roots of the equation:
                var result_1:Number;
                var result_2:Number;
                var d:Number = Math.pow (b, 2) - 4 * a * c;
                if (d > 0) {
                    result_1 = (-b + Math.sqrt (d)) / (2 * a);
                    result_2 = (-b - Math.sqrt (d)) / (2 * a);
                }
                else if (d == 0) {
                    result_1 = -b / 2 * a;
                }

                var results:Array/*of Number*/ = [result_1, result_2];
                for (var i:int = 0; i < results.length; i++) {
                    if (!isNaN (results [i])) {
                        var pointX:Number = results [i];
                        var pointY:Number = line.getY (pointX);
                        point = new Point (pointX, pointY);
                        points.push (point);
                    }
                }
            }
            return points;
        }

        /**
         * Получение касательной к параболе в точке с координатой x0.
         *
         * <p>Формула параболы:</p>
         * <p><code>y = A ~~ (x + B) ^ 2 + C</code></p>
         *
         * @param x Координата x точки касания.
         * @param parabolaA Коэффициент A параболы.
         * @param parabolaB Коэффициент B параболы.
         * @param parabolaC Коэффициент C параболы.
         *
         * @return Представление прямой.
         */
        public static function getTangentToTheParabola (x:Number, parabolaA:Number, parabolaB:Number, parabolaC:Number):Line {
            var line:Line = new Line ();
            line.k = 2 * parabolaA * (x + parabolaB);
            line.b = parabolaA * Math.pow (parabolaB, 2) - parabolaA * Math.pow (x, 2) + parabolaC;
            return line;
        }

        /**
         * Корректирует значение угла до ближайшего граничного значения, если оно выходит за указанный промежуток.
         *
         * @param angle Значение угла.
         * @param minAngle Минимальный возможный угол.
         * @param maxAngle Максимальный возможный угол.
         *
         * @return Скорректированное значение угла.
         */
        public static function angleCorrection (angle:Number, minAngle:Number, maxAngle:Number):Number {
            while (minAngle > 360) {
                minAngle -= 360;
            }
            while (minAngle < 0) {
                minAngle += 360;
            }
            while (maxAngle > 360) {
                maxAngle -= 360;
            }
            while (maxAngle < 0) {
                maxAngle += 360;
            }
            while (minAngle > maxAngle) {
                maxAngle += 360;
            }
            while (angle > 360) {
                angle -= 360;
            }
            while (angle < 0) {
                angle += 360;
            }
            if ((maxAngle > 360) && (angle < minAngle)) {
                angle += 360;
            }
            if (angle < minAngle || angle > maxAngle) {
                var minCorrectionAngle:Number = maxAngle;
                var maxCorrectionAngle:Number = minAngle + 360;
                var centerOfCorrection:Number = minCorrectionAngle + (maxCorrectionAngle - minCorrectionAngle) / 2;
                while (centerOfCorrection < minCorrectionAngle) {
                    centerOfCorrection += 360;
                }
                while (angle < minCorrectionAngle) {
                    angle += 360;
                }
                if ((angle >= minCorrectionAngle) && (angle <= centerOfCorrection)) {
                    angle = maxAngle;
                }
                else {
                    angle = minAngle;
                }
                while (angle > 360) {
                    angle -= 360;
                }
                while (angle < 0) {
                    angle += 360;
                }
            }
            return angle;
        }


    }
}
