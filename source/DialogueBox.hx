package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		bgFade = new FlxSprite().makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFF000000);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);
		bgFade.screenCenter();

		this.dialogueList = dialogueList;
		
		portraitLeft = new FlxSprite(0, -20);
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'feet' | 'toes' | 'sole':
				portraitLeft.frames = Paths.getSparrowAtlas('dialogue/dogePortrait');
				portraitLeft.animation.addByPrefix('enter', 'doge icon enter', 24, false);
				portraitLeft.animation.addByPrefix('exit', 'doge icon exit', 24, false);
			case 'fire truck' | 'moster truck' | 'all bark no bite' | 'scrapped':
				portraitLeft.frames = Paths.getSparrowAtlas('dialogue/walterPortrait');
				portraitLeft.animation.addByPrefix('enter', 'walter icon enter', 24, false);
				portraitLeft.animation.addByPrefix('exit', 'walter icon exit', 24, false);
		}
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, -20);
		portraitRight.frames = Paths.getSparrowAtlas('dialogue/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'bf icon enter', 24, false);
		portraitRight.animation.addByPrefix('exit', 'bf icon exit', 24, false);
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		
		box = new FlxSprite().loadGraphic(Paths.image('dialogue/dialogueBox'));
		box.alpha = 0;
		add(box);

		FlxTween.tween(bgFade, {alpha: 0.75}, 2, {ease: FlxEase.expoInOut});
		FlxTween.tween(box, {alpha: 1}, 0.5, {ease: FlxEase.expoInOut});

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Comic Sans MS Bold';
		swagDialogue.color = 0xFFFFFFFF;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		if (!dialogueStarted)
		{
			startDialogue();
			FlxG.sound.playMusic(Paths.music('breakfast'), 0);
			FlxG.sound.music.fadeIn(1, 0, 0.2);
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (FlxG.sound.music != null)
						FlxG.sound.music.fadeOut(2, 0);

					if (portraitRight.animation.name != "exit")
						portraitRight.animation.play('exit');

					if (portraitLeft.animation.name != "exit")
						portraitLeft.animation.play('exit');

					FlxTween.tween(bgFade, {alpha: 0}, 2, {ease: FlxEase.expoInOut});
					FlxTween.tween(box, {alpha: 0}, 0.5, {ease: FlxEase.expoInOut});
					FlxTween.tween(portraitLeft, {alpha: 0}, 0.25, {ease: FlxEase.expoInOut});
					FlxTween.tween(portraitRight, {alpha: 0}, 0.25, {ease: FlxEase.expoInOut});
					FlxTween.tween(swagDialogue, {alpha: 0}, 0.5, {ease: FlxEase.expoInOut});

					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);

		if (curCharacter == 'dad') {

			portraitLeft.visible = true;

			if (portraitLeft.animation.name != "enter")
				portraitLeft.animation.play('enter');
			
			if (portraitRight.animation.name != "exit")
				portraitRight.animation.play('exit');

			switch (PlayState.SONG.song.toLowerCase()) {
				case "feet" | "toes" | "sole":
					swagDialogue.font = 'Comic Sans MS Bold';
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				
				case "fire truck" | "moster truck" | "all bark no bite" | "scrapped":
					swagDialogue.font = 'Comic Sans MS Bold';
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
			}
		}
		if (curCharacter == 'bf') {

			portraitRight.visible = true;

			if (portraitRight.animation.name != "enter")
				portraitRight.animation.play('enter');
			
			if (portraitLeft.animation.name != "exit")
				portraitLeft.animation.play('exit');

			swagDialogue.font = 'Pixel Arial 11 Bold';
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		}

		swagDialogue.start(0.04, true);
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
