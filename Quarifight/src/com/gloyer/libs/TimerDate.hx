package com.gloyer.libs;
import com.isartdigital.game.typedefs.DataTimer.TimerDef;
import com.isartdigital.game.typedefs.RepeaterDef;
import eventemitter3.EventEmitter;
import haxe.Timer;
import js.Browser;

	
/**
 * Timer, repeater
 * @author Loyer Guillaume
 */
class TimerDate extends EventEmitter
{
	
	/**
	 * instance unique de la classe TimeManager
	 */
	private static var instance: TimerDate;
	
	//private var currentDate:Date;
	
	private var timerMap:Map<String, TimerDef>;
	private var repeaterMap:Map<String, RepeaterDef>;
	
	public static inline var TIME_MANAGER_EVENT:String = "TIME MANAGER EVENT";
	public static inline var REPEAT_MANAGER_EVENT:String = "REPEAT MANAGER EVENT";
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): TimerDate {
		if (instance == null) instance = new TimerDate();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		timerMap = new Map<String, TimerDef>();
		repeaterMap = new Map<String, RepeaterDef>();
		//currentDate = getActualyTime();
	}
	
	/**
	 * Renvoie la date de maintenant
	 * @return
	 */
	public function getActualTime():Float {
		return Date.now().getTime();
	}
	
	
	/**
	 * Débute un timer ayant pour nom pName, qui commence maintenant, d'une durée pDuration. Renvoie le nom de l'évènement appeler une fois le timer dépassé
	 * @param	pName
	 * @param	pDuration millisecond
	 * @return
	 */
	public function startTimer(pName:String, pDuration:Float):String {
		return addTimer(pName, getActualTime(), pDuration);
	}
	
	/**
	 * Débute un timer ayant pour nom pName, qui commence maintenant, jusqu'à pEnd. Renvoie le nom de l'évènement appeler une fois le timer dépassé
	 * @param	pName
	 * @param	pEnd
	 * @return
	 */
	public function startTimerUntilTimeEnd(pName:String, pEnd:Float):String {
		return addTimerBetweenTimeStamp(pName, getActualTime(), pEnd);
	}
	
	/**
	 *  Débute un timer qui se répète jusqu'à l'arrêt de celui-ci
	 * @param	pName
	 * @param	pDuration
	 * @param	pDurationEnd optionel, le repeateur s'arettera à la fin de la durée
	 * @param	pCallbackEnd optionel, à la fin du répéteur la call back sera apelée
	 * @return
	 */
	public function startRepeater(pName:String, pDuration:Float, ?pRepeaterEnd:Float = null, ?pCallbackEnd:String->Void = null):String {
		var pRepeaterTimeStamp:Float = getActualTime() + pDuration;
		repeaterMap[pName] = { time : pRepeaterTimeStamp, duration : pDuration, dateEnd: pRepeaterEnd, callbackEnd: pCallbackEnd, start:getActualTime() };
		return REPEAT_MANAGER_EVENT + pName;
	}
	
	
	/**
	 * Débute un timer ayant pour nom pName, ayant comme départ pStart, d'une durée pDuration. Renvoie le nom de l'évènement appeler une fois le timer dépassé
	 * @param	pName
	 * @param	pStart
	 * @param	pDuration
	 * @return
	 */
	public function addTimer(pName:String, pStart:Float, pDuration:Float):String {
		var pEndTimeStamp:Float = pStart + pDuration;
		timerMap[pName] = {endTimeStamp : pEndTimeStamp, start : pStart, duration : pDuration};
		
		return TIME_MANAGER_EVENT + pName;
	}
	
	/**
	 * Débute un timer ayant comme nom pName, avec pStart comme départ et pEnd comme fin. Renvoie le nom de l'évènement appeler une fois le timer dépassé
	 * @param	pName
	 * @param	pStart
	 * @param	pEnd
	 * @return
	 */
	public function addTimerBetweenTimeStamp(pName:String, pStart:Float, pEnd:Float):String {
		var pDuration:Float = pEnd - pStart;
		timerMap[pName] = {endTimeStamp : pEnd, start : pStart, duration : pDuration};
		
		return TIME_MANAGER_EVENT + pName;
	}
	
	/**
	 * Retourne le ratio de 0 à 1, de l'avancement de l'event.
	 * @param	pName nom de l'event
	 * @return
	 */
	public function getRatioTime(pName:String):Float {
		if (timerMap[pName] == null) return 0;
		var now:Float = getActualTime();
		var totalDuration:Float = timerMap[pName].duration;
		var actualDuration:Float = now - timerMap[pName].start;
		
		return actualDuration / totalDuration;
	}
	
	/**
	 * Retourne le ratio de 0 à 1, de l'avancement de l'event.
	 * @param	pName nom de l'event repeater
	 * @return
	 */
	public function getRatioTimeRepeater(pName:String):Float {
		if (repeaterMap[pName] == null) return 0;
		var now:Float = getActualTime();
		
		var totalDuration:Float = repeaterMap[pName].dateEnd - repeaterMap[pName].start;
		var actualDuration:Float = now - repeaterMap[pName].start;
		
		return actualDuration / totalDuration;
	}
	
	/**
	 * Ajoute du temps au répéteur avant qu'il ne s'arète
	 * @param	pName
	 * @param	timeAdd
	 */
	public function addTimeDateEndAtRepeater(pName:String, timeAdd:Float):Void {
		repeaterMap[pName].dateEnd = repeaterMap[pName].dateEnd + timeAdd; 
	}
	
	/**
	 * Supprime l'event
	 * @autor	Chadi
	 * @param	pName nom de l'event
	 */
	public function supressTimeEvent(pName:String):Void {
		timerMap.remove(pName);
		removeAllListeners(TIME_MANAGER_EVENT + pName);
	}
	
	private function getAllSecondOfDate(pDate:Date):Int {
		var seconds:Int = pDate.getSeconds();
		seconds += pDate.getMinutes() * 60;
		seconds += pDate.getHours() * 3600;
		
		return seconds;
	}
	

	private function endOfTimeEvent(pName:String):Void {
		emit(TIME_MANAGER_EVENT + pName, pName);
		supressTimeEvent(pName);
	}
	
	private function emitAndRepeatEvent(pName:String, pStartTime:Float):Void {
		if (repeaterMap[pName] != null) {
			checkRepeaterTicLate(pName);
			
			var pEndTimeStamp:Float = pStartTime + repeaterMap[pName].duration;
			repeaterMap[pName].time = pEndTimeStamp;
			emit(REPEAT_MANAGER_EVENT + pName, pName);
		}
	}
	
	private function checkRepeaterTicLate(pName:String):Void {	
		var dateEnd:Float = getActualTime();
		if (repeaterMap[pName].dateEnd != null && dateEnd > repeaterMap[pName].dateEnd ) {
			dateEnd = repeaterMap[pName].dateEnd ;
		}
		var ticLate:Int = Math.floor((dateEnd - repeaterMap[pName].time) / repeaterMap[pName].duration); 
		for (i in 0...ticLate) {
			emit(REPEAT_MANAGER_EVENT + pName, pName);
		}
	}
	
	/**
	 * Termine l'event et emet sa callback
	 * @param	pName
	 */
	public function shortEndEvent (pName:String): Void {
		endOfTimeEvent(pName);
	}
	
	/**
	* Stop le répéteur
	* @param	pName
	*/
	public function stopRepeater(pName:String, ?pDateEnd:Float = null):Void {
	   repeaterMap.remove(pName);
	   removeAllListeners(REPEAT_MANAGER_EVENT + pName);
	}
	
	
	public function suppressAllTimer():Void {	
		for (key in repeaterMap.keys()) {
			stopRepeater(key);			
		}
		for (key in timerMap.keys()) {
			supressTimeEvent(key);
		}
	}
	
	/**
	 * Renvoie le temps restant pour l'évènement pEventName
	 * @param	pEventName
	 * @return
	 */
	public function getRemainingTime(pEventName:String):Float{
		var pDateNow:Float = getActualTime();
		var lEvent:TimerDef = timerMap[pEventName];
		if (lEvent == null) return 0;
		var remainingDate:Float = lEvent.endTimeStamp - pDateNow;
		return remainingDate;
	}
	
	/**
	 * Renvoie la date en string en ajoutant des 0 si cela est nécessaire ex : 00:25:08
	 * @param	pDate durée en millisecond
	 * @return
	 */
	public function getStringTimeWithHour(pDateTimeStamp:Float):String {
		var pStringDate:String = "";
		
		var lHours:Int = Math.floor(pDateTimeStamp / 3600000);
		if (lHours < 10) {
			pStringDate += "0";
		}
		pStringDate += lHours;
		
		var lMinutes:Int = Math.floor(pDateTimeStamp % 3600000);
		lMinutes = Math.floor(lMinutes / 60000);
		
		pStringDate += ":";
		
		if (lMinutes < 10) {
			pStringDate += "0";
		}
		
		pStringDate += lMinutes;
		
		var lSeconds:Int = Math.floor(Math.floor(pDateTimeStamp % 3600000) % 60000);
		lSeconds = Math.floor(lSeconds / 1000);
		
		pStringDate += ":";
		
		if (lSeconds < 10) {
			pStringDate += "0";
		}
		
		pStringDate += lSeconds;

		
		return pStringDate;
	}
	
	/**
	 * Renvoie le temps en millisecondes
	 * @param	pHours
	 * @param	pMinutes
	 * @param	pSeconds
	 * @return
	 */
	public function getMillisecond(pHours:Int, pMinutes:Int, pSeconds:Int):Int {
		var lMillisecond:Int = pHours * 60;
		lMillisecond += pMinutes;
		lMillisecond *= 60;
		lMillisecond += pSeconds;
		lMillisecond *= 1000;
		
		return lMillisecond;
	}
	
	
	public function update():Void {
		var timeStampNow:Float = getActualTime();
		
		checkTimer(timeStampNow);
		checkRepeater(timeStampNow);
	}
	
	
	private function checkTimer(pTimeStampNow:Float):Void {
		for (key in timerMap.keys()) {
			if (timerMap[key].endTimeStamp <= pTimeStampNow) {
				endOfTimeEvent(key);
			}
		}
	}
	
	
	private function checkRepeater(pTimeStampNow:Float):Void {
		for (key in repeaterMap.keys()) {
			if (repeaterMap[key].time <= pTimeStampNow) {
				emitAndRepeatEvent(key, repeaterMap[key].time);
			}
			
			if (repeaterMap[key].dateEnd != null && repeaterMap[key].dateEnd <= pTimeStampNow) {
				if (repeaterMap[key].callbackEnd != null) {
					repeaterMap[key].callbackEnd(key);					
				}
				
				stopRepeater(key, repeaterMap[key].dateEnd);
			}
		}
	}
	
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}