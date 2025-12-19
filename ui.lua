local UI = {}
UI.windows = {}
UI.visible = true
UI.toggle_key_latched = false

-- Helper: Check if mouse is over a box
local function is_hovering(mx, my, x, y, w, h)
    return mx >= x and mx <= (x + w) and my >= y and my <= (y + h)
end

function UI:CreateWindow(args)
    local win = {
        x = args.x, y = args.y, w = args.w, h = args.h,
        title = args.Title or "VALEX PREMIUM",
        accent = args.AccentColor or color3.new(0, 0.5, 1),
        items = {}
    }

    function win:CreateToggle(args)
        local tgl = {
            type = "toggle",
            text = args.Text,
            value = false,
            callback = args.Callback
        }
        table.insert(self.items, tgl)
        return tgl
    end

    table.insert(UI.windows, win)
    return win
end

function UI:Draw()
    if not UI.visible then return end
    
    local mx, my = valex.get_mouse_pos()
    local click = valex.is_key_pressed(0x01) -- Left Click

    for _, win in ipairs(UI.windows) do
        -- Main Window Shadow & Body
        valex.draw_filled_rect(win.x - 2, win.y - 2, win.x + win.w + 2, win.y + win.h + 2, color3.new(0,0,0))
        valex.draw_filled_rect(win.x, win.y, win.x + win.w, win.y + win.h, color3.new(0.12, 0.12, 0.12))
        
        -- Header Bar
        valex.draw_filled_rect(win.x, win.y, win.x + win.w, win.y + 35, win.accent)
        valex.draw_text(win.title, win.x + 10, win.y + 8, color3.white())

        for i, item in ipairs(win.items) do
            local iy = win.y + 45 + (i-1) * 40
            local ix = win.x + 10
            local iw = win.w - 20
            local ih = 32

            -- Hover Effect
            local hovering = is_hovering(mx, my, ix, iy, iw, ih)
            local bg_col = hovering and color3.new(0.2, 0.2, 0.2) or color3.new(0.16, 0.16, 0.16)
            
            -- Draw Button Background
            valex.draw_filled_rect(ix, iy, ix + iw, iy + ih, bg_col)
            valex.draw_text(item.text, ix + 10, iy + 7, color3.white())

            -- Draw Toggle Switch (Visual)
            local sw_x = ix + iw - 45
            local sw_w = 35
            local sw_col = item.value and win.accent or color3.new(0.3, 0.3, 0.3)
            valex.draw_filled_rect(sw_x, iy + 6, sw_x + sw_w, iy + 26, sw_col)
            
            -- Indicator dot
            local dot_x = item.value and (sw_x + 20) or (sw_x + 5)
            valex.draw_filled_rect(dot_x, iy + 8, dot_x + 10, iy + 24, color3.white())

            -- Click Logic
            if hovering and click and not item.latched then
                item.value = not item.value
                item.latched = true
                if item.callback then item.callback(item.value) end
            elseif not click then
                item.latched = false
            end
        end
    end
end

function UI:HandleToggle()
    local key8 = valex.is_key_pressed(0x38) -- Key "8"
    if key8 and not UI.toggle_key_latched then
        UI.visible = not UI.visible
    end
    UI.toggle_key_latched = key8
end

return UI
