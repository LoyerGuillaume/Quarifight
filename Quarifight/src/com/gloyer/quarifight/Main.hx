package com.gloyer.quarifight;

import com.gloyer.quarifight.game.GameManager;
import com.gloyer.quarifight.ui.GraphicLoader;
import com.gloyer.quarifight.ui.screens.TitleCard;
import com.gloyer.quarifight.ui.UIManager;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.Debug;
import com.isartdigital.utils.events.EventType;
import com.isartdigital.utils.events.LoadEventType;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.GameStageScale;
import com.isartdigital.utils.game.StateGraphic;
import com.isartdigital.utils.game.factory.MovieClipAnimFactory;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.system.DeviceCapabilities;
import eventemitter3.EventEmitter;
import js.Browser;
import pixi.core.display.Container;
import pixi.core.renderers.Detector;
import pixi.core.renderers.webgl.WebGLRenderer;
import pixi.interaction.EventTarget;
import pixi.loaders.Loader;

/**
 * Classe d'initialisation et lancement du jeu
 * @author Mathieu ANTHOINE
 */

class Main extends EventEmitter
{
	
	/**
	 * chemin vers le fichier de configuration
	 */
	private static var configPath:String = "config.json";	
	
	/**
	 * instance unique de la classe Main
	 */
	private static var instance: Main;
	
	/**
	 * renderer (WebGL ou Canvas)
	 */
	public var renderer:WebGLRenderer;
	
	/**
	 * Element racine de la displayList
	 */
	public var stage:Container;
	
	/**
	 * initialisation générale
	 */
	private static function main ():Void {
		Main.getInstance();
	}

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Main {
		if (instance == null) instance = new Main();
		return instance;
	}
	
	/**
	 * création du jeu et lancement du chargement du fichier de configuration
	 */
	private function new () {
		
		super();
		
		var lOptions:RenderingOptions = {};
		//lOptions.antialias = true;
		//lOptions.autoResize = true;
		lOptions.backgroundColor = 0x999999;
		//lOptions.resolution = 1;
		//lOptions.transparent = false;
		//lOptions.preserveDrawingBuffer (pour dataToURL)
		
		renderer = Detector.autoDetectRenderer(DeviceCapabilities.width, DeviceCapabilities.height,lOptions);
		
		//renderer.roundPixels = true;
		
		Browser.document.body.appendChild(renderer.view);

		stage = new Container();
		
		var lConfig:Loader = new Loader();
		configPath += "?" + Date.now().getTime();
		lConfig.add(configPath);
		lConfig.once(LoadEventType.COMPLETE, preloadAssets);
		
		lConfig.load();

	}
	
	/**
	 * charge les assets graphiques du preloader principal
	 */
	private function preloadAssets(pLoader:Loader):Void {
		
		// initialise les paramètres de configuration
		Config.init(Reflect.field(pLoader.resources,configPath).data);
		
		// Active le mode debug
		if (Config.debug) Debug.getInstance().init();
		// défini l'alpha des Boxes de collision
		if (Config.debug && Config.data.boxAlpha != null) StateGraphic.boxAlpha = Config.data.boxAlpha;
		// défini l'alpha des anims
		if (Config.debug && Config.data.animAlpha != null) StateGraphic.animAlpha = Config.data.animAlpha;
		
		// défini le mode de redimensionnement du Jeu
		GameStage.getInstance().scaleMode = GameStageScale.SHOW_ALL;
		// initialise le GameStage et défini la taille de la safeZone
		GameStage.getInstance().init(render,2048, 1366,true);
		
		// affiche le bouton FullScreen quand c'est nécessaire
		DeviceCapabilities.displayFullScreenButton();
		
		// Ajoute le GameStage au stage
		stage.addChild(GameStage.getInstance());
		
		// ajoute Main en tant qu'écouteur des évenements de redimensionnement
		Browser.window.addEventListener(EventType.RESIZE, resize);
		resize();
		
		// lance le chargement des assets graphiques du preloader
		var lLoader:GameLoader = new GameLoader();
		lLoader.addAssetFile("black_bg.png");
		lLoader.addAssetFile("preload.png");
		lLoader.addAssetFile("preload_bg.png");
		
		lLoader.once(LoadEventType.COMPLETE, loadAssets);
		lLoader.load();
		
	}	
	
	/**
	 * lance le chargement principal
	 */
	private function loadAssets (pLoader:GameLoader): Void {
		
		var lLoader:GameLoader = new GameLoader();
				
		lLoader.addTxtFile("boxes.json");
		lLoader.addSoundFile("sounds.json");

		lLoader.addAssetFile("alpha_bg.png");
		lLoader.addAssetFile("TitleCard_bg.png");
		lLoader.addAssetFile("Confirm.png");
		//lLoader.addAssetFile("Template.json");
		lLoader.addFontFile("fonts.css");

		lLoader.on(LoadEventType.PROGRESS, onLoadProgress);
		lLoader.once(LoadEventType.COMPLETE, onLoadComplete);
		
		DeviceCapabilities.init();
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/ingame/library.json");
		lLoader.addAssetFile(DeviceCapabilities.textureType+"/ui/library.json");

		// affiche l'écran de préchargement
		UIManager.getInstance().openScreen(GraphicLoader.getInstance());
		
		Browser.window.requestAnimationFrame(gameLoop);
		
		lLoader.load();
		
	}
	
	/**
	 * transmet les paramètres de chargement au préchargeur graphique
	 * @param	pEvent evenement de chargement
	 */
	private function onLoadProgress (pLoader:GameLoader): Void {
		GraphicLoader.getInstance().update(pLoader.progress/100);
	}
	
	/**
	 * initialisation du jeu
	 * @param	pEvent evenement de chargement
	 */
	private function onLoadComplete (pLoader:GameLoader): Void {
		
		pLoader.off(LoadEventType.PROGRESS, onLoadProgress);
		
		// transmet à MovieClipAnimFactory la description des planches de Sprites utilisées par les anim MovieClip des instances de StateGraphic
		//MovieClipAnimFactory.addTextures(GameLoader.getContent("Template.json"));
				
		// transmet au StateGraphic la description des boxes de collision utilisées par les instances de StateGraphic
		//StateGraphic.addBoxes(GameLoader.getContent("boxes.json"));
		
		// Ouvre la TitleClard
		//UIManager.getInstance().openScreen(TitleCard.getInstance());
		GameManager.getInstance().start();
		
	}
	
	/**
	 * game loop
	 */
	private function gameLoop(pID:Float):Void {
		Browser.window.requestAnimationFrame(gameLoop);
		
		render();		
		emit(EventType.GAME_LOOP);
		
	}
	
	/**
	 * Ecouteur du redimensionnement
	 * @param	pEvent evenement de redimensionnement
	 */
	public function resize (pEvent:EventTarget = null): Void {
		renderer.resize(DeviceCapabilities.width, DeviceCapabilities.height);
		GameStage.getInstance().resize();
	}
	
	/**
	 * fait le rendu de l'écran
	 */
	private function render (): Void {
		renderer.render(stage);
	}
		
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void {
		Browser.window.removeEventListener(EventType.RESIZE, resize);
		instance = null;
	}
	
}