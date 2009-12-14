package {
    public class PlayerActor extends SpriteActor {
        [Embed (source="player.png")]
        private var playerSprite:Class;

        private var controller:PlayerInputActor;

        private var onGround:Boolean = false;
        private var jumpTimer:Number = 0;
        private var xvel:Number = 0;
        private var yvel:Number = 0;

        public function PlayerActor(game:Game, pos:V2)
        {
            super(game, pos, playerSprite, new V2(0.5, 0));

            controller = new PlayerInputActor(game);
            game.addActor(controller);
        }
    
        public function update():void {
            // decrement counters
            yvel -= 0.25;
            if(yvel < -3) yvel = -3;

            if(jumpTimer > 0)
                jumpTimer--;

            // horizontal movement
            if(controller.x < 0) {
                if(xvel > -2) xvel-=0.25;
                if(xvel > 0) xvel-=0.25;
            } else if(controller.x > 0) {
                if(xvel < 2) xvel += 0.25;
                if(xvel < 0) xvel += 0.25;
            } else if(xvel < 0) {
                xvel += 0.25;
                if(xvel < 0) xvel += 0.25
            } else if(xvel > 0) {
                xvel -= 0.25;
                if(xvel > 0) xvel -= 0.25
            }
            if(xvel > 6) xvel = 6
            if(xvel < -6) xvel = -6

            while(!move(V2.add(pos, new V2(xvel, 0)))) {
                if(xvel < 0)
                    xvel += 0.25;
                else
                    xvel -= 0.25;
            }

            // jump controls
            if(controller.jump) {
                if(onGround) {
                    if(controller.x > 0) xvel += 1
                    if(controller.x < 0) xvel -= 1
                    jumpTimer = 12;
                }
                if(onGround || jumpTimer > 0) {
                    yvel = 3;
                    onGround = false;
                }
            }

            // vertical movement
            var hitCeil = false;
            while(!move(V2.add(pos, new V2(0, yvel)))) {
                if(yvel < 0) {
                    yvel += 0.25;
                    onGround = true;
                } else if (yvel > 0){
                    hitCeil = true;
                    yvel -= 0.25;
                    jumpTimer = 0;
                }
            }
            if(hitCeil) {
                if(Math.abs(xvel) < 1) xvel = 0;
                else if(xvel > 0) xvel-=1;
                else if(xvel < 0) xvel+=1;
            }
            if(yvel < 0)
                onGround = false;
        }

        private function move(newPos:V2):Boolean
        {
            var newRect:Rect =
                new Rect(newPos.x-width/2, newPos.y, width, height);
            if(game.util.collidesWithLevel(newRect)) {
                return false;
            } else {
                pos = newPos;
                return true;
            }
        }
    }
}

import flash.events.Event;
import flash.events.KeyboardEvent;

class PlayerInputActor {
    private var _x:Number = 0;
    public function get x():Number { return _x; }

    private var _jump:Boolean = false;
    public function get jump():Boolean { return _jump; }

    private var left:Boolean = false;
    private var right:Boolean = false;

    public function PlayerInputActor(game:Game) {
        game.core.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
        game.core.addEventListener(KeyboardEvent.KEY_UP, onKey);
    }

    private function onKey(event:KeyboardEvent):void {
        var down:Boolean = event.type == KeyboardEvent.KEY_DOWN;

        if(event.keyCode == 37) left = down
        else if(event.keyCode == 39) right = down
        else if(event.keyCode == 38) _jump = down

        _x = (right ? 1 : 0) - (left ? 1 : 0);
    }
}

