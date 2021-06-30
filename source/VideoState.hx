//Origin by GWebDev,KadeDev, Fixed by Raltyro for Kade Engine 1.5.#

package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import flixel.system.FlxSound;
import openfl.display.BitmapData;
import openfl.utils.Assets;
import openfl.utils.AssetType;
import haxe.io.Path;
import openfl.Lib;
#if desktop
import webm.*;
import webm.WebmPlayer; // idk
#end

using StringTools;

class VideoState extends MusicBeatState {
	public var filePath:String;
	public var transClass:FlxState;
	public var fuckingVolume:Float = 1;
	public var notDone:Bool = true;
	public var vidSound:FlxSound;
	public var useSound:Bool = false;
	public var soundMultiplier:Float = 1;
	public var prevSoundMultiplier:Float = 1;
	public var videoFrames:Int = 0;
	public var fixr:Int = 0;
	public var doShit:Bool = false;
	public var autoPause:Bool = false;
	public var musicPaused:Bool = false;
	public var bitmapData:BitmapData;
	#if desktop
	private var defaultskiplimit = WebmPlayer.SKIP_STEP_LIMIT;
	#end

	public function new(fileName:String,toTrans:FlxState,frameSkipLimit:Int = -1,autopause:Bool = false) {
		super();

		autoPause = autopause;

		filePath = fileName;
		transClass = toTrans;
		bitmapData = null;
		if (frameSkipLimit != -1 && GlobalVideo.isWebm) {
			#if desktop
			WebmPlayer.SKIP_STEP_LIMIT = frameSkipLimit;
			#end
		}
	}

	override function create() {
		super.create();
		notDone = true;
		FlxG.autoPause = false;
		doShit = false;
		
		var txtdata:Array<String> = (Assets.getText(filePath.replace(".webm",".txt"))).split(':');
		videoFrames = Std.parseInt(txtdata[0]);
		fixr = Std.parseInt(txtdata[1]);
		
		fuckingVolume = FlxG.sound.music.volume;
		FlxG.sound.music.volume = 0;
		
		if (Assets.exists(filePath.replace(".webm", ".ogg"), MUSIC) || Assets.exists(filePath.replace(".webm", ".ogg"), SOUND)) {
			useSound = true;
			vidSound = FlxG.sound.play(filePath.replace(".webm", ".ogg"));
		}
		
		GlobalVideo.get().source(filePath);
		GlobalVideo.get().clearPause();
		if (GlobalVideo.isWebm)
		{
			GlobalVideo.get().updatePlayer();
		}
		GlobalVideo.get().show();

		if (GlobalVideo.isWebm) {
			GlobalVideo.get().restart();
		} 
		else {
			GlobalVideo.get().play();
		}
		
		if (GlobalVideo.isWebm) {
			bitmapData = GlobalVideo.get().webm.bitmapData;
		}
		else {
			bitmapData = GlobalVideo.get().video.bitmapData;
		}

		/*if (useSound)
			{ */
		// vidSound = FlxG.sound.play(filePath.replace(".webm", ".ogg"));

		/*new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{ */
		vidSound.time = vidSound.length * soundMultiplier;
		/*new FlxTimer().start(1.2, function(tmr:FlxTimer)
			{
				if (useSound)
				{
					vidSound.time = vidSound.length * soundMultiplier;
				}
		}, 0);*/
		doShit = true;
		// }, 1);
		// }

		if (autoPause && FlxG.sound.music != null && FlxG.sound.music.playing) {
			musicPaused = true;
			FlxG.sound.music.pause();
		}
		GlobalVideo.get().resume();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		
		if (useSound) {
			var wasFuckingHit;
			if (GlobalVideo.isWebm) {
				wasFuckingHit = GlobalVideo.get().webm.wasHitOnce;
				soundMultiplier = GlobalVideo.get().webm.renderedCount / videoFrames;
			}
			else {
				wasFuckingHit = GlobalVideo.get().video.wasHitOnce;
				soundMultiplier = GlobalVideo.get().video.renderedCount / videoFrames;
			}
			if (soundMultiplier > 1) {
				soundMultiplier = 1;
			}
			if (soundMultiplier < 0) {
				soundMultiplier = 0;
			}
			if (doShit) {
				var compareShit:Float = 50;
				if (vidSound.time >= (vidSound.length * soundMultiplier) + compareShit
					|| vidSound.time <= (vidSound.length * soundMultiplier) - compareShit)
					vidSound.time = vidSound.length * soundMultiplier;
			}
			if (wasFuckingHit) {
				if (soundMultiplier == 0) {
					if (prevSoundMultiplier != 0) {
						vidSound.pause();
						vidSound.time = 0;
					}
				} else {
					if (prevSoundMultiplier == 0) {
						vidSound.resume();
						vidSound.time = vidSound.length * soundMultiplier;
					}
				}
				prevSoundMultiplier = soundMultiplier;
			}
		}
		
		if (notDone) {
			FlxG.sound.music.volume = 0;
		}
		
		GlobalVideo.get().update(elapsed);

		if (controls.ACCEPT || GlobalVideo.get().ended || GlobalVideo.get().stopped) {
			GlobalVideo.get().hide();
			GlobalVideo.get().stop();
		}

		if (controls.ACCEPT || GlobalVideo.get().ended) {
			notDone = false;
			FlxG.sound.music.volume = fuckingVolume;
			FlxG.autoPause = true;
			GlobalVideo.get().stop();
			if (musicPaused) {
				musicPaused = false;
				FlxG.sound.music.resume();
			}
			GlobalVideo.get().source("assets/videos/00placeholder/placeholder.webm");
			FlxG.switchState(transClass);
		}

		if (GlobalVideo.get().played || GlobalVideo.get().restarted) {
			GlobalVideo.get().show();
		}

		GlobalVideo.get().restarted = false;
		GlobalVideo.get().played = false;
		GlobalVideo.get().stopped = false;
		GlobalVideo.get().ended = false;
	}
}