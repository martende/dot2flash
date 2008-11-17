package {
	import flash.display.Sprite;
	public class GraphElem extends Sprite{
		// Node height,width to pixels convert coeficients
		public static const dhC:Number = 72;
		public static const dwC:Number  = 72;
		// Node Font convert coeficients
		public static const dfC:Number  = 0.9;
		
		public function convertColor(c:String):uint {
			var rc:uint;
			
			switch(c) {
				case "turquoise": return 0x40e0d0;
				case "red": return 0xff0000;
			}

			if ( c == null || c.length != 6 ) {
		                   rc = 0x000000;
		    } else {
				var validHex:String = "0123456789ABCDEFabcdef";
		        var numValid:int = 0;
				var t:Number = 0;
		        for (var i:int=0; i < c.length; ++i) {
					if (validHex.indexOf(c.charAt(i)) >= 0) {
						++numValid;
						t *= 16;
						t+= ("0x" + c.charAt(i) ) as Number;
					}
				}
		        if (numValid != 6) {
					rc = 0x000000;
				} else {
					rc = t;
				}
		    }
			return rc;
		}
	}
}
