package;

import flixel.FlxG;
import hscript.*;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class FunkinScript
{
	public var interp:Interp;

	public function new(file:String)
	{
		interp = new Interp();
		var parser:Parser = new Parser();

		parser.allowTypes = true;
		parser.allowJSON = true;
		parser.allowMetadata = true;

		preset();

		if (FileSystem.exists(file))
		{
			var getScript = parser.parseString(File.getContent(file));
			interp.execute(getScript);
		}
	}

	public function preset()
	{
		var daState = FlxG.state;

		set("add", daState.add);
		set("destroy", daState.destroy);
		set("remove", daState.remove);

		// haxe
		set('Type', Type);
		set('Math', Math);
		set('Std', Std);
		set('Date', Date);

		// flixel
		set('FlxG', flixel.FlxG);
		set('FlxBasic', flixel.FlxBasic);
		set('FlxObject', flixel.FlxObject);
		set('FlxSprite', flixel.FlxSprite);
		set('FlxSound', flixel.system.FlxSound);
		set('FlxSort', flixel.util.FlxSort);
		set('FlxStringUtil', flixel.util.FlxStringUtil);
		set('FlxState', flixel.FlxState);
		set('FlxSubState', flixel.FlxSubState);
		set('FlxText', flixel.text.FlxText);
		set('FlxTimer', flixel.util.FlxTimer);
		set('FlxTween', flixel.tweens.FlxTween);
		set('FlxEase', flixel.tweens.FlxEase);
		set('FlxTrail', flixel.addons.effects.FlxTrail);

		// funkin
		set('Alphabet', Alphabet);
		set('CoolUtil', CoolUtil);
		set('Character', Character);
		set('Conductor', Conductor);
		// set('PlayState', PlayState);
		set('Paths', Paths);

		set('CoolLogSystem', CoolLogSystem);

		set('createLog', CoolLogSystem.log);
		set('createError', CoolLogSystem.error);
		set('createWarning', CoolLogSystem.warning);
	}

	public function set(name:String, value:Dynamic)
		interp.variables.set(name, value);

	public function get(name:String)
		return interp.variables.get(name);

	public function call(name:String, value:Array<Dynamic>)
	{
		if (value == null)
			value = [];

		if (interp == null)
		{
			return null;
		}
		if (interp.variables.exists(name))
		{
			var functionH = interp.variables.get(name);
			if (value == null)
			{
				var result = null;
				result = functionH();
				return result;
			}
			else
			{
				var result = null;
				result = Reflect.callMethod(null, functionH, value);
				return result;
			}
		}
		return null;
	}
}