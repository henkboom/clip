package {
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    public class Core extends Sprite {
        private var frontBitmap:Bitmap;
        private var backBitmap:Bitmap;
        private var scene:IScene;

        public function Core() {
            frontBitmap = new Bitmap(new BitmapData(320, 240));
            frontBitmap.scaleX = 1.5;
            frontBitmap.scaleY = 1.5;
            frontBitmap.smoothing = true;

            backBitmap = new Bitmap(new BitmapData(320, 240));
            backBitmap.scaleX = 1.5;
            backBitmap.scaleY = 1.5;
            backBitmap.smoothing = true;

            addEventListener(MouseEvent.CLICK, onClick);
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            addChild(frontBitmap);
            addChild(backBitmap);
        }

        public function setScene(scene:IScene):void
        {
            this.scene = scene;
        }

        private function onClick(event:MouseEvent):void {
            stage.focus = this;
        }

        private function onEnterFrame(event:Event):void {
            // UPDATE
            // basically if setScene() is called during the update we want to
            // update again
            var updatedScene:IScene = null;
            while(scene && updatedScene != scene) {
                updatedScene = scene;
                if(scene) scene.update();
            }

            // DRAW
            var buffer:BitmapData = backBitmap.bitmapData;
            buffer.fillRect(
                new Rectangle(0, 0, buffer.width, buffer.height),
                0xffffffff);
            if(scene) scene.draw(buffer);

            // FLIP
            var temp:Bitmap = frontBitmap;
            frontBitmap = backBitmap;
            backBitmap = temp;

            frontBitmap.visible = true;
            backBitmap.visible = false;
        }
    }
}
