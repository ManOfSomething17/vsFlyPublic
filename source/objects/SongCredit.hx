package objects;

class SongCredit extends FlxSpriteGroup
{
    var playbackRate = PlayState.instance.playbackRate;

    var songTitle:Alphabet;
    var composerName:FlxText;

    public function new(title:String = '', artist:String = null)
    {
        super();

        songTitle = new Alphabet(0, 0, title, true);
        songTitle.scaleX = 0.5;
        songTitle.scaleY = 0.5;
        songTitle.antialiasing = ClientPrefs.data.antialiasing;
        songTitle.x = (FlxG.width - songTitle.width) / 2;
        songTitle.y = (FlxG.height - songTitle.height) / 2 - 160;
        songTitle.alpha = 0;
        add(songTitle);

        composerName = new FlxText(0, songTitle.y + 48, 0, (artist != null) ? "by " + artist : "", 20);
        composerName.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        composerName.borderSize = 1.25;
        composerName.x = (FlxG.width - composerName.width) / 2;
        composerName.alpha = 0;
        add(composerName);
    }

    public function init()
    {
        songTitle.y -= 20;
        FlxTween.tween(songTitle, {alpha: 1, y: songTitle.y + 20}, 0.4 / playbackRate, {ease: FlxEase.circOut});

        composerName.y -= 20;
        FlxTween.tween(composerName, {alpha: 1, y: composerName.y + 20}, 0.4 / playbackRate, {ease: FlxEase.circOut, startDelay: 0.6 / playbackRate});

        var leaveTimer = new FlxTimer().start(5 / playbackRate, function(tmr:FlxTimer)
        {
            FlxTween.tween(songTitle, {alpha: 0, y: songTitle.y - 20}, 0.2 / playbackRate, {ease: FlxEase.circOut,
            onComplete: function(tween:FlxTween)
			{
				destroy();
			}});
            FlxTween.tween(composerName, {alpha: 0, y: composerName.y - 20}, 0.2 / playbackRate, {ease: FlxEase.circOut});
        });
    }
}