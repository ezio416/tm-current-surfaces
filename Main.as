/*
c 2023-08-16
m 2023-10-18
*/

bool replay;

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

    CGamePlayground@ playground = cast<CGamePlayground@>(app.CurrentPlayground);

    if (playground is null)
        return;

    if (
        playground.GameTerminals.Length != 1 ||
        playground.UIConfigs.Length == 0
    )
        return;

#if TMNEXT
    ISceneVis@ scene = cast<ISceneVis@>(app.GameScene);
#elif MP4
    CGameScene@ scene = cast<CGameScene@>(app.GameScene);
#endif

    if (scene is null)
        return;

#if TMNEXT
    CSceneVehicleVis@ vis;
    CSmPlayer@ player = cast<CSmPlayer@>(playground.GameTerminals[0].GUIPlayer);
#elif MP4
    CSceneVehicleVisState@ vis;
    CTrackManiaPlayer@ player = cast<CTrackManiaPlayer@>(playground.GameTerminals[0].GUIPlayer);
#endif

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