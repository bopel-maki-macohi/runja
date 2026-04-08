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
	public var _obstacles:FlxSpriteGroup;
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

		_obstacles = new FlxSpriteGroup();
		add(_obstacles);
	}

	var playerJumps:Int = 0;
	var playerJumpsMax:Int = 1;

	var interactableSpawnTick:Int = 0;
	var interactableResetSpawnTick:Int = 150;
	var interactableSpawnCount:Int = 0;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		interactableSpawnTick -= 1;

		FlxG.collide(_player, _floor, onFloor);

		if (FlxG.keys.justReleased.SPACE && playerJumps < playerJumpsMax)
		{
			_player.velocity.y = -_player.maxVelocity.y / 2;
			playerJumps++;
		}

		if (interactableSpawnTick <= 0)
		{
			final collectable:Bool = FlxG.random.bool(45);

			spawnInteractables(collectable);
			interactableSpawnCount += 1;

			interactableSpawnTick = FlxG.random.int(100, interactableResetSpawnTick);

			if (interactableResetSpawnTick > 100)
				interactableResetSpawnTick -= Math.round(2 * (interactableSpawnCount * (interactableSpawnTick / interactableResetSpawnTick)));
		}

		scroll(_collectables, interactCollectable);
		scroll(_obstacles, interactObstacle);

		FlxG.watch.addQuick('interactableResetSpawnTick', interactableResetSpawnTick);
		FlxG.watch.addQuick('interactableSpawnCount', interactableSpawnCount);
		FlxG.watch.addQuick('interactableSpawnTick', interactableSpawnTick);
	}

	function scroll(group:FlxSpriteGroup, overlapMethod:Null<(Dynamic, Dynamic) -> Void>)
	{
		for (object in group)
		{
			if (object == null)
				continue;

			object.x -= object.width / Math.max(1, 4 - (interactableSpawnCount / 50));

			FlxG.overlap(_player, object, overlapMethod);
		}
	}

	function onFloor(o1, o2)
	{
		_player.velocity.y = 0;
		playerJumps = 0;
	}

	function spawnInteractables(collectable:Bool)
	{
		var interactableCount:Int = 0;
		var floorInteractables = FlxG.random.bool() || _player.velocity.y < 10 && FlxG.random.bool(74);

		var i = 0;

		if (collectable)
		{
			interactableCount = FlxG.random.int(2, 6, [3, 5]);
		}
		else
		{
			interactableCount = FlxG.random.int(2, 4, [3]);
		}

		if (interactableCount < 1)
			return;

		trace('Spawning '
			+ interactableCount
			+ ((floorInteractables) ? ' Floor' : ' Sky')
			+ ((collectable) ? ' Collectable(s)' : ' Obstacle(s)'));

		while (interactableCount > 0)
		{
			var interactable:FlxSprite = (collectable) ? makeCollectable() : makeObstacle();

			interactable.screenCenter();
			interactable.x = FlxG.width + (interactable.width * 2);

			if (floorInteractables)
				interactable.y -= interactable.height * 1;
			else
				interactable.y -= interactable.height * 6;

			interactable.x += i * interactable.width * 1.25;

			if (collectable)
				_collectables.add(interactable);
			else
				_obstacles.add(interactable);

			interactableCount -= 1;
			i += 1;
		}
	}

	function makeCollectable():FlxSprite
	{
		return new FlxSprite().makeGraphic(16, 16, FlxColor.YELLOW);
	}

	function makeObstacle():FlxSprite
	{
		return new FlxSprite().makeGraphic(16, 16, FlxColor.GRAY);
	}

	function interactCollectable(player:FlxSprite, collectable:FlxSprite)
	{
		_collectables.remove(collectable);
		collectable.destroy();
	}

	function interactObstacle(player:FlxSprite, obstacle:FlxSprite)
	{
		_obstacles.remove(obstacle);
		obstacle.destroy();

		trace('YOU DEAD');
	}
}
