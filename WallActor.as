package {
    public class WallActor extends SpriteActor {
        [Embed (source="block.png")]
        private static var blockSprite:Class;
        private static var blockAnimSpec:Object = {
            idle: {row: 0, frames: 1, duration: 1},
            blinking: {row: 1, frames: 3, duration: 15, after: "idle"}
        }

        private var countdown:int;

        public function WallActor(game:Game, pos:V2)
        {
            super(game, pos, blockSprite, new V2(0, 0), 8, 8, blockAnimSpec);
            countdown = Math.random() * 1500;
        }

        public function DISABLEDupdate():void {
            advanceAnimation(1);

            countdown--;
            if(countdown == 0) {
                setAnimationState("blinking");
                countdown = -1;
                countdown = 600 + Math.random() * 900;
            }
        }
    }
}
