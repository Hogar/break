package com.hogargames.utils {

    /**
     * Утилиты для работы с числами.
     */
    public class NumericalUtilities {

        /**
         * Корректировка числа в пределах от <code>minValue</code> до <code>maxValue</code>.
         *
         * @param value Исходное число.
         * @param minValue Мининальное значение для корректировки.
         * @param maxValue Максимальное значение для корректировки.
         *
         * @return Скорректированное число.
         */
        public static function correctValue (value:Number, minValue:Number = 0, maxValue:Number = 1):Number {
            if (maxValue < minValue) {
                maxValue = minValue;
            }
            if (value < minValue) {
                value = minValue;
            }
            if (value > maxValue) {
                value = maxValue;
            }
            return (value);
        }

        /**
         * Проверка, принадлежит ли число интервалу от <code>minValue</code> до <code>maxValue</code>.
         *
         * @param value Число.
         * @param minValue Мининальное значение интервала.
         * @param maxValue Максимальное значение интервала.
         */
        public static function testValueAtInterval (value:Number, minValue:Number = 0, maxValue:Number = 1):Boolean {
            if (value >= minValue && value <= maxValue) {
                return true;
            }
            else {
                return false;
            }
        }

        /**
         * Проверка, имеют ли 2 числовых интервала общие точки.
         *
         * @param minValue1 Мининальное значение первого интервала.
         * @param maxValue1 Максимальное значение первого интервала.
         * @param minValue2 Мининальное значение второго интервала.
         * @param maxValue2 Максимальное значение второго интервала.
         */
        public static function testTwoIntervalIntersection (minValue1:Number = 0, maxValue1:Number = 1, minValue2:Number = 0, maxValue2:Number = 1):Boolean {
            if (minValue1 > minValue2) {
                return (maxValue2 >= minValue1);
            }
            else {
                return (maxValue1 >= minValue2);
            }
        }

        /**
         * Проверка и исправление значения <code>NaN</code>
         *
         * @param value Число для проверки.
         * @param unNaNValue Число, значение которого будет присваиваться проверяемому числу, в случае,
         * если проверяемое число имеет значение <code>NaN</code>.
         */
        public static function unNaN (value:Number, unNaNValue:Number = 0):Number {
            if (isNaN (value)) {
                value = unNaNValue;
            }
            return value;
        }

        //Пока только до десяти.
        public static function toRomanNumbers (value:int):String {
            //TODO:сделать не до 10, а универсальным:
            var str:String;
            if (value == 1) {
                str = "I";
            }
            else if (value == 2) {
                str = "II";
            }
            else if (value == 3) {
                str = "III";
            }
            else if (value == 4) {
                str = "IV";
            }
            else if (value == 5) {
                str = "V";
            }
            else if (value == 6) {
                str = "VI";
            }
            else if (value == 7) {
                str = "VII";
            }
            else if (value == 8) {
                str = "VIII";
            }
            else if (value == 9) {
                str = "IX";
            }
            else if (value == 10) {
                str = "X";
            }
            else {
                str = String (value);
            }
            return str;
        }
    }
}