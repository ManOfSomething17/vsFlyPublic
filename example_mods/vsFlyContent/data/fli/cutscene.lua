local playedVideo = false

function onStartCountdown()
	if isStoryMode and playedVideo == false and not seenCutscene then --Block the first countdown
            playedVideo = true
			startVideo('fly');
		    return Function_Stop;
	end
	return Function_Continue;
end