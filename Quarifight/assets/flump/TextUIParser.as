package  {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.net.FileReference;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	
	public class TextUIParser extends MovieClip {
		
		protected var data:Object = { };
		
		protected var file: FileReference;
		
		public function TextUIParser() {
			stop();
			
			// ne lance le code que si on execute le swf depuis Flash IDE
			if (Capabilities.playerType=="External") {
				file = new FileReference();
				parse(this);
				saveFile();
			}
		}
		
		protected function parse (pTarget:Sprite):void {
			var lItem:DisplayObject;
			var lTxt:TextField;
			var lFormat:TextFormat;
			
			for (var i:int = 0; i < pTarget.numChildren; i++) {
				lItem = pTarget.getChildAt(i);
				if (lItem is Sprite) parse (Sprite(lItem));
				else if (lItem is TextField) {
					lTxt = TextField(lItem);
					lFormat = lTxt.getTextFormat();
					
					if (data[getQualifiedClassName(lTxt.parent)]!=null) continue;
					
					data[getQualifiedClassName(lTxt.parent)] = {
						text: lTxt.text,
						x: lTxt.x,
						y: lTxt.y,
						width: lTxt.width,
						height: lTxt.height,
						font:lFormat.font,
						align:lFormat.align,
						color:lFormat.color,
						size:lFormat.size,
						bold:lFormat.bold,
						italic:lFormat.italic
					}
				}
			}
		}
		
		protected function saveFile (): void {
			var lData:ByteArray = new ByteArray();
			lData.writeMultiByte(JSON.stringify(data,null,"\t"), "utf-8" );
			file.save(lData, "textsUI.json" );
		}
	}
	
}
