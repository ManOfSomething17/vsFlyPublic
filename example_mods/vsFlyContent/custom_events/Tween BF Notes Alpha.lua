function onEvent(n,v1,v2)
    if n == "Tween BF Notes Alpha" then
        for i = 4, 7 do
            noteTweenAlpha('die'..i, i, v1, v2 / playbackRate, 'linear')
        end
    end
end