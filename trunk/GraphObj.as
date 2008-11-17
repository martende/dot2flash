package {
	import mx.utils.ObjectUtil;
	public class GraphObj extends Object{
		
		
		private var _i:Object = new Object(); // Inputs
		private var _o:Object = new Object(); // Outputs
		public function GraphObj() {
			
		}
		
		public function set_link(i:String,o:String,link:Object):void {
			if (! _i[i] ) {
				_i[i] = new Object();
			}
			if (! _o[o] ) {
				_o[o] = new Object();
			}
			if (! _i[i][o]) {
				_i[i][o]={link_obj:link};
			} else {
				_i[i][o].link_obj = link;
			}
			if (! _o[o][i]) {
				_o[o][i]={link_obj:link};
			} else {
				_o[o][i].link_obj = link;
			}
		}
		public function dump():void {
			trace("------------DUMP INP------------------");
			//trace(ObjectUtil.toString(_i));
			trace(print_r(_i,""));
			trace("------------DUMP OUTP------------------");
			trace(print_r(_o,""));
		}
		private function print_r( obj:Object, indent:String ):String {
			if (indent == null) indent = "";
			var out:String = "";
			var item:String ;
			for ( item in obj ) {
				if (item == "link_obj") {
					out += indent+"[" + item + "] => Object\n";
					continue;
				}
				if (typeof( obj[item] ) == "object" )
					out += indent+"[" + item + "] => Object\n";
				else
					out += indent+"[" + item + "] => " + obj[item]+"\n";
				out += print_r( obj[item], indent+" " );
			}
			return out;
		}
		public function get_output_links(node:String):Array {
			var ret:Array = new Array();
			if (! _o[node])
				return ret;
			var item:String ;
			for ( item in _o[node] ) {
				if (typeof(_o[node][item]) == "object" &&
					typeof(_o[node][item]["link_obj"]) == "object"
				)
				ret.push(_o[node][item]["link_obj"]);
			}
			return ret;
		}
		public function get_input_links(node:String):Array {
			var ret:Array = new Array();
			if (! _i[node])
				return ret;
			var item:String ;
			for ( item in _i[node] ) {
				if (typeof(_i[node][item]) == "object" &&
					typeof(_i[node][item]["link_obj"]) == "object"
				)
				ret.push(_i[node][item]["link_obj"]);
			}
			return ret;
		}
	}
}
