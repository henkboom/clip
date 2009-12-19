package {
    public class Level {
        import flash.display.BitmapData;
        import flash.geom.Point;

        [Embed (source="l_walk.png")]
        private static var walkLevel:Class;

        [Embed (source="l_jump.png")]
        private static var jumpLevel:Class;

        [Embed (source="l_deep_jump.png")]
        private static var deepJumpLevel:Class;

        [Embed (source="l_climb.png")]
        private static var climbLevel:Class;

        [Embed (source="l_long_jump.png")]
        private static var longJumpLevel:Class;

        [Embed (source="l_trees.png")]
        private static var treesLevel:Class;

        [Embed (source="l_big.png")]
        private static var bigLevel:Class;

        [Embed (source="l_end.png")]
        private static var endLevel:Class;

        private static var levels:Array = [
            walkLevel,
            jumpLevel,
            deepJumpLevel,
            climbLevel,
            longJumpLevel,
            treesLevel,
            bigLevel,
            endLevel
        ]

        private static var emptyBlock:Object = {
            solid: false,
            actor: null
        };
        private static var wallBlock:Object = {
            solid: true,
            actor: WallActor
        };

        private static var colorMappings:Object = {
            0xffffff: emptyBlock,
            0x000000: wallBlock,
            0xff0000: "player",
            0x0000ff: "goal"
        };

        public static function init(game:Game, levelNumber:int):void {
            var cellSize:int = 8;

            //// INITIALIZE LEVEL
            var data:BitmapData = Resources.bitmap(levels[levelNumber-1]);
            var width:int = data.width;
            var height:int = data.height;

            var goalPos:V2;

            game.util.levelWidth = width * cellSize;
            game.util.levelHeight = height * cellSize;
            game.util.victory = false;

            var level:Array = new Array();
            var i:int, j:int;
            for(i = 0; i < width; i++)
            {
                level[i] = new Array();
                for(j = 0; j < height; j++)
                {
                    var cell:Object =
                        colorMappings[data.getPixel(i, height-j-1)];

                    if(!cell) {
                        throw new Error("unrecognized color at pixel "
                                        + i + ", " + (height-j-1) + " of level "
                                        + levelNumber);
                    }

                    if(cell == "player") {
                        var playerPos:V2 = new V2(i * cellSize + cellSize/2,
                                                  j * cellSize);
                        game.addActor(new PlayerActor(game, playerPos));
                        cell = emptyBlock;
                    } else if (cell == "goal") {
                        goalPos = new V2(i * cellSize,
                                         j * cellSize);
                        game.addActor(new GoalActor(game, goalPos));
                        cell = emptyBlock;
                    }

                    level[i][j] = cell;
                }
            }

            for(i = 0; i < width; i++)
                for(j = 0; j < height; j++)
                    if(level[i][j].actor) game.addActor(
                        new cell.actor(game, level, i, j));


            //// CHECK FOR COLLISION WITH LEVEL
            game.util.collidesWithLevel = function (rect:Rect):Boolean {
                var mini:int = Math.floor(rect.x / cellSize);
                var minj:int = Math.floor(rect.y / cellSize);
                var maxi:int = Math.ceil((rect.x + rect.w) / cellSize);
                var maxj:int = Math.ceil((rect.y + rect.h) / cellSize);
                var i:int, j:int;

                if(mini < 0) return true;
                if(maxi > width) return true;
                if(minj < 0) return true;
                if(maxj > height) maxj = height;

                for(i = mini; i < maxi; i++)
                for(j = minj; j < maxj; j++)
                {
                    if(level[i][j].solid)
                        return true;
                }
                return false;
            };

            game.util.checkVictory = function (rect:Rect):void {
                if(goalPos) {
                    var overlapX:Boolean = (rect.x < goalPos.x + 16) &&
                                           (rect.x + rect.w > goalPos.x );
                    var overlapY:Boolean = (rect.y < goalPos.y + 16) &&
                                           (rect.y + rect.h > goalPos.y );
                    if(overlapX && overlapY)
                        game.util.victory = true;
                }
            }

            //// DRAW THE LEVEL EVERY FRAME
            //game.addActor({
            //    draw: function (buffer:BitmapData):void {
            //        var point:Point = new Point();
            //        for(i = 0; i < width; i++)
            //        for(j = 0; j < height; j++)
            //        if(level[i][j].sprite)
            //        {
            //            var sprite:BitmapData = level[i][j].sprite;
            //            point.x = i * cellSize;
            //            point.y = buffer.height - j * cellSize - sprite.height;
            //            buffer.copyPixels(sprite, sprite.rect, point);
            //        }
            //    }
            //});
        }
    }
}

