package game.sprites;

import dependency.Paths;
import flixel.FlxG;
import flixel.FlxSprite;
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

typedef JsonData =
{
	var offsets:jsonHelper.JsonExtra.Point;
	var alpha:Float;
	var setScale:Float;
}

class NoteSplash extends FlxSprite
{
	var json:JsonData;
	var notes:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT"];

	public var skin:String = "default";

	public function new(x:Float, y:Float, data:Int, skin:String = "default")
	{
		super(x, y);

		this.skin = skin;

		loadAssets(skin);

		execute(x, y, data);
	}

	public function execute(xPOS:Float, yPOS:Float, data:Int)
	{
		setPosition(xPOS, yPOS);
		alpha = json.alpha;

		if (json.setScale != 1)
		{
			scale.set(json.setScale, json.setScale);
		}

		updateHitbox();
		offset.set(json.offsets.x, json.offsets.y);

		animation.play(notes[data], true);
	}

	function loadAssets(asset:String)
	{
		json = Json.parse(File.getContent(Paths.json('noteSplashes/${asset}')));

		frames = Paths.getSparrowAtlas('ui/${asset}/splash');

		for (i in 0...notes.length)
		{
			animation.addByPrefix(notes[i], "Splash" + notes[i], 24, false);
		}
	}

	override function update(elapsed:Float)
	{
		if (animation.curAnim.finished)
			kill();

		super.update(elapsed);
	}
}
