package {
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.geom.Rectangle;

    [SWF(width="640", height="480")]
    public class Core extends Sprite {
        private var frontBitmap:Bitmap;
        private var backBitmap:Bitmap;
        private var scene:IScene;

        public function Core(scene:IScene) {
            frontBitmap = new Bitmap(new BitmapData(640, 480));
            backBitmap = new Bitmap(new BitmapData(640, 480));
            this.scene = scene;

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            addChild(frontBitmap);
            addChild(backBitmap);
        }

        private function onEnterFrame(event:Event):void {
            // UPDATE
            scene.update();

            // DRAW
            var buffer:BitmapData = backBitmap.bitmapData;
            buffer.fillRect(
                new Rectangle(0, 0, buffer.width, buffer.height),
                0xff000000);

            scene.draw(buffer);

            // FLIP
            var temp:Bitmap = frontBitmap;
            frontBitmap = backBitmap;
            backBitmap = temp;

            frontBitmap.visible = true;
            backBitmap.visible = false;
        }
    }
}
