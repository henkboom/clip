package {
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.KeyboardEvent;

    public class GameManager implements IScene {
        private var game:Game;
        
        private var left:Boolean = false;
        private var right:Boolean = false;

        private var jump:Boolean = false;
        private var lastJump:Boolean = false;

        public function GameManager(core:Core)
        {
            game = new Game(core);
            game.util.controlDirection = 0;
            game.util.controlJump = false;
            game.util.controlJumpHeld = false;
            core.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
            core.addEventListener(KeyboardEvent.KEY_UP, onKey);

            Level.init(game, 1);
        }

        public function update():void {
            game.util.controlJump = jump && !lastJump;
            game.util.controlJumpHeld = jump;
            lastJump = jump;
            game.update();
        }

        public function draw(buffer:BitmapData):void {
            game.draw(buffer);
        }
        
        private function onKey(event:KeyboardEvent):void {
            var down:Boolean = event.type == KeyboardEvent.KEY_DOWN;

            if(event.keyCode == 37) left = down;
            else if(event.keyCode == 39) right = down;
            else if(event.keyCode == 38) jump = down;

            game.util.controlDirection = (right ? 1 : 0) - (left ? 1 : 0);
        }
    }
}
