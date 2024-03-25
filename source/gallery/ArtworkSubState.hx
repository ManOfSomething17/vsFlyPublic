package gallery;

import flixel.util.FlxSpriteUtil;

class ArtworkSubState extends MusicBeatSubstate
{
    var bg:FlxSprite;

    var artworkData:Array<String> = CoolUtil.coolTextFile(Paths.txt('galleryArtData'));
    var imageData:Array<String> = [];
    var textData:Array<String> = [];
    var linkData:Array<String> = [];

    var artImg:FlxSprite;
    var artTxtBack:FlxSprite;
    var artTxt:FlxText;
	var curSelected:Int = 0;

    var artImgAlphaTween:FlxTween;
    var intendedImgX:Float;

    var leftArrow:FlxSprite;
    var rightArrow:FlxSprite;

	var bottomString:String;
	var bottomText:FlxText;
	var bottomBG:FlxSprite;

    public function new()
    {
	    super();

        for (i in 0...artworkData.length)
        {
            var daData:Array<String> = artworkData[i].split('::');

            imageData.push(daData[0]);
            textData.push(daData[1]);
            linkData.push(daData[2]);
        }

        bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFDB6457;
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

        artImg = new FlxSprite(0, 0).loadGraphic(Paths.image('gallery/artwork/Kyano'));
        artImg.antialiasing = ClientPrefs.data.antialiasing;
        add(artImg);

		leftArrow = new FlxSprite(0, 0);
		leftArrow.antialiasing = ClientPrefs.data.antialiasing;
		leftArrow.frames = Paths.getSparrowAtlas('gallery/galleryArrows');
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
        leftArrow.screenCenter(Y);
		add(leftArrow);

		rightArrow = new FlxSprite(0, 0);
		rightArrow.antialiasing = ClientPrefs.data.antialiasing;
		rightArrow.frames = Paths.getSparrowAtlas('gallery/galleryArrows');
		rightArrow.animation.addByPrefix('idle', "arrow right");
		rightArrow.animation.addByPrefix('press', "arrow push right");
		rightArrow.animation.play('idle');
        rightArrow.screenCenter(Y);
		add(rightArrow);

        artTxtBack = new FlxSprite(-6, 0).makeGraphic(FlxG.width + 12, 42, FlxColor.BLACK);
        artTxtBack.alpha = 0.5;
        add(artTxtBack);

        FlxSpriteUtil.drawRect(artTxtBack, 0, 0, artTxtBack.width, artTxtBack.height, FlxColor.BLACK, {thickness: 10, color: FlxColor.WHITE});
		artTxtBack.antialiasing = ClientPrefs.data.antialiasing;

		artTxt = new FlxText(0, 0, 0, "", 24);
		artTxt.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
		artTxt.borderSize = 1.5;
		add(artTxt);

        bottomBG = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		bottomBG.alpha = 0.6;
		add(bottomBG);

		var leText:String = "Press BACK to return to the base Gallery menu / Press ACCEPT to visit the artist's page.";
		bottomString = leText;
		var size:Int = 16;
		bottomText = new FlxText(bottomBG.x, bottomBG.y + 4, FlxG.width - 4, leText, size);
		bottomText.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, RIGHT);
		bottomText.scrollFactor.set();
		add(bottomText);

        FlxTween.color(bg, 0.4, bg.color, 0xFF9F96FF);

        changeItem();
        reloadStuff();
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

        if(controls.ACCEPT && linkData[curSelected] != null)
        {
            CoolUtil.browserLoad(linkData[curSelected]);
        }
        else if(controls.ACCEPT && linkData[curSelected] == null)
        {
            trace("the artist for this has no link, oof");
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

        var daXLerp:Float = FlxMath.lerp(intendedImgX, artImg.x, Math.exp(-elapsed * 9));

        artImg.x = daXLerp;

		super.update(elapsed);
    }

    function changeItem(huh:Int = 0)
    {
		FlxG.sound.play(Paths.sound('scrollMenu'));

        curSelected += huh;

		if (curSelected >= artworkData.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = artworkData.length - 1;

        reloadStuff();

        if(huh == 1)
        {
            artImg.x -= 20;
        }
        else if(huh == -1)
        {
            artImg.x += 20;
        }
    }

    function reloadStuff()
    {
        artImg.loadGraphic(Paths.image('gallery/artwork/' + imageData[curSelected]));
        artImg.setGraphicSize(Std.int(artImg.width * 0.7), Std.int(artImg.height * 0.7));
        artImg.updateHitbox();
        artImg.screenCenter();

        leftArrow.x = (artImg.x - leftArrow.width) - 20;
        rightArrow.x = (artImg.x + artImg.width) + 20;

        intendedImgX = (FlxG.width - artImg.width) / 2;

        if(artImgAlphaTween != null)
			artImgAlphaTween.cancel();

		artImg.alpha = 0;
		artImgAlphaTween = FlxTween.tween(artImg, {alpha: 1}, 0.2, {
			onComplete: function(twn:FlxTween) {
				artImgAlphaTween = null;
			}
		});

        artTxt.text = textData[curSelected];
        artTxt.screenCenter(X);
        artTxt.y = artImg.y + artImg.height + 20;

        artTxtBack.y = artTxt.y - 8;
    }
}