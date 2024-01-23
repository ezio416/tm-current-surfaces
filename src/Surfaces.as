// c 2023-08-16
// m 2024-01-23

float scale = UI::GetScale();

void RenderSurfaces(CSceneVehicleVisState@ state) {
    if (!S_Enabled)
        return;

    int displayWidth = Draw::GetWidth();
    int displayHeight = Draw::GetHeight();

    int x = int(S_X * displayWidth);
    int y = int(S_Y * displayHeight);
    int w = S_Width;
    int h = S_Height;

    if (S_MoveResize) {
        int flags = UI::WindowFlags::NoCollapse |
                    UI::WindowFlags::NoSavedSettings |
                    UI::WindowFlags::NoScrollbar;

        UI::SetNextWindowPos(int(x / scale), int(y / scale));
        UI::SetNextWindowSize(int(w / scale), int(h / scale));

        UI::Begin(Icons::ArrowsAlt + " Current Surfaces", flags);
            vec2 pos = UI::GetWindowPos();
            vec2 size = UI::GetWindowSize();
        UI::End();

        S_X = pos.x / displayWidth;
        S_Y = pos.y / displayHeight;
        S_Width = int(size.x);
        S_Height = int(size.y);
    }

    float halfWidth = w * 0.5f;

    // background
    nvg::BeginPath();
    nvg::RoundedRect(
        vec2(x, y),
        vec2(w, h),
        S_CornerRadius
    );
    nvg::FillColor(S_BackColor);
    nvg::Fill();

    // inner cross
    nvg::StrokeWidth(S_CrossThickness);
    nvg::StrokeColor(S_CrossColor);
    nvg::BeginPath();
    nvg::Rect(
        vec2(x + halfWidth, y),
        vec2(0.0f, h)
    );
    nvg::Stroke();
    nvg::BeginPath();
    nvg::Rect(
        vec2(x, y + (h * 0.5f)),
        vec2(w, 0.0f)
    );
    nvg::Stroke();

    // border
    nvg::StrokeWidth(S_BorderThickness);
    nvg::StrokeColor(S_BorderColor);
    nvg::BeginPath();
    nvg::RoundedRect(
        vec2(x, y),
        vec2(w, h),
        S_CornerRadius
    );
    nvg::Stroke();

    // text
    nvg::BeginPath();
    nvg::FontFace(font);
    nvg::FontSize(S_FontSize);
    nvg::FillColor(S_TextColor);
    nvg::TextAlign(nvg::Align::Middle | nvg::Align::Center);
    float frontY = y + h * 0.26f;
    nvg::TextBox(
        vec2(x, frontY),
        halfWidth,
        MaterialName(state.FLGroundContactMaterial)
    );
    nvg::TextBox(
        vec2(x + halfWidth, frontY),
        halfWidth,
        MaterialName(state.FRGroundContactMaterial)
    );
    float rearY = y + h * 0.76f;
    nvg::TextBox(
        vec2(x, rearY),
        halfWidth,
        MaterialName(state.RLGroundContactMaterial)
    );
    nvg::TextBox(
        vec2(x + halfWidth, rearY),
        halfWidth,
        MaterialName(state.RRGroundContactMaterial)
    );
}

#if TMNEXT
string MaterialName(EPlugSurfaceMaterialId mat) {
    if (S_Raw)
        return tostring(mat);

    switch (mat) {
        case EPlugSurfaceMaterialId::Concrete:
        case EPlugSurfaceMaterialId::Asphalt:           return "road";
        case EPlugSurfaceMaterialId::Grass:             return "penalty grass";
        case EPlugSurfaceMaterialId::Ice:
        case EPlugSurfaceMaterialId::RoadIce:           return "ice";
        case EPlugSurfaceMaterialId::Metal:             return "metal";
        case EPlugSurfaceMaterialId::Sand:              return "sand";
        case EPlugSurfaceMaterialId::Dirt:              return "dirt";
        case EPlugSurfaceMaterialId::Rubber:            return "road border";
        case EPlugSurfaceMaterialId::Rock:              return "rock";
        case EPlugSurfaceMaterialId::Water:             return "water";  // underwater surfaces don't work
        case EPlugSurfaceMaterialId::Wood:              return "wood";
        case EPlugSurfaceMaterialId::Snow:              return "snow";
        case EPlugSurfaceMaterialId::ResonantMetal:     return "trackwall";
        case EPlugSurfaceMaterialId::MetalTrans:        return "signage";
        case EPlugSurfaceMaterialId::TechMagnetic:
        case EPlugSurfaceMaterialId::TechSuperMagnetic: return "magnet";
        case EPlugSurfaceMaterialId::TechMagneticAccel: return "fast magnet";
        case EPlugSurfaceMaterialId::RoadSynthetic:     return "sausage";
        case EPlugSurfaceMaterialId::Green:             return "grass";
        case EPlugSurfaceMaterialId::Plastic:           return "plastic";
        case EPlugSurfaceMaterialId::XXX_Null:          return "air";
        default:                                        return tostring(mat);
    }
}

#elif MP4
string MaterialName(CAudioSourceSurface::ESurfId mat) {
    if (S_Raw)
        return tostring(mat);

    switch (mat) {
        case CAudioSourceSurface::ESurfId::Concrete:
        case CAudioSourceSurface::ESurfId::Asphalt:       return "road";
        case CAudioSourceSurface::ESurfId::Grass:         return "grass";
        case CAudioSourceSurface::ESurfId::Dirt:
        case CAudioSourceSurface::ESurfId::DirtRoad:      return "dirt";
        case CAudioSourceSurface::ESurfId::Turbo:         return "turbo";
        case CAudioSourceSurface::ESurfId::WetDirtRoad:   return "wet dirt";
        case CAudioSourceSurface::ESurfId::Turbo2:        return "red turbo";
        case CAudioSourceSurface::ESurfId::Bumper:        return "bumper";
        case CAudioSourceSurface::ESurfId::FreeWheeling:  return "free wheel";
        case CAudioSourceSurface::ESurfId::RubberBand:    return "road border";
        case CAudioSourceSurface::ESurfId::NoGrip:        return "no grip";
        case CAudioSourceSurface::ESurfId::Bumper2:       return "red bumper";
        case CAudioSourceSurface::ESurfId::NoSteering:    return "no steering";
        case CAudioSourceSurface::ESurfId::NoBrakes:      return "no brakes";
        default:                                          return tostring(mat);
    }
}
#endif