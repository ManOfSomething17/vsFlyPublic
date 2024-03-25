function onCreate()
	addCharacterToList('boyfie_DEAD', 'boyfriend')
	addCharacterToList('boyfie_DEAD2', 'boyfriend')
	addCharacterToList('boyfie_DEAD_ammo', 'boyfriend')

	if isStoryMode and not seenCutscene then
		makeLuaSprite('blackTransition', nil, -250, -250);
		setScrollFactor('blackTransition', 0, 0)
		makeGraphic('blackTransition', screenWidth * 3, screenHeight * 3, '000000')
		addLuaSprite('blackTransition', true); --to make cutscene transition smoother or smth
	end

	makeAnimatedLuaSprite('iconP2Fake', nil, 50, 50)
	loadGraphic('iconP2Fake', 'icons/icon-'..getProperty('dad.healthIcon'), 150)
	addAnimation('iconP2Fake', 'icons/icon-'..getProperty('dad.healthIcon'), {0, 1}, 0)
	setProperty('iconP2Fake.animation.curAnim.curFrame', 1)
	setObjectCamera('iconP2Fake', 'hud')
	setObjectOrder('iconP2Fake', getObjectOrder('iconP2'))
	setProperty('iconP2Fake.visible', false)
	addLuaSprite('iconP2Fake', true)
end

function onCreatePost()
    	--dark shit
	makeLuaSprite('dark', '', -700, -300)
	makeGraphic('dark', 1920 * 1.5, 1080 * 1.5, '000000')
	setProperty('dark.alpha', 0)
    setObjectOrder('dark', getObjectOrder('gfGroup') + 1)
	addLuaSprite('dark', false)

	setPropertyFromClass('substates.PauseSubState', 'deathLabel', 'Gone to Hell')
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

function opponentNoteHit(id, direction, noteType, isSustainNote)
    --basic ass health drain
    if not isSustainNote and getProperty('health') > 0.4 then
        setProperty('health', getProperty('health') - (0.04 * healthLossMult))
    end
end

function onGameOverStart()
    setProperty('camFollow.x', 750)
    setProperty('camFollow.y', 355)
end

function onStepHit()
    if curStep == 1408 then
        doTweenAlpha('darkFadeIn', 'dark', 0.7, 0.2 / playbackRate, 'linear')
    elseif curStep == 1664 then
        if flashingLights then
            cameraFlash('game', 'FFFFFF', 0.2 / playbackRate)
            setProperty('dark.alpha', 0)
        else
            doTweenAlpha('darkFadeOut', 'dark', 0, 0.2 / playbackRate, 'linear')
        end
	elseif curStep == 1952 then
		setProperty('health', 2)
		dadIconDeathAnim(1)

		setProperty('camGame.visible', false)
		cameraShake('camHUD', 0.03, 0.3 / playbackRate)
    end
end

function dadIconDeathAnim(intensity) --holy shit this function :skull:
	setProperty('iconP2Fake.visible', true)
	setProperty('iconP2.visible', false)
	setProperty('iconP2Fake.x', getProperty('healthBar.x') - getProperty('iconP2Fake.width') + 26)
	setProperty('iconP2Fake.y', getProperty('iconP2.y'))
	setProperty('iconP2Fake.acceleration.y', 1250 * intensity)
	setProperty('iconP2Fake.acceleration.x', -1500 * intensity)
	setProperty('iconP2Fake.velocity.y', -350 * intensity)
	setProperty('iconP2Fake.velocity.x', -450 * intensity)
	setProperty('iconP2Fake.angularVelocity', -4000 * intensity)
	setProperty('iconP2Fake.color', getColorFromHex('FF0000'))
	doTweenColor('dadFakeIconBurn', 'iconP2Fake', 'FFFFFF', 0.4, 'sineOut')
end