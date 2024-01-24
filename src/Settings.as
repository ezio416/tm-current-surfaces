// c 2023-08-16
// m 2024-01-23

[Setting category="General" name="Enabled"]
bool S_Enabled = true;

[Setting category="General" name="Hide with game UI"]
bool S_HideWithGame = true;

[Setting category="General" name="Hide with Openplanet UI"]
bool S_HideWithOP = false;


[Setting category="Style" name="Show material IDs instead of nice names"]
bool S_Raw = false;

[Setting category="Style" name="Background color" color]
vec4 S_BackColor = vec4(0.0f, 0.0f, 0.0f, 0.7f);

[Setting category="Style" name="Font style"]
Font S_Font = Font::DroidSansBold;

[Setting category="Style" name="Font size" min=8 max=72]
int S_FontSize = 28;

[Setting category="Style" name="Font color" color]
vec4 S_TextColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);

[Setting category="Style" name="Inner cross thickness" min=0.0f max=10.0f]
float S_CrossThickness = 3.0f;

[Setting category="Style" name="Inner cross color" color]
vec4 S_CrossColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);

[Setting category="Style" name="Border thickness" min=0 max=10]
float S_BorderThickness = 3.0f;

[Setting category="Style" name="Border color" color]
vec4 S_BorderColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);

[Setting category="Style" name="Corner radius" min=0.0f max=100.0f]
float S_CornerRadius = 15.0f;


[Setting category="Position" name="Move & resize window easily" description="ignores sliders below"]
bool S_MoveResize = false;

[Setting category="Position" name="Position X" min=0.0f max=1.0f]
float S_X = 0.25f;

[Setting category="Position" name="Position Y" min=0.0f max=1.0f]
float S_Y = 0.25f;

[Setting category="Position" name="Width" min=10 max=1920]
int S_Width = 420;

[Setting category="Position" name="Height" min=10 max=1080]
int S_Height = 120;