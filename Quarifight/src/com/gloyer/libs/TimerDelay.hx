package com.gloyer.libs;

import com.gloyer.libs.typedefs.TimerDelayDef;
import eventemitter3.EventEmitter;
import haxe.Timer;

	
/**
 * ...
 * @author Loyer Guillaume
 */
class TimerDelay extends EventEmitter 
{
	
	/**
	 * instance unique de la classe TimerDelay
	 */
	private static var instance: TimerDelay;
	
	
	public static inline var TIMER_DELAY_EVENT:String = "TIMER DELAY EVENT";
	
	private var listTimerDelay:Map<String, TimerDelayDef>;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): TimerDelay {
		if (instance == null) instance = new TimerDelay();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		listTimerDelay = new Map<String, TimerDelayDef>();
		
	}
	
	public function startDelay(pNameEvent:String, pDurationMs:Int, ?pCallback:Void->Void = null):String {
		var lNameEvent:String = TIMER_DELAY_EVENT + " " + pNameEvent;
		
		listTimerDelay.set(lNameEvent, {
			timer: createTimerDelay(lNameEvent, pDurationMs, pCallback),
			startTimestampMs: getStampInMillisecond(),
			durationMs: pDurationMs
		});
		
		if (pCallback != null) {
			listTimerDelay.get(lNameEvent).callback = pCallback;
		}
		
		return lNameEvent;
	}
	
	
	public function pauseAllDelay():Void {
		var lNameDelay:String;
		var lDelay:TimerDelayDef;
		for (lNameDelay in listTimerDelay.keys()) {
			lDelay = listTimerDelay.get(lNameDelay);
			lDelay.timer.stop();
			lDelay.timer = null;
		}
	}
	
	
	public function resumeAllDelay():Void {
		var lNameDelay:String;
		var lDelay:TimerDelayDef;
		for (lNameDelay in listTimerDelay.keys()) {
			lDelay = listTimerDelay.get(lNameDelay);
			var pNewDurationDelay:Int = Math.round(lDelay.durationMs - (getStampInMillisecond() - lDelay.startTimestampMs));
			lDelay.timer = createTimerDelay(lNameDelay, pNewDurationDelay, lDelay.callback);
		}
	}
	
	
	private function getStampInMillisecond():Int {
		return Std.int(Timer.stamp() * 1000);
	}
	
	
	private function createTimerDelay(pNameEvent:String, pDurationMs:Int, pCallback:Void->Void):Timer {
		
		var lDelay:Timer = Timer.delay(function () {
			if (listTimerDelay.get(pNameEvent).callback != null) {
				listTimerDelay.get(pNameEvent).callback();
			}
			emit(pNameEvent);
			listTimerDelay.remove(pNameEvent);
		}, pDurationMs);
		
		return lDelay;
	}
	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}