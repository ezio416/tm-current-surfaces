// c 2023-08-16
// m 2024-01-23

bool replay = false;

void Main() {
    ChangeFont();
}

void OnSettingsChanged() {
    if (currentFont != S_Font)
        ChangeFont();
}

void RenderMenu() {
    if (UI::MenuItem("\\$F00" + Icons::Road + "\\$G Current Surfaces", "", S_Enabled))
        S_Enabled = !S_Enabled;
}

void Render() {
    if (
        !S_Enabled ||
        (S_HideWithGame && !UI::IsGameUIVisible()) ||
        (S_HideWithOP && !UI::IsOverlayShown())
    )
        return;

    CTrackMania@ app = cast<CTrackMania@>(GetApp());

#if TMNEXT
    CSmArenaClient@ playground = cast<CSmArenaClient@>(app.CurrentPlayground);
#elif MP4
    CGamePlayground@ playground = cast<CGamePlayground@>(app.CurrentPlayground);
#endif

    if (playground is null)
        return;

    if (
        playground.GameTerminals.Length != 1 ||
        playground.UIConfigs.Length == 0
    )
        return;

#if TMNEXT
    ISceneVis@ scene = app.GameScene;
#elif MP4
    CGameScene@ scene = cast<CGameScene@>(app.GameScene);
#endif

    if (scene is null)
        return;

#if TMNEXT
    CSceneVehicleVis@ vis;
#elif MP4
    CSceneVehicleVisState@ vis;
#endif

    CSmPlayer@ player = cast<CSmPlayer@>(playground.GameTerminals[0].GUIPlayer);
    if (player !is null) {
        @vis = VehicleState::GetVis(scene, player);
        replay = false;
    } else {
        @vis = VehicleState::GetSingularVis(scene);
        replay = true;
    }

    if (vis is null)
        return;

    CGamePlaygroundUIConfig::EUISequence sequence = playground.UIConfigs[0].UISequence;

    if (
        !(sequence == CGamePlaygroundUIConfig::EUISequence::Playing) &&
        !(sequence == CGamePlaygroundUIConfig::EUISequence::EndRound && replay)
    )
        return;

    RenderSurfaces(vis.AsyncState);
}