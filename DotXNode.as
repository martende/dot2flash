
package {
	import flash.text.*
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
	import flash.utils.*;

	import flash.geom.Point;

    import flash.filters.BitmapFilter;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.DropShadowFilter;

	
	import flash.events.Event;
	import flash.events.MouseEvent;
//	import com.lorentz.SVG.PathCommand;
//	import com.lorentz.SVG.Bezier;
//	import com.lorentz.SVG.SVGColor;
	
	public class DotXNode extends GraphElem{
		

		
		// Construction Objs
		
		private var label:TextField;
		
		//private var svg_object:Object;
		
		private var graph_ref:GraphObj;
		
		private var tooltip:TextField;
		
		
		private var _id:String;
		private var _label:String;
		private var _shape:String;
		private var _style:String;
		private var _color:uint;
		private var _fontcolor:uint;
		private var _fontsize:Number;
		private var _pos_x:Number;
		private var _pos_y:Number;
		private var _h:Number;
		private var _w:Number;
		
		
		
		public function get_eln(elt:XML,key:String):Number {
			if (elt.child(key).length()) {
				trace("get_els(" + key + ") return " + elt.child(key)[0]);
				return elt.child(key)[0];
			}
			if (elt.attribute(key)) {
				trace("get_els(" + key + ") return " + elt.attribute(key));
				return elt.attribute(key);
			}
			trace("get_els(" + key + ") is NULL");
			return 0;
		}
		public function get_els(elt:XML,key:String):String {
			if (elt.child(key).length()) {
				trace("get_els(" + key + ") return " + elt.child(key)[0]);
				return elt.child(key)[0];
			}
			if (elt.attribute(key)) {
				trace("get_els(" + key + ") return " + elt.attribute(key));
				return elt.attribute(key);
			}
			trace("get_els(" + key + ") is NULL");
			return "";
		}
		public function check_params():void {
			if (! _fontsize) {
				_fontsize = 0.5;
			}
			if (! _label) {
				_label = _id;
			}
			if (! _fontcolor) {
				_fontcolor = 0x000000;
			}
			
			_label=_label.replace(/\\n/g,"\n");
			if (! _shape ) {
				_shape = "circle";
			}
		}
		private var __out_traffic:Number = 0;
		private var __shown_traffic_procent:Number = 0;
		
		public function DotXNode(elt:XML,graph_ref:GraphObj){
			var pos:String ;
			var res:Array;
			this.graph_ref = graph_ref;
			trace(elt.toXMLString());
			_id = elt.@id;
			_label = get_els(elt,"label");
			_shape = get_els(elt,"shape");
			_style = get_els(elt,"style");
			_color = convertColor(get_els(elt,"color"));
			_fontcolor = convertColor(get_els(elt,"fontcolor"));
			_fontsize= get_eln(elt,"fontsize") as Number;
			
			_h= (get_eln(elt,"height") as Number )* dhC;
			_w= (get_eln(elt,"width") as Number)* dwC;
			
			__out_traffic = (get_eln(elt,"__out_traffic") as Number);
			__shown_traffic_procent = (get_eln(elt,"__shown_traffic_procent") as Number);
			
			pos = get_els(elt,"pos");
			res = pos.split(/,/);
			
//			trace(_h,elt.elt.child("height")[0]);
			_pos_x = res[0];
			_pos_y = res[1];
			//elt.@pos.split(/,/,2)[0];
			//_pos_y= elt.@pos.split(/,/,2)[1];
		
			check_params();
			switch(_style) {
				case "filled":
					this.graphics.beginFill(_color);
				default:
				break;
			}
			this.graphics.lineStyle(1);
			switch (_shape) {
				case "box":
					this.graphics.drawRect(0,0,_w,_h);
					if (__shown_traffic_procent > 2.5) {
						this.graphics.lineStyle(0.1);
						this.graphics.beginFill(0xff0000);
						this.graphics.drawRect(0,0,_w * __shown_traffic_procent / 100 ,_h * 0.2);
						this.graphics.beginFill(0xffffff);
						this.graphics.drawRect(_w * __shown_traffic_procent / 100 ,0,_w - _w * __shown_traffic_procent / 100 ,_h * 0.2);
					} else {
						this.graphics.lineStyle(0.1);
						this.graphics.beginFill(0xffbb00);
						this.graphics.drawRect(0,0,_w * __shown_traffic_procent * 40 / 100 ,_h * 0.2);
						this.graphics.beginFill(0xffffff);
						this.graphics.drawRect(_w * __shown_traffic_procent * 40 / 100 ,0,_w - _w * __shown_traffic_procent * 40 / 100 ,_h * 0.2);						
					}
					break;
				case "circle":
					this.graphics.drawEllipse(0,0,_w,_h);
					break;
				default:
					break;
			}
			
			
			var format:TextFormat = new TextFormat(); 
			format.color = 0x000000; 
			format.size = _fontsize * GraphElem.dfC; 
			format.font = "myFont"; 
	
			this.tooltip = new TextField();
			this.tooltip.autoSize = TextFieldAutoSize.LEFT;
			this.tooltip.border = true;
			this.tooltip.background = true;
			this.tooltip.backgroundColor = 0xFFFFC9;
			this.tooltip.visible = false;
			this.tooltip.defaultTextFormat = format; 
			this.tooltip.text = 
				"Traffic: " + __out_traffic + "\n" +
				"Procent: " + __shown_traffic_procent + "\n";
			
			
			
			var myText:TextField = new TextField(); 
			//myText.embedFonts = true; 
			myText.autoSize = TextFieldAutoSize.LEFT; 
			myText.antiAliasType = AntiAliasType.ADVANCED; 
			myText.defaultTextFormat = format; 
			myText.selectable = false; 
			myText.mouseEnabled = true; 
			myText.text = _label ; 
			
			myText.x = _w / 2 - myText.width / 2;
			myText.y = _h / 2 - myText.height / 2;
			
			this.label = myText;
			
			trace ("------------");
			trace (myText.width );
			trace ("------------");
			
			this.addChild(myText);
			
			this.x = _pos_x - _w / 2;
			this.y = _pos_y - _h / 2 ;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOut);
			
			this.addChild(this.tooltip);
		}
		
		public function mouseOut(event:Event):void {
			var myFilters:Array = new Array();
            this.filters = myFilters;
			var i:Number;
			if (timer) {
			   clearInterval(timer);
			   timer = 0;
			}
			this.tooltip.visible = false;
			var outnodes:Array = graph_ref.get_output_links(_id);
			for (i=0;i<outnodes.length;i++) {
				outnodes[i].ResetHighlight();
			}
			var innodes:Array = graph_ref.get_input_links(_id);
			for (i=0;i<innodes.length;i++) {
				innodes[i].ResetHighlight();
			}
			
		}
		private var timer:uint;
		private var localX : Number;
		private var localY : Number;

		public function mouseOver(event:MouseEvent):void {
			
			var filter:BitmapFilter = getBitmapFilter();
			var myFilters:Array = new Array();
			var i:Number;
            myFilters.push(filter);
            this.filters = myFilters;
			var outnodes:Array = graph_ref.get_output_links(_id);
			for (i=0;i<outnodes.length;i++) {
				outnodes[i].HighlightOut();
			}
			var innodes:Array = graph_ref.get_input_links(_id);
			for (i=0;i<innodes.length;i++) {
				innodes[i].HighlightIn();
			}
			
			timer = setInterval(showTip, 500);
			this.localY =  event.localY;
			this.localX =  event.localX;
		}
		public function showTip():void {
               clearInterval(timer);
			   timer = 0;
			   this.tooltip.x = localX;
			   this.tooltip.y = localY;
			   this.tooltip.visible = true;
		}

		private function getBitmapFilter():BitmapFilter {
            var color:Number = 0x000000;
            var angle:Number = 45;
            var alpha:Number = 0.8;
            var blurX:Number = 8;
            var blurY:Number = 8;
            var distance:Number = 15;
            var strength:Number = 0.65;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.HIGH;
            return new DropShadowFilter(distance,
                                        angle,
                                        color,
                                        alpha,
                                        blurX,
                                        blurY,
                                        strength,
                                        quality,
                                        inner,
                                        knockout);
        }

	}
}
