package {
    public class PlayerActor extends SpriteActor {
        [Embed (source="player.png")]
        private static var playerSprite:Class;
        private static var playerAnimSpec:Object = {
            idle: {row: 0, frames: 8, duration: 15},
            walking: {row: 1, frames: 8, duration: 4},
            jumping: {row: 2, frames: 1, duration: 1},
            falling: {row: 3, frames: 1, duration: 1}
        }

        private const width:int = 12;
        private const height:int = 16;

        private var onGround:Boolean = false;
        private var jumpTimer:Number = 0;
        private var xvel:Number = 0;
        private var yvel:Number = 0;

        public function PlayerActor(game:Game, pos:V2)
        {
            super(game, pos, playerSprite, new V2(0.5, 0), width, height,
                  playerAnimSpec);
        }
    
        public function update():void {
            var cDir:Number = game.util.controlDirection;
            var cJump:Boolean = game.util.controlJump;
            var cJumpHeld:Boolean = game.util.controlJumpHeld;

            // counters
            yvel -= 0.25;
            if(yvel < -3) yvel = -3;

            if(jumpTimer > 0)
                jumpTimer--;

            // horizontal movement
            if(cDir < 0) {
                if(xvel > -1) xvel-=0.25;
                if(xvel > 0) xvel-=0.25;
            } else if(cDir > 0) {
                if(xvel < 1) xvel += 0.25;
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
            if(cJumpHeld) {
                if(cJump && onGround) {
                    if(cDir > 0) xvel += 1
                    if(cDir < 0) xvel -= 1
                    jumpTimer = 12;
                }
                if((cJump && onGround) || jumpTimer > 0) {
                    yvel = 3;
                    onGround = false;
                }
            } else {
                jumpTimer = 0;
            }

            // vertical movement
            var hitCeil:Boolean = false;
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

            if(cDir > 0) setFacing(1);
            else if(cDir < 0) setFacing(-1);

            if(onGround) {
                if(xvel == 0) {
                    setAnimationState("idle");
                    advanceAnimation(1);
                } else {
                    setAnimationState("walking");
                    advanceAnimation(Math.abs(xvel));
                }
            } else {
                if(yvel >= 0) {
                    setAnimationState("jumping");
                    advanceAnimation(1);
                } else {
                    setAnimationState("falling");
                    advanceAnimation(1);
                }
            }

            game.util.checkVictory(
                new Rect(pos.x-width/2, pos.y, width, height));

            game.util.xScroll =
                (Math.max(0, Math.min(pos.x-160, game.util.levelWidth-320)));
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
