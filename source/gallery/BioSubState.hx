package gallery;

import flixel.util.FlxSpriteUtil;
import lime.utils.Assets;
import haxe.Json;

class BioSubState extends MusicBeatSubstate
{
    var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

    public var charData:Array<{name:String, renderCount:Int, displayName:String, bio:String, textSize:Int, color:String}> = [];

    var charImg:FlxSprite;
    var bioBox:FlxSprite;
    var charName:Alphabet;
    var bioTxt:FlxText;
    
    var charImgAlphaTween:FlxTween;
    var intendedCharX:Float;
    var intendedCharY:Float;

	var curSelected:Int = 0;
    
	var curPoseSelected:Int = 0;
    var canChangePose:Bool;

    var leftArrow:FlxSprite;
    var rightArrow:FlxSprite;
    
    var upArrow:FlxSprite;
    var downArrow:FlxSprite;

	var bottomString:String;
	var bottomText:FlxText;
	var bottomBG:FlxSprite;

    public function new()
    {
	    super();

        charData = Json.parse(Assets.getText(Paths.json('galleryBioData'))).bios;

        bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

        charImg = new FlxSprite(0, 0);
        charImg.antialiasing = ClientPrefs.data.antialiasing;
        add(charImg);

        bioBox = new FlxSprite(0, 0).makeGraphic(640, 490, FlxColor.TRANSPARENT);
        bioBox.x = FlxG.width - 780;
        bioBox.screenCenter(Y);
        bioBox.alpha = 0.5;
        add(bioBox);

        FlxSpriteUtil.drawRoundRect(bioBox, 0, 0, bioBox.width, bioBox.height, 120, 120, FlxColor.BLACK, {thickness: 20, color: FlxColor.WHITE});
		bioBox.antialiasing = ClientPrefs.data.antialiasing;

        charName = new Alphabet(0, 0, "WOA", true);
        charName.scaleX = 0.9;
        charName.scaleY = 0.9;
		charName.y = bioBox.y - (charName.height / 2);
		add(charName);

        bioTxt = new FlxText(bioBox.x + 16, bioBox.y + 44, bioBox.width - 32, "FLY??? YOOOO", 22);
		bioTxt.setFormat(Paths.font("vcr.ttf"), 22, FlxColor.WHITE, CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
		bioTxt.borderSize = 1.5;
		add(bioTxt);

		leftArrow = new FlxSprite(0, 0);
		leftArrow.antialiasing = ClientPrefs.data.antialiasing;
		leftArrow.frames = Paths.getSparrowAtlas('gallery/galleryArrows');
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
        leftArrow.x = 20;
        leftArrow.screenCenter(Y);
		add(leftArrow);

		rightArrow = new FlxSprite(0, 0);
		rightArrow.antialiasing = ClientPrefs.data.antialiasing;
		rightArrow.frames = Paths.getSparrowAtlas('gallery/galleryArrows');
		rightArrow.animation.addByPrefix('idle', "arrow right");
		rightArrow.animation.addByPrefix('press', "arrow push right");
		rightArrow.animation.play('idle');
        rightArrow.x = (FlxG.width - rightArrow.width) - 20;
        rightArrow.screenCenter(Y);
		add(rightArrow);

		upArrow = new FlxSprite(0, 0);
		upArrow.antialiasing = ClientPrefs.data.antialiasing;
		upArrow.frames = Paths.getSparrowAtlas('gallery/galleryArrows');
		upArrow.animation.addByPrefix('idle', "arrow up");
		upArrow.animation.addByPrefix('press', "arrow push up");
		upArrow.animation.play('idle');
		add(upArrow);

		downArrow = new FlxSprite(0, 0);
		downArrow.antialiasing = ClientPrefs.data.antialiasing;
		downArrow.frames = Paths.getSparrowAtlas('gallery/galleryArrows');
		downArrow.animation.addByPrefix('idle', "arrow down");
		downArrow.animation.addByPrefix('press', "arrow push down");
		downArrow.animation.play('idle');
		add(downArrow);

        bottomBG = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		bottomBG.alpha = 0.6;
		add(bottomBG);

		var leText:String = "Press BACK to return to the base Gallery menu.";
		bottomString = leText;
		var size:Int = 16;
		bottomText = new FlxText(bottomBG.x, bottomBG.y + 4, FlxG.width - 4, leText, size);
		bottomText.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, RIGHT);
		bottomText.scrollFactor.set();
		add(bottomText);

		bg.color = 0xFFDB6457;
		intendedColor = bg.color;

        changeItem();
    }

	override function update(elapsed:Float)
    {
		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			close();
			return;
		}

