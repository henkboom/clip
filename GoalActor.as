package {
    public class GoalActor extends SpriteActor {
        [Embed (source="goal.png")]
        private static var goalSprite:Class;

        public function GoalActor(game:Game, pos:V2) {
            super(game, pos, goalSprite, new V2(0, 0));
        }
    }
}
