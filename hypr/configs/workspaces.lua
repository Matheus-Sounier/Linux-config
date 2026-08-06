local main_mod = "SUPER"

for i = 1, 7 do
    hl.bind(main_mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(main_mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
