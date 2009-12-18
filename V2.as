package {
    public class V2 {
        private var _x:Number; public function get x():Number { return _x; }
        private var _y:Number; public function get y():Number { return _y; }
    
        public function V2(x:Number, y:Number) {
            _x = x;
            _y = y;
        }
    
        public static function add(a:V2, b:V2):V2 {
            return new V2(a.x + b.x, a.y + b.y);
        }
    }
}
