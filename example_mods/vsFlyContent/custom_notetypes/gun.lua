function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'gun' then
			setPropertyFromGroup('unspawnNotes', i, 'rgbShader.r', 0xEFE577)
			setPropertyFromGroup('unspawnNotes', i, 'rgbShader.g', 0xFFFFFF)
			setPropertyFromGroup('unspawnNotes', i, 'rgbShader.b', 0x4C4718)

			setPropertyFromGroup('unspawnNotes', i, 'hitHealth', 0.5)
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', 1)

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false)
			end
		end
	end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'gun' then
		playAnim('boyfriend', 'shoot', true)
		
		setProperty('boyfriend.specialAnim', true)
		cameraShake('camGame', 0.02, 0.1 / playbackRate)
		cameraShake('camHUD', 0.01, 0.1 / playbackRate)

		damageDad()
    end
end

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'gun' then
		if getProperty('health') <= 0 then
			setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'boyfie_DEAD_ammo')
			setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'boyfie_death_ammo')
			setPropertyFromClass('substates.GameOverSubstate', 'loopSoundName', 'nothing')
			setPropertyFromClass('substates.GameOverSubstate', 'endSoundName', 'paper')
		end
	end
end

function damageDad()
	cancelTween('dadBurn') --just in case
	cancelTween('dadIconBurn') 
	cancelTween('dadFade')

	setProperty('dad.color', getColorFromHex('FF0000'))
	doTweenColor('dadBurn', 'dad', 'FFFFFF', 0.4, 'sineOut')

	setProperty('dad.alpha', 0.5)
	doTweenAlpha('dadFade', 'dad', 1, 0.4, 'sineOut')

	setProperty('iconP2.color', getColorFromHex('FF0000'))
	doTweenColor('dadIconBurn', 'iconP2', 'FFFFFF', 0.4, 'sineOut')
end