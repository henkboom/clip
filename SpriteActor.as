package {
    import flash.display.BitmapData;
    import flash.geom.Point;

    public class SpriteActor extends Actor {
        private static var point:Point = new Point();

        private var sprite:BitmapData;
        private var origin:V2;

        public function get width():Number { return sprite.width; }
        public function get height():Number { return sprite.height; }

        public function SpriteActor(game:Game, pos:V2, sprite:Class = null, origin:V2 = null) {
            super(game, pos)
            this.pos = pos;
            this.sprite = Resources.bitmap(sprite);
            this.origin = origin || new V2(0, 0);
        }
    
        public function update():void {
            pos = V2.add(pos, new V2(Math.random()*2-1, Math.random()*2-1));
        }
    
        public function draw(buffer:BitmapData):void {
            point.x = pos.x - origin.x * width;
            point.y = buffer.height - pos.y - height + origin.y * height;
            buffer.copyPixels(sprite, sprite.rect, point);
        }
    }
}
