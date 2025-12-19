local UI = {}
UI.windows = {}
UI.visible = true
UI.latch = false

-- Helper to check if mouse is inside a button
local function mouse_in_rect(mx, my, x, y, w, h)
    return mx >= x and mx <= (x + w) and my >= y and my <= (y + h)
end

function UI:CreateWindow(args)
    local win = {
        x = args.x, y = args.y, w = args.w, h = args.h,
        title = args.Title or "VALEX V3",
        items = {}
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
    
    local mx, my = valex.get_mouse_pos()
    local clicking = valex.is_key_pressed(0x01) -- Left Mouse Button

    for _, win in ipairs(UI.windows) do
        -- Window Frame
        valex.draw_filled_rect(win.x, win.y, win.x + win.w, win.y + win.h, color3.new(0.1, 0.1, 0.1))
        valex.draw_filled_rect(win.x, win.y, win.x + win.w, win.y + 30, color3.new(0.8, 0.4, 0)) -- Header
        valex.draw_text(win.title, win.x + 10, win.y + 5, color3.white())

        for i, item in ipairs(win.items) do
            local bx = win.x + 10
            local by = win.y + 40 + (i-1)*35
            local bw = win.w - 20
            local bh = 30

            -- Check for click
            if mouse_in_rect(mx, my, bx, by, bw, bh) then
                valex.draw_filled_rect(bx, by, bx + bw, by + bh, color3.new(0.2, 0.2, 0.2)) -- Hover
                if clicking and not UI.latch then
                    UI.latch = true
                    item.value = not item.value
                    if item.callback then item.callback(item.value) end
                end
            else
                valex.draw_filled_rect(bx, by, bx + bw, by + bh, color3.new(0.15, 0.15, 0.15))
            end

            -- Toggle Indicator
            local txt = item.text .. (item.value and " [ON]" or " [OFF]")
            local col = item.value and color3.new(0, 1, 0) or color3.new(1, 0, 0)
            valex.draw_text(txt, bx + 10, by + 5, col)
        end
    end

    if not clicking then UI.latch = false end
    
    -- Draw a small crosshair for the mouse so you know where you are clicking
    valex.draw_filled_rect(mx-2, my-2, mx+2, my+2, color3.new(1, 1, 1))
end

function UI:HandleInput()
    if valex.is_key_pressed(0x38) then -- Key 8
        if not UI.key_latch then
            UI.visible = not UI.visible
            UI.key_latch = true
        end
    else
        UI.key_latch = false
    end
end

return UI
