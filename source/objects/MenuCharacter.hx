package objects;

import openfl.utils.Assets;
import haxe.Json;

typedef MenuCharacterFile = {
	var image:String;
	var scale:Float;
	var position:Array<Int>;
	var idle_anim:String;
	var confirm_anim:String;
	var confirm_offset:Array<Int>;
	var flipX:Bool;
}

class MenuCharacter extends FlxSprite
{
	public var character:String;
	public var hasConfirmAnimation:Bool = false;
	public var confirmOffsets:Array<Int>;
	private static var DEFAULT_CHARACTER:String = 'bf';

	public function new(x:Float, character:String = 'bf')
	{
		super(x);

		antialiasing = ClientPrefs.data.antialiasing;
		changeCharacter(character);
	}

	public function changeCharacter(?character:String = 'bf') {
		if(character == null) character = '';
		if(character == this.character) return;

		this.character = character;
		visible = true;

		var dontPlayAnim:Bool = false;
		scale.set(1, 1);
		updateHitbox();

		hasConfirmAnimation = false;
		switch(character) {
			case '':
				visible = false;
				dontPlayAnim = true;
			default:
				var characterPath:String = 'images/menucharacters/' + character + '.json';
				var rawJson = null;

				#if MODS_ALLOWED
				var path:String = Paths.modFolders(characterPath);
				if (!FileSystem.exists(path)) {
					path = Paths.getSharedPath(characterPath);
				}

				if(!FileSystem.exists(path)) {
					path = Paths.getSharedPath('images/menucharacters/' + DEFAULT_CHARACTER + '.json');
				}
				rawJson = File.getContent(path);

				#else
				var path:String = Paths.getSharedPath(characterPath);
				if(!Assets.exists(path)) {
					path = Paths.getSharedPath('images/menucharacters/' + DEFAULT_CHARACTER + '.json');
				}
				rawJson = Assets.getText(path);
				#end
				
				var charFile:MenuCharacterFile = cast Json.parse(rawJson);
				frames = Paths.getSparrowAtlas('menucharacters/' + charFile.image);
				animation.addByPrefix('idle', charFile.idle_anim, 24);

				var confirmAnim:String = charFile.confirm_anim;
				if(confirmAnim != null && confirmAnim.length > 0 && confirmAnim != charFile.idle_anim)
				{
					animation.addByPrefix('confirm', confirmAnim, 24, false);
					if (animation.getByName('confirm') != null) //check for invalid animation
						hasConfirmAnimation = true;
				}

				if(charFile.confirm_offset != null) confirmOffsets = [charFile.confirm_offset[0], charFile.confirm_offset[1]];

				flipX = (charFile.flipX == true);

				if(charFile.scale != 1) {
					scale.set(charFile.scale, charFile.scale);
					updateHitbox();
				}
				offset.set(charFile.position[0], charFile.position[1]);
				animation.play('idle');
		}
	}
}
