local forceVocals = false

function onUpdatePost(elapsed)
	if forceVocals and getProperty('vocals.volume') == 0 then
		setProperty('vocals.volume', 1)
	end
end

function onEvent(n,v1,v2)
    if n == "Force Unmute Vocals" then
        if v1 == 'true' then
            forceVocals = true
        elseif v1 == 'false' then
            forceVocals = false
        end
    end
end