		if (controls.UI_LEFT_P)
		{
			changeItem(-1);
		}

		if (controls.UI_RIGHT_P)
		{
			changeItem(1);
		}

        if (controls.UI_LEFT)
        {
            leftArrow.animation.play('press');
            leftArrow.centerOffsets();
            leftArrow.centerOrigin();
        }
        else
        {
            leftArrow.animation.play('idle');
            leftArrow.centerOffsets();
            leftArrow.centerOrigin();
        }

        if (controls.UI_RIGHT)
        {
            rightArrow.animation.play('press');
            rightArrow.centerOffsets();
            rightArrow.centerOrigin();
        }
        else
        {
            rightArrow.animation.play('idle');
            rightArrow.centerOffsets();
            rightArrow.centerOrigin();
        }

        if(canChangePose)
        {
            if (controls.UI_UP_P)
            {
                changePose(1);
            }

            if (controls.UI_DOWN_P)
            {
                changePose(-1);
            }

            if (controls.UI_UP)
            {
                upArrow.animation.play('press');
                upArrow.centerOffsets();
                upArrow.centerOrigin();
            }
            else
            {
                upArrow.animation.play('idle');
                upArrow.centerOffsets();
                upArrow.centerOrigin();
            }

            if (controls.UI_DOWN)
            {
                downArrow.animation.play('press');
                downArrow.centerOffsets();
                downArrow.centerOrigin();
            }
            else
            {
                downArrow.animation.play('idle');
                downArrow.centerOffsets();
                downArrow.centerOrigin();
            }
        }

        var daXLerp:Float = FlxMath.lerp(intendedCharX, charImg.x, Math.exp(-elapsed * 9));
        var daYLerp:Float = FlxMath.lerp(intendedCharY, charImg.y, Math.exp(-elapsed * 9));

        charImg.x = daXLerp;
        charImg.y = daYLerp;

		super.update(elapsed);
    }

    function changeItem(huh:Int = 0)
    {
		FlxG.sound.play(Paths.sound('scrollMenu'));

        curPoseSelected = 0;
        curSelected += huh;

		if (curSelected >= charData.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = charData.length - 1;

		var newColor:FlxColor = CoolUtil.colorFromString(charData[curSelected].color);
		//trace('The BG color is: $newColor');
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 0.4, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

        if(charData[curSelected].renderCount == 1) canChangePose = false; else canChangePose = true;
        upArrow.visible = canChangePose;
        downArrow.visible = canChangePose;

        reloadChar();
        reloadRest();

        if(huh == 1)
        {
            charImg.x -= 20;
        }
        else if(huh == -1)
        {   
            charImg.x += 20;
        }
    }

    function changePose(huh:Int = 0)
    {
		FlxG.sound.play(Paths.sound('scrollMenu'));

        curPoseSelected += huh;

		if (curPoseSelected >= (charData[curSelected].renderCount + 0))
			curPoseSelected = 0;
		if (curPoseSelected < 0)
			curPoseSelected = (charData[curSelected].renderCount - 1);

        reloadChar();

        if(huh == 1)
        {
            charImg.y += 20;
        }
        else if(huh == -1)
        {
            charImg.y -= 20;
        }
    }

    function reloadChar()
    {
        charImg.loadGraphic(Paths.image('gallery/bios/' + charData[curSelected].name + '-' + curPoseSelected));
        charImg.setGraphicSize(Std.int(charImg.width * 0.8), Std.int(charImg.height * 0.8));
        charImg.updateHitbox();
        charImg.x = 300 - (charImg.width / 2);
        charImg.screenCenter(Y);

        upArrow.x = charImg.x + ((charImg.width / 2) - (upArrow.width / 2));
        upArrow.y = charImg.y - 70;

        downArrow.x = charImg.x + ((charImg.width / 2) - (downArrow.width / 2));
        downArrow.y = (charImg.y + charImg.height) + 20;

        intendedCharX = 300 - (charImg.width / 2);
        intendedCharY = (FlxG.height - charImg.height) / 2;

        if(charImgAlphaTween != null)
			charImgAlphaTween.cancel();

		charImg.alpha = 0;
		charImgAlphaTween = FlxTween.tween(charImg, {alpha: 1}, 0.2, {
			onComplete: function(twn:FlxTween) {
				charImgAlphaTween = null;
			}
		});
    }

    function reloadRest()
    {
        charName.text = charData[curSelected].displayName;
        charName.x = bioBox.x + (bioBox.width / 2) - (charName.width / 2);

        bioTxt.text = charData[curSelected].bio;
        bioTxt.size = charData[curSelected].textSize;
    }
}