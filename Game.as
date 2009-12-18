package {
    import flash.display.BitmapData;
    import flash.utils.Dictionary;

    public class Game implements IScene {
        private var _core:Core;
        public function get core():Core { return _core; }

        private var _util:Object = {};
        public function get util():Object { return _util; }
    
        private var updateMethods:Array = ['preupdate', 'update', 'postupdate'];
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
                for each (a in actors){
                    if(!deadSet[a])
                        a[m]();
                }
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
}
