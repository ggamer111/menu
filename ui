local UI = {}
UI.windows = {}
UI.visible = true -- Global toggle for the whole UI
UI.keys = { up = false, down = false, enter = false, toggle = false }

-- Helper for Drawing
function draw_rounded_rect(x, y, w, h, r, c)
    valex.draw_filled_rect(x + r, y, w - r, h, c)
    valex.draw_filled_circle(x + r, y + r, r, c)
    valex.draw_filled_circle(w - r, y + r, r, c)
    valex.draw_filled_circle(x + r, h - r, r, c)
    valex.draw_filled_circle(w - r, h - r, r, c)
    valex.draw_filled_rect(x, y + r, x + r, h - r, c)
    valex.draw_filled_rect(w - r, y + r, w, h - r, c)
end

function UI:CreateWindow(args)
    local win = {
        x = args.x, y = args.y, w = args.w, h = args.h,
        r = args.Radius or 6,
        c = args.AccentColor or color3.new(1, 0.85, 0),
        bc = args.BackColor or color3.new(0.1, 0.1, 0.1),
        t = args.Title or "Window",
        items = {},
        selected = 1
    }

    function win:CreateToggle(args)
        local tgl = { type = "toggle", text = args.Text or "Toggle", value = args.Value or false, callback = args.Callback }
        table.insert(self.items, tgl)
        return tgl
    end

    function win:CreateButton(args)
        local btn = { type = "button", text = args.Text or "Button", callback = args.Callback }
        table.insert(self.items, btn)
        return btn
    end

    table.insert(UI.windows, win)
    return win
end

function UI:Draw()
    if not UI.visible then return end

    for _, win in ipairs(UI.windows) do
        -- Background & Shadow
        draw_rounded_rect(win.x - 2, win.y - 2, win.x + win.w + 2, win.y + win.h + 2, win.r, color3.new(0,0,0))
        draw_rounded_rect(win.x, win.y, win.x + win.w, win.y + win.h, win.r, win.bc)
        
        -- Header
        valex.draw_filled_rect(win.x, win.y, win.x + win.w, win.y + 30, win.c)
        valex.draw_text(win.t, win.x + (win.w/2), win.y + 7, color3.white())

        local iy = win.y + 40
        for i, item in ipairs(win.items) do
            local is_sel = (i == win.selected)
            local col = is_sel and win.c or color3.new(0.2, 0.2, 0.2)
            
            draw_rounded_rect(win.x + 10, iy, win.x + win.w - 10, iy + 25, 4, col)
            
            local label = item.text
            if item.type == "toggle" then
                label = label .. (item.value and " [ON]" or " [OFF]")
            end
            
            valex.draw_text(label, win.x + (win.w/2), iy + 5, color3.white())
            iy = iy + 30
        end
    end
end

function UI:UpdateNavigation(toggleKey)
    local is_down = valex.is_key_pressed(0x28) -- Down Arrow
    local is_up = valex.is_key_pressed(0x26)   -- Up Arrow
    local is_enter = valex.is_key_pressed(0x0D)-- Enter
    local is_menu = valex.is_key_pressed(toggleKey or 0x38) -- Default "8" key

    -- Menu Toggle Logic
    if is_menu and not UI.keys.toggle then
        UI.visible = not UI.visible
    end
    UI.keys.toggle = is_menu

    if not UI.visible then return end

    for _, win in ipairs(UI.windows) do
        if is_down and not UI.keys.down then win.selected = (win.selected % #win.items) + 1 end
        if is_up and not UI.keys.up then win.selected = (win.selected - 2) % #win.items + 1 end
        
        if is_enter and not UI.keys.enter then
            local item = win.items[win.selected]
            if item.type == "toggle" then
                item.value = not item.value
                if item.callback then item.callback(item.value) end
            elseif item.callback then
                item.callback()
            end
        end
    end

    UI.keys.down, UI.keys.up, UI.keys.enter = is_down, is_up, is_enter
end

return UI
