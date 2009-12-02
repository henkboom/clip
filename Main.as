package {
    import flash.display.Sprite;
    public class Main extends Sprite {
        public function Main() {
            addChild(new Core(new Scene));
        }
    }
}

import flash.display.BitmapData;
import flash.geom.Rectangle;

class Scene implements IScene {
    private var x:int = 0;

    public function update():void {
        x = x + 1;
    }

    public function draw(buffer:BitmapData):void {
        buffer.fillRect(
            new Rectangle(x, x, buffer.width, buffer.height),
            0xffffffff);
    }
}
