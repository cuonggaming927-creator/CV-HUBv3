local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "Escape Tsunami", -- Tên hiển thị
    Icon = "rbxassetid://10734951102", -- ID icon (tùy chọn)
    Author = "By tiktok:toibitretrau11222", -- Tên tác giả
    Folder = "MyscriptEscapeTsunami" -- Tên thư mục lưu cấu hình
})
local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://10734951102"
})
local Tab = Window:Tab({
    Title = "Escape",
    Icon = "bird", -- optional
    Locked = false,
})
Tab:Select() -- Select Tab
