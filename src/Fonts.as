// c 2023-08-16
// m 2025-07-11

nvg::Font font;
Font currentFont = S_Font;

enum Font {
    DroidSans,
    DroidSansBold,
    DroidSansMono,
    Montserrat,
    MontserratBold,
    Oswald,
    OswaldBold
}

void ChangeFont() {
    int f = -1;

    switch (S_Font) {
        case Font::DroidSans:      f = nvg::LoadFont("DroidSans.ttf");       break;
        case Font::DroidSansBold:  f = nvg::LoadFont("DroidSans-Bold.ttf");  break;
        case Font::DroidSansMono:  f = nvg::LoadFont("DroidSansMono.ttf");   break;
        case Font::Montserrat:     f = nvg::LoadFont("Montserrat.ttf");      break;
        case Font::MontserratBold: f = nvg::LoadFont("Montserrat-Bold.ttf"); break;
        case Font::Oswald:         f = nvg::LoadFont("Oswald.ttf");          break;
        case Font::OswaldBold:     f = nvg::LoadFont("Oswald-Bold.ttf");     break;
        default: break;
    }

    if (f > -1) {
        font = f;
    }

    currentFont = S_Font;
}
