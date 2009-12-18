package {
    public class Actor {
        private var _game:Game;
        public var pos:V2;

        public function get game():Game { return _game; }

        public function Actor(game:Game, pos:V2 = null)
        {
            _game = game;
            this.pos = pos || new V2(0, 0);
        }
    }
}
