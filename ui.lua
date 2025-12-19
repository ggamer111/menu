local UI = {}
UI.windows = {}
UI.visible = true
UI.keys = { up = false, down = false, enter = false, toggle = false }

-- Valex Rounded Rect Simulation
function draw_box(x, y, w, h, c)
    valex.draw_filled_rect(x, y, x + w, y + h, c)
end

function UI:CreateWindow(args)
    local win = {
        x = args.x, y = args.y, w = args.w, h = args.h,
        c = args.AccentColor or color3.new(1, 0.6, 0),
        bc = color3.new(0.1, 0.1, 0.1),
        t = args.Title or "Valex Menu",
        items = {},
        selected = 1
    }

    function win:CreateToggle(args)
        local tgl = { type = "toggle", text = args.Text, value = false, callback = args.Callback }
        table.insert(self.items, tgl)
        return tgl
    end

    table.insert(UI.windows, win)
    return win
end

function UI:Draw()
    if not UI.visible then return end
    for _, win in ipairs(UI.windows) do
        -- Main Background
        draw_box(win.x, win.y, win.w, win.h, win.bc)
        -- Header
        draw_box(win.x, win.y, win.w, 30, win.c)
        valex.draw_text(win.t, win.x + (win.w/2), win.y + 8, color3.white())

        for i, item in ipairs(win.items) do
            local iy = win.y + 40 + (i-1)*35
            local is_sel = (i == win.selected)
            local btn_col = is_sel and win.c or color3.new(0.2, 0.2, 0.2)
            
            draw_box(win.x + 10, iy, win.w - 20, 30, btn_col)
            local status = item.value and "[ON]" or "[OFF]"
            valex.draw_text(item.text .. " " .. status, win.x + (win.w/2), iy + 7, color3.white())
        end
    end
end

function UI:Update()
    -- Key 0x38 is '8'
    local menu_key = valex.is_key_pressed(0x38)
    if menu_key and not UI.keys.toggle then UI.visible = not UI.visible end
    UI.keys.toggle = menu_key

    if not UI.visible then return end

    local down = valex.is_key_pressed(0x28)
    local up = valex.is_key_pressed(0x26)
    local enter = valex.is_key_pressed(0x0D)

    for _, win in ipairs(UI.windows) do
        if down and not UI.keys.down then win.selected = (win.selected % #win.items) + 1 end
        if up and not UI.keys.up then win.selected = (win.selected - 2) % #win.items + 1 end
        if enter and not UI.keys.enter then
            local item = win.items[win.selected]
            item.value = not item.value
            if item.callback then item.callback(item.value) end
        end
    end
    UI.keys.down, UI.keys.up, UI.keys.enter = down, up, enter
end

return UI
