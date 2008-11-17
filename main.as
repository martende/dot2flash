package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	public class main extends UIComponent {
		protected static  var version:String='1.1';

		private var _dotxml:XML=null;
		public var content:Sprite;
		public function main() {
			var url:URLRequest = new URLRequest("test.xml")
			load(url);
		}

		private function load(url:URLRequest):void {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, dotxmlLoadComplete);
			loader.load( url);
		}
		public function onMouseDown(evt:MouseEvent):void {
			content.startDrag();
		}
		public function onMouseUp(evt:MouseEvent):void {
			content.stopDrag();
		}
		private function dotxmlLoadComplete(e:Event):void {
			_dotxml = new XML(e.target.data);
			
			
			
			content = new DotxmlRenderer(_dotxml);
			content.scaleX = 1;
			content.scaleY = 1;

			//this.graphics.lineStyle(1);
			//this.graphics.drawRect(10,10,this.height-10,this.width-10);
			this.addChild(content);
			
			//this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
	}

}