package {
    import flash.display.BitmapData;
    import flash.events.Event;

    public interface IScene {
        function update():void;
        function draw(bitmap:BitmapData):void;
    }
}
