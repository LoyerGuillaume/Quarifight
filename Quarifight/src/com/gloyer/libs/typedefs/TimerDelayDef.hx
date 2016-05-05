package com.gloyer.libs.typedefs;

import haxe.Timer;

/**
 * @author Loyer Guillaume
 */

typedef TimerDelayDef =
{
	var timer:Timer;
	var startTimestampMs:Int;
	var durationMs:Int;
	@:optional var callback:Void->Void;
}