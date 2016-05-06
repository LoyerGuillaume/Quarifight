package com.gloyer.libs;

import com.isartdigital.utils.events.MouseEventType;
import com.isartdigital.utils.events.TouchEventType;
import eventemitter3.EventEmitter;
import js.html.TouchEvent;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

	
/**
 * ...
 * @author Loyer Guillaume
 */
class MouseController extends EventEmitter
{
	
	private var isMouseDown:Bool = false;
	
	private var scrollingMode:Bool = false;
	
	public static inline var MOUSE_MOVE_EVENT:String = "MOUSE MOVE EVENT";
	public static inline var MOUSE_DOWN_MOVE_EVENT:String = "MOUSE DOWN MOVE EVENT";
	public static inline var MOUSE_DOWN_EVENT:String = "MOUSE DOWN EVENT";
	public static inline var MOUSE_CLICK_EVENT:String = "MOUSE CLICK EVENT";
	public static inline var MOUSE_UP_EVENT:String = "MOUSE UP EVENT";
	
	public var currentPosition:Point;
	
	/**
	 * Nombre d'appelle à l'event move lors d'un drag
	 */
	public var numberOfMovementScroll:Int = 0;
	
	/**
	 * Nombre d'appelle max, avant de considèrer le clic comme un scroll
	 */
	private static inline var MAX_MOUSE_MOVEMENT_SCROLL_DEFAULT:Int = 10;
	private var maxMouseMovementScroll:Int;
	
	
	/**
	 * instance unique de la classe ControllerMouse
	 */
	private static var instance: MouseController;
	
	private var container:Container;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): MouseController {
		if (instance == null) instance = new MouseController();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
	}
	
	/**
	 * Initialise les events de la souris
	 */
	public function start(pContainer:Container, ?pMaxMouvementScroll:Int = MAX_MOUSE_MOVEMENT_SCROLL_DEFAULT):Void {
		maxMouseMovementScroll = pMaxMouvementScroll;
		setContainer(pContainer);
		initEventDesktop();
	}
	
	private function initEventDesktop():Void {
		container.on(MouseEventType.MOUSE_MOVE, onMove);
		container.on(MouseEventType.MOUSE_OUT, onMouseOut);
		container.on(MouseEventType.MOUSE_DOWN, onMouseDown);
		container.on(MouseEventType.CLICK, onMouseClick);
	}
	
	public function setContainer(pContainer:Container):Void {
		container = pContainer;
		container.interactive = true;
	}
	
	private function onMouseOut(pEvent:EventTarget):Void {
		isMouseDown = false;
	}
	
	private function onMouseDown(pEvent:EventTarget):Void {
		isMouseDown = true;
		numberOfMovementScroll = 0;
		
		var positionMouse:Point = pEvent.data.getLocalPosition(container);
		currentPosition = new Point(positionMouse.x, positionMouse.y);
		
		container.on(MouseEventType.MOUSE_UP, onMouseUp);
		emit(MOUSE_DOWN_EVENT);
	}
	
	private function onMouseClick(pEvent:EventTarget):Void { // FIXME
		if (numberOfMovementScroll <= maxMouseMovementScroll) {
			var positionMouse:Point = pEvent.data.getLocalPosition(container);
			currentPosition = new Point(positionMouse.x, positionMouse.y);
			emit(MOUSE_CLICK_EVENT, currentPosition);
		}
	}
	
	private function onMouseUp(pEvent:EventTarget):Void {
		isMouseDown = false;
		container.off(MouseEventType.MOUSE_UP, onMouseUp);
		emit(MOUSE_UP_EVENT);
	}
	
	private function onMove(pEvent:EventTarget):Void {
		var positionMouse:Point = pEvent.data.getLocalPosition(container);
		
		if (isMouseDown) {
			numberOfMovementScroll++;
			emit(MOUSE_DOWN_MOVE_EVENT, positionMouse);
		}
		
		currentPosition = new Point(positionMouse.x, positionMouse.y);
		emit(MOUSE_MOVE_EVENT, currentPosition);
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}