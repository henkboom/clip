package {
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class SpriteActor extends Actor {
        private static var point:Point = new Point();
        private static var rect:Rectangle = new Rectangle();

        private var sprite:BitmapData;
        private var origin:V2;
        private var animSpec:Object;
        private var state:String;
        private var time:Number;
        private var width:int;
        private var height:int;

        public function SpriteActor(game:Game, pos:V2, sprite:Class = null,
                                    origin:V2 = null, width:int = 0,
                                    height:int = 0, animSpec:Object = null) {
            super(game, pos)

            this.pos = pos;
            this.sprite = Resources.bitmap(sprite);

            if(width == 0) width = this.sprite.width;
            this.width = width;
            if(height == 0) height = this.sprite.height;
            this.height = height;

            if(!animSpec) animSpec = {idle: {row: 0, frames: 1, duration: 1}};

            this.origin = origin || new V2(0, 0);
            this.animSpec = animSpec;

            setAnimationState("idle");
        }

        protected function advanceAnimation(delta:Number):void {
            time += delta;
        }

        protected function setAnimationState(state:String):void {
            this.state = state;
            time = 0;
        }
    
        public function draw(buffer:BitmapData):void {
            var row:int = animSpec[state].row;
            var col:int = Math.floor(time/animSpec[state].duration)
                          % (animSpec[state].frames);
            rect.x = col * width;
            rect.y = row * height;
            rect.width = width;
            rect.height = height;
            point.x = pos.x - origin.x * width;
            point.y = buffer.height - pos.y - height + origin.y * height;
            buffer.copyPixels(sprite, rect, point, null, null, true);
        }
    }
}
