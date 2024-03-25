function onEvent(n,v1,v2)
    if n == "Tween Dad Notes Alpha" then
        for i = 0, 3 do
            noteTweenAlpha('die'..i, i, v1, v2 / playbackRate, 'linear')
        end
    end
end