local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
WindUI:AddTheme({
    Name = "My Theme", -- theme name
    
    Accent = Color3.fromHex("#18181b"),
    Background = Color3.fromHex("#101010"), -- Accent
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#a1a1aa"),
})
WindUI:Gradient({                                                      
    ["0"] = { Color = Color3.fromHex("#1f1f23"), Transparency = 0.5 },            
    ["100"]   = { Color = Color3.fromHex("#18181b"), Transparency = 0.5 },      
}, {                                                                            
    Rotation = 0,                                                               
}), 
