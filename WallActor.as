package {
    public class WallActor extends SpriteActor {
        [Embed (source="block.png")]
        private static var blockSprite:Class;
        private static var blockAnimSpec:Object = {
            idle: {row: 0, frames: 1, duration: 1},
            0: {row: 0, frames: 1, duration: 1},
            1: {row: 1, frames: 1, duration: 1},
            2: {row: 2, frames: 1, duration: 1},
            3: {row: 3, frames: 1, duration: 1},
            4: {row: 4, frames: 1, duration: 1},
            5: {row: 5, frames: 1, duration: 1},
            6: {row: 6, frames: 1, duration: 1},
            7: {row: 7, frames: 1, duration: 1},
            8: {row: 8, frames: 1, duration: 1},
            9: {row: 9, frames: 1, duration: 1},
            10: {row: 10, frames: 1, duration: 1},
            11: {row: 11, frames: 1, duration: 1},
            12: {row: 12, frames: 1, duration: 1},
            13: {row: 13, frames: 1, duration: 1},
            14: {row: 14, frames: 1, duration: 1},
            15: {row: 15, frames: 1, duration: 1}
        }

        private var countdown:int;

        public function WallActor(game:Game, level:Array, x:int, y:int)
        {
            super(game, new V2(x*8, y*8), blockSprite,
                  new V2(0, 0), 8, 8, blockAnimSpec);
            var index:int = 0;
            if(level[x+1] && level[x+1][y].actor == WallActor) index += 1;
            if(level[x][y+1] && level[x][y+1].actor == WallActor) index += 2;
            if(level[x-1] && level[x-1][y].actor == WallActor) index += 4;
            if(level[x][y-1] && level[x][y-1].actor == WallActor) index += 8;

            setAnimationState(String(index));

            countdown = Math.random() * 1500;
        }
    }
}
