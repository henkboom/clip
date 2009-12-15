package {
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.utils.Dictionary;
    
    public class Resources {
        [Embed (source="placeholder.png")]
        private static var defaultSprite:Class;
        private static var cache:Dictionary = new Dictionary();
        private static var reverseCache:Dictionary = new Dictionary();

        public static function bitmap(image:Class = null):BitmapData {
            if(image == null)
                image = defaultSprite;

            if(!cache[image])
                cache[image] = new image().bitmapData;

            return cache[image];
        }

        public static function reverseBitmap(image:Class = null):BitmapData {
            if(image == null)
                image = defaultSprite;

            if(!reverseCache[image]) {
                var orig:BitmapData = bitmap(image);

                var reverse:BitmapData =
                    new BitmapData(orig.width, orig.height, true, 0);
                var matrix:Matrix = new Matrix();
                matrix.scale(-1, 1);
                matrix.translate(orig.width, 0);
                reverse.draw(orig, matrix);

                reverseCache[image] = reverse;
            }

            return reverseCache[image];
        }
    }
}

