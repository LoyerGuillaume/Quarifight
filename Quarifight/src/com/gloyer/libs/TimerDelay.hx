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
	
	
	private function getNameEvent(pNameEvent:String):String {
		return TIMER_DELAY_EVENT + " " + pNameEvent;
	}
	
	
	/**
	 * Créer et lance un delay qui emitera la string retourné par la fonction et lancera la callback optionnel.
	 * @param	pNameEvent: nom de l'event 
	 * @param	pDurationMs: durée en millisecond du delay
	 * @param	pCallback: (optionnel) sera lancé une fois le délais terminé
	 * @return  le string de l'event qui sera emit
	 */
	public function startDelay(pNameEvent:String, pDurationMs:Int, ?pCallback:Void->Void = null):String {
		var lNameEvent:String = getNameEvent(pNameEvent);
		
		addTimerDelay(lNameEvent, pDurationMs, function () {
			if (pCallback != null) {
				pCallback();
			}
			
			stopDelay(lNameEvent);
		});
		
		return lNameEvent;
	}
	
	
	/**
	 * Créer un lance un delay qui se répètera jusqu'au stop de celui-ci. Emit la string retourner et lance la callback optionnel à chaque itération.
	 * @param	pNameEvent: Nom de l'event
	 * @param	pDurationRepeaterMs: Durée en millisecond entre chaque itération
	 * @param	pCallback: (optionnel) sera lancé à chaque itération
	 * @return  le string de l'event qui sera emit
	 */
	public function startRepeaterDelay(pNameEvent:String, pDurationRepeaterMs:Int, ?pCallback:Void->Void = null):String {
		var lNameEvent:String = getNameEvent(pNameEvent);
		
		addTimerDelay(lNameEvent, pDurationRepeaterMs, function () {
			if (pCallback != null) {
				pCallback();
			}
			
			stopDelay(lNameEvent);
			
			startRepeaterDelay(pNameEvent, pDurationRepeaterMs, pCallback);
		});
		
		return lNameEvent;
	}
	
	
	/**
	 * Met en pause tout les timerdelay en cours
	 */
	public function pauseAllDelay():Void {
		var lNameDelay:String;
		for (lNameDelay in listTimerDelay.keys()) {
			pauseDelay(lNameDelay);
		}
	}
	
	
	/**
	 * Met en pause le timerDelay ayant comme string d'event pNameEvent
	 * @param	pNameEvent
	 */
	public function pauseDelay(pNameEvent:String):Void {
		var lTimerDelay:TimerDelayDef = listTimerDelay.get(pNameEvent);
		if (!lTimerDelay.inPause) {
			var pNewDurationDelay:Int = Math.round(lTimerDelay.durationMs - (getStampInMillisecond() - lTimerDelay.startTimestampMs));
			trace((getStampInMillisecond() - lTimerDelay.startTimestampMs));
			lTimerDelay.durationMs = pNewDurationDelay;
			lTimerDelay.timer.stop();
			lTimerDelay.timer = null;
			lTimerDelay.inPause = true;			
			trace(lTimerDelay);
		}
	}
	
	
	/**
	 * Reprend tout les delay là où ils en étaient
	 */
	public function resumeAllDelay():Void {
		var lNameDelay:String;
		for (lNameDelay in listTimerDelay.keys()) {
			resumeDelay(lNameDelay);
		}
	}
	
	
	/**
	 * Reprend le delay ayant comme nom d'emit pNameDelay
	 * @param	pNameDelay
	 */
	public function resumeDelay(pNameDelay:String):Void {
		var lTimerDelay:TimerDelayDef = listTimerDelay.get(pNameDelay);
		if (lTimerDelay.inPause) {
			lTimerDelay.timer = createTimerDelay(pNameDelay, lTimerDelay.durationMs, lTimerDelay.callback);
			lTimerDelay.inPause = false;
		}
	}
	
	
	/**
	 * Stop et supprime tout les delay
	 */
	public function stopAllDelay():Void {
		var lNameDelay:String;
		for (lNameDelay in listTimerDelay.keys()) {
			stopDelay(lNameDelay);
		}
	}
	
	
	/**
	 * Stop et supprime le delay ayant comme nom d'emit pNameEvent
	 * @param	pNameEvent
	 */
	public function stopDelay(pNameEvent:String):Void {
		var lTimerDelay:TimerDelayDef = listTimerDelay.get(pNameEvent);
		lTimerDelay.timer.stop();
		listTimerDelay.remove(pNameEvent);
	}
	
	
	private function getStampInMillisecond():Int {
		return Math.round(Timer.stamp() * 1000);
	}
	
	
	private function addTimerDelay(pNameEvent:String, pDurationMs:Int, pCallback:Void->Void):Void {
		listTimerDelay.set(pNameEvent, {
			callback:			pCallback,
			timer: 				createTimerDelay(pNameEvent, pDurationMs, pCallback),
			startTimestampMs: 	getStampInMillisecond(),
			durationMs: 		pDurationMs,
			inPause: 			false
		});
	}
	
	
	private function createTimerDelay(pNameEvent:String, pDurationMs:Int, pCallback:Void->Void):Timer {
		var lDelay:Timer = Timer.delay(function () {
			emit(pNameEvent);
			pCallback();
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