package {
	import flash.text.*
	
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
	
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.BitmapFilter;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.GlowFilter;

//	import com.lorentz.SVG.PathCommand;
//	import com.lorentz.SVG.Bezier;
//	import com.lorentz.SVG.SVGColor;
	
	public class DotXConnector extends GraphElem{

		
		public var penX:Number;
		public var penY:Number;
		
		public var arrow:ArrowHead;
		
		private var _from:String;
		private var _to:String;
		private var _label:String;
		
		private var label:TextField;
		//private v
		//private var svg_object:Object;

		private var graph_ref:GraphObj;
		
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

			
		}
		
		public function drawCubicBezier_spline(P1:Object,P2:Object,P3:Object,P4:Object):void {
			// calculates middle point of the two control points segment
			var midP_x:Number = (P1.x + P2.x) / 2;
			var midP_y:Number = (P1.y + P2.y) / 2;			
			// draw fake cubic bezier curve lines (in two parts)
			this.graphics.curveTo(P1.x, P1.y, midP_x, midP_y);
			this.graphics.curveTo(P2.x, P2.y, P3.x, P3.y);
		}
		
		
		public function cubicCurveToAbs(x1:Number, y1:Number, x2:Number, y2:Number, x:Number, y:Number):void  {
			var anchor1:Point = new Point(penX, penY);
			var control1:Point = new Point(x1, y1);
			var control2:Point = new Point(x2, y2);
			var anchor2:Point = new Point(x, y);
			
			var str:String = "bez"+x1+","+y1+","+x2+","+y2+","+x+","+y;
			trace(str + "\n");
			var bezier:Bezier = new Bezier(anchor1, control1, control2, anchor2);
			cubeToBezier(bezier);
			//lastC = control2;
		}
		public function cubeToBezier(bezier:Bezier):void {
			for each (var quadP:Object in bezier.QPts) {
				curveToQuadraticAbs(quadP.c.x, quadP.c.y, quadP.p.x, quadP.p.y);
			}
		}
		public function curveToQuadraticAbs(x1:Number, y1:Number, x:Number, y:Number):void {
			this.graphics.curveTo(x1, y1, x, y);
			penX = x;
			penY = y;
			//lastC = new Point(x1, y1);
		}
		public function drawbspline(A:Array):void {
			var i:Number;
			penX = A[1].x;
			penY = A[1].y;
			graphics.moveTo(penX,penY);
			for (i = 2; i + 2< A.length; i += 3) {
				cubicCurveToAbs(A[i].x,A[i].y,A[i+1].x,A[i+1].y,A[i+2].x,A[i+2].y);
			}
			graphics.lineTo(A[0].x,A[0].y);
			
			this.arrow = new ArrowHead();
			
			this.addChild(arrow);
			this.arrow.x = A[0].x;
			this.arrow.y = A[0].y;
			
			this.arrow.rotation = Math.atan2( penY - A[0].y, penX - A[0].x ) * ( 180 / Math.PI );
			
			
			//this.arrow = mc.attachMovie( "arrowHead", "arrowHead", 0 );
			
		}
		

		
		public function ResetHighlight():void {
			this.label.visible = false;
			this.filters = new Array();
		}
		public function HighlightIn():void {
           var color:Number = 0x0000FF;
            var alpha:Number = 1;
            var blurX:Number = 2;
            var blurY:Number = 2;
            var strength:Number = 10;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.HIGH;
			this.label.visible = true;
            filters= [new GlowFilter(color,
                                  alpha,
                                  blurX,
                                  blurY,
                                  strength,
                                  quality,
                                  inner,
                                  knockout)];	
		}
		public function HighlightOut():void {
            var color:Number = 0x00FF00;
            var alpha:Number = 1;
            var blurX:Number = 2;
            var blurY:Number = 2;
            var strength:Number = 10;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.HIGH;
			this.label.visible = true;
            filters= [new GlowFilter(color,
                                  alpha,
                                  blurX,
                                  blurY,
                                  strength,
                                  quality,
                                  inner,
                                  knockout)];			
		}

		private var _fontsize:Number  = 2;
		public function DotXConnector(elt:XML,graph_ref:GraphObj){
			var pos:String ;
			var res:Array;
			var i:Number;
			var xy:Array;
			this.graph_ref = graph_ref;
			
			_from = get_els(elt,"from");
			_to = get_els(elt,"to");
			var poslp:String = get_els(elt,"lp");
			_label = get_els(elt,"label");
			
			graph_ref.set_link(_to,_from,this);
			
			pos = get_els(elt,"pos");
			res = pos.split(/ /);
			this.graphics.lineStyle(0.1);
			var A:Array = new Array ();
			
			for (i = 0; i <res.length; i++) {
				
				xy = res[i].split(/,/);
				if (xy[0] == 'e') {
					A.push({x:xy[1],y:xy[2]});
				} else {
					A.push({x:xy[0],y:xy[1]});
				}
			}
			
			drawbspline(A);
			
			if (poslp && _label ) {
				
				xy = poslp.split(/,/);
				var format:TextFormat = new TextFormat(); 
				format.color = 0x000000; 
				format.size = _fontsize * GraphElem.dfC; 
				format.font = "myFont";
				
				this.label = new TextField();
				this.label.autoSize = TextFieldAutoSize.LEFT;
				this.label.border = true;
				this.label.background = true;
				this.label.backgroundColor = 0xFFFFC9;
				this.label.visible = false;
				this.label.defaultTextFormat = format;
				this.label.text = _label;
				
				this.addChild(this.label);
				
				this.label.x = xy[0] - this.label.width / 2;
				this.label.y = xy[1] - this.label.width / 2;
			}
			/*
			
			
	
			this.tooltip = new TextField();
			this.tooltip.autoSize = TextFieldAutoSize.LEFT;
			this.tooltip.border = true;
			this.tooltip.background = true;
			this.tooltip.backgroundColor = 0xFFFFC9;
			this.tooltip.visible = false;
			this.tooltip.defaultTextFormat = format; 
			this.tooltip.text = 
				"OutTraffic: " + __out_traffic + "\n" +
				"InTraffic: " + 0 + "\n";
			*/
			// Draw label
		}
	}
}
