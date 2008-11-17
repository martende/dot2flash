package {

	import flash.display.Sprite;

	public class ArrowHead extends Sprite{
		public function ArrowHead(){
			this.graphics.lineStyle(1, 0x000000, 100);
			this.graphics.beginFill(0x000000);
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(7, 1);
			this.graphics.lineTo(7, -1);
			this.graphics.lineTo(0, 0);
		}
	}
}
