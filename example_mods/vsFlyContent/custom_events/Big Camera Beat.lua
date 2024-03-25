beating = 'false'
beatOdd = false

function onEvent(e, v1, v2)
    if e == 'Big Camera Beat' then
        beating = v1
        beatOdd = false

        if v1 == "true" then
            if getProperty('camZooming') == false then
                setProperty('camZooming', true)
            end
        end
    end
end

function onBeatHit()
    if beating == "true" then
        setProperty('camHUD.zoom', 1.035)

        if beatOdd then
            setProperty('camGame.angle', 0.5)
            setProperty('camHUD.angle', 0.75)
        else
            setProperty('camGame.angle', -0.5)
            setProperty('camHUD.angle', -0.75)
        end

        doTweenAngle('camGameTilt', 'camGame', 0, getPropertyFromClass('backend.Conductor', 'crochet') * 0.0005, 'sineOut')
        doTweenAngle('camTilt', 'camHUD', 0, getPropertyFromClass('backend.Conductor', 'crochet') * 0.0005, 'sineOut')

        beatOdd = not beatOdd
    end
end