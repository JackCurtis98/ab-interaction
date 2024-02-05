Interactions = {
    {
        coords = vec4(-1289.421, -800.172, 17.607, 51.268),
        renderDistance = 8.0,
        options = {
            {
                text = "Search",
                onSelect = function()
                    local alert = lib.alertDialog({
                        header = 'Test',
                        content = 'Search!',
                        centered = true,
                        cancel = true
                    })                    
                end
            },
            {
                text = "Hide",
                onSelect = function()

                end
            },
            {
                text = "test",
                onSelect = function()

                end
            },
            {
                text = "test 2",
                onSelect = function()

                end
            }
        }
    }
}