package {
    import flash.display.Sprite;

    [SWF(width="480", height="360", frameRate="60")]
    public class Main extends Sprite {
        public function Main() {
            stage.stageFocusRect = false;
            var core:Core = new Core();
            addChild(core);

            var game:Game = new Game(core);
            core.setScene(game);

            Level.init(game, 1);
        }
    }
}
