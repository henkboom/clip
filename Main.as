package {
    import flash.display.Sprite;

    [SWF(width="640", height="480", frameRate="30")]
    public class Main extends Sprite {
        public function Main() {
            stage.stageFocusRect = false;
            var core:Core = new Core();
            addChild(core);

            var game:Game = new Game(core);
            core.setScene(game);

            game.addActor(new PlayerActor(game, new V2(100, 100)));
        }
    }
}

import flash.display.BitmapData;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

const square:BitmapData = new BitmapData(16, 16, true, 0xff7f00ff);

//// V2 ///////////////////////////////////////////////////////////////////////
class V2 {
    private var _x:Number; public function get x():Number { return _x; }
    private var _y:Number; public function get y():Number { return _y; }

    public function V2(x:Number, y:Number) {
        _x = x;
        _y = y;
    }

    public static function add(a:V2, b:V2):V2 {
        return new V2(a.x + b.x, a.y + b.y);
    }

    // TODO...
}

//// Game /////////////////////////////////////////////////////////////////////
class Game implements IScene {
    private var _core:Core;
    public function get core():Core { return _core; }

    private var updateMethods:Array = ['preupdate', 'update'];
    private var drawMethods:Array = ['draw'];

    private var actorsByMethod:Object = {};

    private var deadSet:Dictionary = new Dictionary();

    public function Game(core:Core):void {
        _core = core;
        var m:String;
        for each (m in updateMethods) actorsByMethod[m] = []
        for each (m in drawMethods) actorsByMethod[m] = []
    }

    public function update():void {
        var m:String;
        var a:Object;
        var actors:Array;

        for each (m in updateMethods) {
            actors = actorsByMethod[m];
            for each (a in actors)
                if(!deadSet[a])
                    a[m]();
        }

        // wipe dead actors
        for (m in actorsByMethod) {
            actors = actorsByMethod[m];
            var from:int = 0;
            var to:int = 0;
            while(from < actors.length)
            {
                if(deadSet[actors[from]]) {
                    from++;
                } else {
                    actors[to++] = actors[from++];
                }
            }
            actors.length = to;
        }
        for(a in deadSet)
            delete deadSet[a];
    }

    public function draw(buffer:BitmapData):void {
        for each (var m:String in drawMethods) {
            var actors:Array = actorsByMethod[m];
            for each (var a:Object in actors)
                a[m](buffer)
        }

    }

    public function addActor(actor:Object):void {
        var m:String;
        for each (m in updateMethods)
            if(actor.hasOwnProperty(m)) actorsByMethod[m].push(actor);
        for each (m in drawMethods)
            if(actor.hasOwnProperty(m)) actorsByMethod[m].push(actor);
    }
}

//// PlayerInputActor /////////////////////////////////////////////////////////
class PlayerInputActor {
    private var _x:Number = 0;
    public function get x():Number { return _x; }

    private var left:Boolean = false;
    private var right:Boolean = false;

    public function PlayerInputActor(game:Game) {
        game.core.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
        game.core.addEventListener(KeyboardEvent.KEY_UP, onKey);
    }

    private function onKey(event:KeyboardEvent):void {
        var down:Boolean = event.type == KeyboardEvent.KEY_DOWN;
        if(event.keyCode == 37) left = down
        else if(event.keyCode == 39) right = down

        _x = (right ? 1 : 0) - (left ? 1 : 0);
    }
}

//// SpriteActor //////////////////////////////////////////////////////////////
class SpriteActor {
    public var pos:V2;
    private static var point:Point = new Point();

    public function SpriteActor(game:Game, pos:V2) {
        this.pos = pos;
    }

    public function update():void {
        pos = V2.add(pos, new V2(Math.random()*2-1, Math.random()*2-1));
    }

    public function draw(buffer:BitmapData):void {
        point.x = pos.x;
        point.y = pos.y;
        buffer.copyPixels(square, square.rect, point);
    }
}

//// PlayerActor //////////////////////////////////////////////////////////////
class PlayerActor extends SpriteActor {
    public var controller:PlayerInputActor;

    public function PlayerActor(game:Game, pos:V2)
    {
        super(game, pos);
        controller = new PlayerInputActor(game);
        game.addActor(controller);
    }

    override public function update():void {
        pos = V2.add(pos, new V2(controller.x*2, 0));
    }
}
