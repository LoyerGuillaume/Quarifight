package com.gloyer.quarifight.game;
import com.gloyer.libs.TimerDelay;
import com.gloyer.quarifight.game.sprites.Eat;
import com.gloyer.quarifight.game.sprites.Fish;
import com.gloyer.quarifight.game.sprites.LevelBackground;
import com.gloyer.libs.MouseController;
import com.isartdigital.utils.game.GameStage;
import haxe.Timer;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.interaction.EventTarget;

	
/**
 * ...
 * @author Loyer Guillaume
 */
class LevelManager 
{
	
	/**
	 * instance unique de la classe LevelManager
	 */
	private static var instance: LevelManager;
	
	public static var DISTANCE_TOP_GROUND:Int = 500;
	
	private var container:Container;
	private var containerEat:Container;
	private var containerFish:Container;
	
	private var listEat:Array<Eat>;
	private var listFish:Array<Fish>;
	
	private var currentLevel:Int;
	private var currentBackground:LevelBackground;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): LevelManager {
		if (instance == null) instance = new LevelManager();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		container     = new Container();
		containerEat  = new Container();
		containerFish = new Container();
	}
	
	public function getContainer():Container {
		return container;
	}
	
	public function start():Void {
		startLevel(1);

		initContainer();

		test();
		
		MouseController.getInstance().start(GameStage.getInstance().getGameContainer(), 100);
		initEvent();
	}
	
	private function test():Void {
		addFish(new Point(50, 50));
		addFish(new Point(50, 50));
		addFish(new Point(50, 50));
		addFish(new Point(50, 50));
		addFish(new Point(50, 50));
		
	}
	
	private function initContainer():Void {
		container.addChild(currentBackground);
		container.addChild(containerEat);
		container.addChild(containerFish);
	}
	
	
	private function startLevel(pLevel:Int):Void {
		currentLevel = pLevel;
		resetParamLevel();
		changeBackground();
	}
	
	private function resetParamLevel():Void {
		listEat = new Array<Eat>();
		listFish = new Array<Fish>();
	}
	
	private function changeBackground():Void {
		currentBackground = new LevelBackground(currentLevel); //FOR TEST
	}
	
	private function initEvent():Void {
		MouseController.getInstance().on(MouseController.MOUSE_CLICK_EVENT, clickInLevel);
	}
	
	private function clickInLevel(pPosition:Point):Void {
		addEat(pPosition);
	}
	
	private function addEat(pPosition:Point):Void {
		var eat:Eat = new Eat(1);
		containerEat.addChild(eat);
		eat.position.set(pPosition.x, pPosition.y);
		eat.start();
		listEat.push(eat);
	}
	
	private function addFish(pPosition:Point):Void {
		var lFish:Fish = new Fish(1);
		containerFish.addChild(lFish);
		lFish.position.set(pPosition.x, pPosition.y);
		lFish.start();
		listFish.push(lFish);
	}
	
	public function destroyEat(pEat:Eat):Void {
		listEat.remove(pEat);
		containerEat.removeChild(pEat);
		pEat.destroy();
	}
	
	public function gameLoopLevel():Void {
		var lEat:Eat;
		for (lEat in listEat) {
			lEat.doAction();
		}
		
		var lFish:Fish;
		for (lFish in listFish) {
			lFish.doAction();
		}
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		instance = null;
	}

}