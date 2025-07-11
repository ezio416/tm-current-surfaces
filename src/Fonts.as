// c 2023-08-16
// m 2025-07-11

nvg::Font font;
Font currentFont = S_Font;

enum Font {
    DroidSans,
    DroidSansBold,
    DroidSansMono
}

void ChangeFont() {
    int f = -1;

    switch (S_Font) {
        case Font::DroidSans:     f = nvg::LoadFont("DroidSans.ttf");      break;
        case Font::DroidSansBold: f = nvg::LoadFont("DroidSans-Bold.ttf"); break;
        case Font::DroidSansMono: f = nvg::LoadFont("DroidSansMono.ttf");  break;
        default: break;
    }

    if (f > -1) {
        font = f;
    }

    currentFont = S_Font;
}
