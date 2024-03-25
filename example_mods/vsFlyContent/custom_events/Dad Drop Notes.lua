function onEvent(n,v1,v2)
    if n == "Dad Drop Notes" then
        if v1 == 'true' then
            cameraShake('camHUD', 0.01, 0.1)
        end

        for i = 0, 3 do
            noteTweenY('kys'..i, i, screenHeight + 40, 1 / playbackRate, 'circOut')
            noteTweenAlpha('die'..i, i, 0, 0.2 / playbackRate, 'circOut')
            noteTweenAngle('keepyourselfsafe'..i, i, getRandomInt(-360, 360), 1 / playbackRate, 'circOut')
        end
    end
end