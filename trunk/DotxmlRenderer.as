package {
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
	import flash.geom.Point;
//	import com.lorentz.SVG.PathCommand;
//	import com.lorentz.SVG.Bezier;
//	import com.lorentz.SVG.SVGColor;
	
	public class DotxmlRenderer extends Sprite{
		//private var svg_object:Object;
		private var graph_ref:GraphObj = new GraphObj();
		public function DotxmlRenderer(svg:XML):void{
			this.addChild(visit(svg));
		}
		public function visit(elt:XML):Sprite {
			var obj: Sprite = new Sprite();
			var graphname:String = elt.@name;
			var i:Number; 
			for (i = 0; i <elt.children().length(); i++) {
				var el:XML = elt.children()[i];
				var elname:String = el.name();
				trace(elname);
				switch(elname) {
					case "node":
						trace("obj.addChild(DotXNode(elt));")
						//trace(el.toXMLString());
						obj.addChild(new DotXNode(el,graph_ref));
						break;
					case "connector":
						trace("obj.addChild(DotXConnector(elt));")
						//trace(el.toXMLString());
						obj.addChild(new DotXConnector(el,graph_ref)); 
				}
			    //trace(el.nodeKind()); // attribute
				     // id and color

				//trace(elt.children()[i].toXMLString());
				
				//trace ("     Name des Videos :" + myXML.videos.item[i].title.text()) + "\n";   
			}
			return obj;
		}
	}
}
