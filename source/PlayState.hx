package;

import flixel.util.FlxCollision;
import flixel.math.FlxMath;
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
		
		_player.maxVelocity.set(80, 200);
		_player.acceleration.y = 200;
		_player.drag.x = _player.maxVelocity.x * 4;

		add(_player);
	}

	var player_accelValue = 100;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.SPACE)
			_player.velocity.y = -_player.maxVelocity.y / 2;

		FlxG.collide(_player, _floor);
	}
}
