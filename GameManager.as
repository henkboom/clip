package {
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class GameManager implements IScene {
        [Embed (source="bar.png")]
        private static var barSprite:Class;
        private static var barPoint:Point = new Point(0, 240-12);

        [Embed (source="button.png")]
        private static var buttonSprite:Class;
        private static var buttonPoint:Point = new Point(0, 240-12);
        private static var buttonMax:int = 320-12;

        [Embed (source="drag.png")]
        private static var dragSprite:Class;
        private static var dragPoint:Point = new Point(320-62, 240-12-28);

        private var core:Core;
        private var game:Game;
        
        private var left:Boolean = false;
        private var right:Boolean = false;

        private var jump:Boolean = false;
        private var lastJump:Boolean = false;

        private var time:int = 0;
        private var maxTime:int = 1200;

        private var level:int = 1;

        private var mouseHeld:Boolean = false;
        private var mouseTime:int = 0;

        private var controls:Array = new Array();

        public function GameManager(core:Core)
        {
            this.core = core;
            initGame();
            core.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
            core.addEventListener(KeyboardEvent.KEY_UP, onKey);
            core.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
            core.addEventListener(MouseEvent.MOUSE_UP, onMouse);
            core.addEventListener(MouseEvent.MOUSE_MOVE, onMouse);
        }

        public function initGame():void {
            time = 0;
            game = new Game(core);
            game.util.controlDirection = 0;
            game.util.controlJump = false;
            game.util.controlJumpHeld = false;
            lastJump = false;
            Level.init(game, level);
        }

        public function update():void {
            if(mouseHeld) {
                if(time != mouseTime) seekTo(mouseTime);
            }
            else {
                if(time < maxTime) {
                    controls[time] = {left: left, right: right, jump: jump};
                    doUpdate();
                }
                if(game.util.victory) {
                    level++;
                    initGame();
                }
            }
        }

        public function seekTo(targetTime:int):void {
            if(targetTime < time) {
                initGame();
            }
            while(time < targetTime) {
                if(!controls[time]) {
                    controls[time] =
                        {left: false, right: false, jump: false};
                }
                doUpdate();
            }
        }

        public function clearFuture():void {
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

            if(time == maxTime) {
                var drag:BitmapData = Resources.bitmap(dragSprite);
                buffer.copyPixels(drag, drag.rect, dragPoint, null, null,
                                  true);
            }
        }

        private function onMouse(event:MouseEvent):void {
            if(event.type == MouseEvent.MOUSE_DOWN && event.localY > 360-18) {
                mouseHeld = true;
                mouseTime = int((event.localX - 9.0)/(480-18) * maxTime);
            }
            else if(event.type == MouseEvent.MOUSE_UP) {
                mouseHeld = false;
                clearFuture();
            }
            else if(event.type == MouseEvent.MOUSE_MOVE) {
                mouseTime = int((event.localX - 9.0)/(480-18) * maxTime);
            }

            if(mouseTime < 1) mouseTime = 1;
            if(mouseTime > maxTime) mouseTime = maxTime;
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
