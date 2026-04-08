package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	public var _player:FlxSprite;
	public var _floor:FlxSprite;

	override public function create()
	{
		super.create();

		_floor = new FlxSprite(0, FlxG.height / 2);
		_floor.makeGraphic(FlxG.width, Math.round(_floor.y), FlxColor.GRAY);
		add(_floor);

		_player = new FlxSprite();
		_player.makeGraphic(32, 32, FlxColor.RED);
		add(_player);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.SPACE)
			_player.velocity.y -= 10;
	}
}
