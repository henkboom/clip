package {
    public class Level {
        import flash.display.BitmapData;
        import flash.geom.Point;

        public static function init(game:Game):void {
            var width:int = 20;
            var height:int = 15;
            var cellSize:int = 16;

            //// INITIALIZE LEVEL
            // TODO: load from image
            var level:Array = new Array();
            var i:int, j:int;
            for(i = 0; i < width; i++)
            {
                level[i] = new Array();
                for(j = 0; j < height; j++)
                {
                    level[i][j] = block_empty;
                }
            }
            level[0][0] = block_wall;
            level[1][0] = block_wall;
            level[2][0] = block_wall;
            level[3][0] = block_wall;
            level[4][0] = block_wall;
            level[5][0] = block_wall;
            level[6][0] = block_wall;
            level[7][0] = block_wall;
            level[1][2] = block_wall;
            level[2][2] = block_wall;

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

            //// DRAW THE LEVEL EVERY FRAME
            game.addActor({
                draw: function (buffer:BitmapData):void {
                    var point:Point = new Point();
                    for(i = 0; i < width; i++)
                    for(j = 0; j < height; j++)
                    if(level[i][j].sprite)
                    {
                        var sprite:BitmapData = level[i][j].sprite;
                        point.x = i * cellSize;
                        point.y = buffer.height - j * cellSize - sprite.height;
                        buffer.copyPixels(sprite, sprite.rect, point);
                    }
                }
            });
        }
    }
}

var block_empty:Object = {solid: false, sprite: null};
var block_wall:Object = {solid: true, sprite: Resources.bitmap()};

