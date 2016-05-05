package com.gloyer.libs.typedefs;

/**
 * ...
 * @author Loyer Guillaume
 */
typedef RepeaterDef =
{
	var time:Float;
	var duration:Float;
	@:optional var dateEnd:Float;
	@:optional var callbackEnd:String->Void;
	@:optional var start:Float;
}