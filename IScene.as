package {
    import flash.display.BitmapData;

    public interface IScene {
        function update():void;
        function draw(bitmap:BitmapData):void;
    }
}
