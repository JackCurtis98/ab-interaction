
# AB-Interaction

Interaction world points using react/lua

Go up to an interaction point, either use scroll wheel or arrow keys to go up and down the list, to select an item press "E" on your keyboard.

## Configuration
In *Interactions.lua*, You can add to the array using this example...
```
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
```

# More coming soon, very early release and i'm learning while implementing :)
