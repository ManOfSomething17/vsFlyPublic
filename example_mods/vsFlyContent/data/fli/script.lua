function onCreate()
	if isStoryMode then
		makeLuaSprite('blackTransition', nil, -250, -250);
		setScrollFactor('blackTransition', 0, 0)
		makeGraphic('blackTransition', screenWidth * 3, screenHeight * 3, '000000')
		addLuaSprite('blackTransition', true); --to make cutscene transition smoother or smth
	end
end

function onCreatePost()
    setObjectOrder('dadGroup', getObjectOrder('boyfriendGroup') + 1)

    setProperty('camZooming', true)

	--dark shit
	makeLuaSprite('dark', '', -300, -300)
	makeGraphic('dark', 1920 * 1.5, 1080 * 1.5, '090900')
	setProperty('dark.alpha', 0)
	addLuaSprite('dark', false)
end

function onGameOverStart()
    setProperty('camFollow.x', 750)
    setProperty('camFollow.y', 355)
end

function onCountdownTick(counter)
	-- counter = 0 -> "Three"
	-- counter = 1 -> "Two"
	-- counter = 2 -> "One"
	-- counter = 3 -> "Go!"
	-- counter = 4 -> Nothing happens lol, tho it is triggered at the same time as onSongStart i think

	if counter == 0 then
		runTimer('blackDelay', 0.2)
	end
end

function onTimerCompleted(tag)
	if tag == 'blackDelay' then
		doTweenAlpha('blackTransitionTwn', 'blackTransition', 0, 0.4, 'sineOut');
	end
end

function onTweenCompleted(tag)
	if tag == 'blackTransitionTwn' then
		removeLuaSprite('blackTransition', true);
	end
end

function onEvent(e,v1,v2)
	if e == 'Fli Dark Stuff' then
		if v1 == 'true' then
			cameraFlash('game', 'FFFFFF', 0.2 / playbackRate)
			doTweenAlpha('darkFadeIn', 'dark', 0.95, 0.2 / playbackRate, 'linear')
			doTweenColor('bfDarkIn', 'boyfriend', '3E3E35', 0.2 / playbackRate, 'linear')
			doTweenColor('gfDarkIn', 'gf', '3E3E35', 0.2 / playbackRate, 'linear')
			doTweenColor('dadDarkIn', 'dad', 'FFFCE0', 0.2 / playbackRate, 'linear')
			setProperty('camZoomingMult', 0)
		elseif v1 == 'false' then
			cameraFlash('game', 'FFFFFF', 0.2 / playbackRate)
			setProperty('dark.alpha', 0)
			setProperty('boyfriend.color', getColorFromHex('FFFFFF'))
			setProperty('gf.color', getColorFromHex('FFFFFF'))
			setProperty('dad.color', getColorFromHex('FFFFFF'))
			setProperty('camZoomingMult', 1)
		end
	end
end