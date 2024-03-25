function onEvent(n,v1,v2)
	if n == 'Change Game Over Character' then	
		setPropertyFromClass('substates.GameOverSubstate', 'characterName', v1) --Character json file for the death animation
		setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', v2) --Sound to play
	end
end