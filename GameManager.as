package {
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.geom.Point;

    public class GameManager implements IScene {
        [Embed (source="bar.png")]
        private static var barSprite:Class;
        private static var barPoint:Point = new Point(0, 240-12);

        [Embed (source="button.png")]
        private static var buttonSprite:Class;
        private static var buttonPoint:Point = new Point(0, 240-12);
        private static var buttonMax:int = 320-12;

        private var core:Core;
        private var game:Game;
        
        private var left:Boolean = false;
        private var right:Boolean = false;

        private var jump:Boolean = false;
        private var lastJump:Boolean = false;

        private var time:int = 0;
        private var maxTime:int = 1800;

        private var controls:Array = new Array();

        public function GameManager(core:Core)
        {
            this.core = core;
            initGame();
            core.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
            core.addEventListener(KeyboardEvent.KEY_UP, onKey);
        }

        public function initGame():void {
            game = new Game(core);
            game.util.controlDirection = 0;
            game.util.controlJump = false;
            game.util.controlJumpHeld = false;
            lastJump = false;
            Level.init(game, 1);
        }

        public function update():void {
            if(time < maxTime) {
                controls[time] = {left: left, right: right, jump: jump};
                doUpdate();
            }
        }

        public function seekTo(targetTime:int):void {
            if(targetTime < time) {
                initGame();
                time = 0;
            }
            while(time < targetTime) {
                if(!controls[time]) {
                    controls[time] =
                        {left: false, right: false, jump: false};
                }
                doUpdate();
            }
            for(var i:int = time; i < maxTime; i++) {
                delete controls[i];
            }
        }

        public function doUpdate():void {
            var c:Object = controls[time];
            game.util.controlDirection = (c.right ? 1 : 0) - (c.left ? 1 : 0);
            game.util.controlJump = c.jump && !lastJump;
            game.util.controlJumpHeld = c.jump;
            lastJump = c.jump;
            game.update();
            time = time + 1;
        }

        public function draw(buffer:BitmapData):void {
            game.draw(buffer);

            var bar:BitmapData = Resources.bitmap(barSprite);
            buffer.copyPixels(bar, bar.rect, barPoint, null, null, true);

            buttonPoint.x = Number(time)/maxTime * buttonMax;
            var button:BitmapData = Resources.bitmap(buttonSprite);
            buffer.copyPixels(button, button.rect, buttonPoint, null, null,
                              true);

        }
        
        private function onKey(event:KeyboardEvent):void {
            var down:Boolean = event.type == KeyboardEvent.KEY_DOWN;

            if(event.keyCode == 37) left = down;
            else if(event.keyCode == 39) right = down;
            else if(event.keyCode == 38) jump = down;
            else if(event.keyCode == 32 && down) seekTo(time - 300);
        }
    }
}
