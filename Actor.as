package {
    import flash.geom.Point;

    public class Actor {
        private var _game:Game;
        private var _pos:V2 = new V2(0, 0);

        public function get game():Game { return _game; }
        public function get pos():V2 { return _pos; }
        public function set pos(pos:V2):void { _pos = pos; }

        public function Actor(game:Game, pos:V2 = null)
        {
            _game = game;
            pos = pos || new V2(0, 0);
        }
    }
}
