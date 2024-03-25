function onEvent(n,v1,v2)
	if n == 'Change Game Over Music' then	
		setPropertyFromClass('substates.GameOverSubstate', 'loopSoundName', v1) --Character json file for the death animation
		setPropertyFromClass('substates.GameOverSubstate', 'endSoundName', v2) --Sound to play
	end
end