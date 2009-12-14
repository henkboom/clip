package {
    public class Rect {
        private var _x:Number;
        private var _y:Number;
        private var _w:Number;
        private var _h:Number;

        public function get x():Number { return _x; }
        public function get y():Number { return _y; }
        public function get w():Number { return _w; }
        public function get h():Number { return _h; }

        public function Rect(x:Number, y:Number, w:Number, h:Number) {
            _x = x;
            _y = y;
            _w = w;
            _h = h;
        }
    }
}
