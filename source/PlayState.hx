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
		_floor.immovable = true;
		add(_floor);

		_player = new FlxSprite();
		_player.makeGraphic(32, 32, FlxColor.RED);

		_player.maxVelocity.set(80, 200);
		_player.acceleration.y = 200;
		_player.drag.x = _player.maxVelocity.x * 4;

		add(_player);
	}

	var playerJumps:Int = 0;
	var playerJumpsMax:Int = 1;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(_player, _floor, onFloor);

		if (FlxG.keys.justReleased.SPACE && playerJumps < playerJumpsMax)
		{
			_player.velocity.y = -_player.maxVelocity.y / 2;
			playerJumps++;
		}
	}

	function onFloor(o1, o2)
	{
		_player.velocity.y = 0;
		playerJumps = 0;
	}
}
