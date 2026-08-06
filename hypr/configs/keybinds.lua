local main_mod = "SUPER"

hl.bind(main_mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(main_mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + G", hl.dsp.window.pseudo())

hl.bind(main_mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(main_mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))
hl.bind(main_mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(main_mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))

hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(main_mod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
