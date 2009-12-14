package {
    import flash.display.Sprite;

    [SWF(width="480", height="360", frameRate="30")]
    public class Main extends Sprite {
        public function Main() {
            stage.stageFocusRect = false;
            var core:Core = new Core();
            addChild(core);

            var game:Game = new Game(core);
            core.setScene(game);

            Level.init(game);
            game.addActor(new PlayerActor(game, new V2(100, 100)));
        }
    }
}
