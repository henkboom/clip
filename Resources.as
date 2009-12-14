package {
    import flash.display.BitmapData;
    import flash.utils.Dictionary;
    
    public class Resources {
        [Embed (source="placeholder.png")]
        private static var defaultSprite:Class;
        private static var cache:Dictionary = new Dictionary();

        public static function bitmap(image:Class = null):BitmapData {
            if(image == null)
                image = defaultSprite;

            if(!cache[image])
                cache[image] = new image().bitmapData;

            return cache[image];
        }
    }
}

