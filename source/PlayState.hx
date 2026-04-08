package;

import flixel.group.FlxSpriteGroup;
import flixel.util.FlxCollision;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	public var _collectables:FlxSpriteGroup;
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

		_player.maxVelocity.set(80, 800);
		_player.drag.x = _player.maxVelocity.x * 4;

		_player.acceleration.set(0, _player.maxVelocity.y);

		_player.x = _player.drag.x / 3;
		_player.y = _floor.y - _player.height;

		add(_player);

		_collectables = new FlxSpriteGroup();
		add(_collectables);
	}

	var playerJumps:Int = 0;
	var playerJumpsMax:Int = 1;

	var collectableSpawnTick:Int = 0;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		collectableSpawnTick -= 1;

		FlxG.collide(_player, _floor, onFloor);

		if (FlxG.keys.justReleased.SPACE && playerJumps < playerJumpsMax)
		{
			_player.velocity.y = -_player.maxVelocity.y / 2;
			playerJumps++;
		}

		if (collectableSpawnTick <= 0)
		{
			spawnCollectable();

			collectableSpawnTick = 100;
		}

		for (collectable in _collectables)
		{
			if (collectable == null)
				continue;

			collectable.x -= collectable.width / 4;

			FlxG.overlap(_player, collectable, collectCollectable);
		}
	}

	function onFloor(o1, o2)
	{
		_player.velocity.y = 0;
		playerJumps = 0;
	}

	function spawnCollectable()
	{
		var collectableCount:Int = FlxG.random.int(0, 6, [1, 3, 5]);
		var i = 0;

		while (collectableCount > 0)
		{
			var newCollectable:FlxSprite = makeCollectable();

			newCollectable.screenCenter();
			newCollectable.x = FlxG.width + newCollectable.width;
			newCollectable.y -= newCollectable.height * 6;

			newCollectable.x += i * newCollectable.width * 1.25;

			_collectables.add(newCollectable);

			collectableCount -= 1;
			i += 1;
		}
	}

	function makeCollectable():FlxSprite
	{
		return new FlxSprite().makeGraphic(16, 16, FlxColor.YELLOW);
	}

	function collectCollectable(player:FlxSprite, collectable:FlxSprite)
	{
		_collectables.remove(collectable);
		collectable.destroy();
	}
}
