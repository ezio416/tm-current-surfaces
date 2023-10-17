/*
c 2023-08-16
m 2023-10-16
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
    ) return;

    CTrackMania@ app = cast<CTrackMania@>(GetApp());

    CSmArenaClient@ playground = cast<CSmArenaClient@>(app.CurrentPlayground);
    if (playground is null) return;

    if (
        playground.GameTerminals.Length != 1 ||
        playground.UIConfigs.Length == 0
    ) return;

    ISceneVis@ scene = cast<ISceneVis@>(app.GameScene);
    if (scene is null) return;

    CSceneVehicleVis@ vis;
    CSmPlayer@ player = cast<CSmPlayer@>(playground.GameTerminals[0].GUIPlayer);
    if (player !is null) {
        @vis = VehicleState::GetVis(scene, player);
        replay = false;
    } else {
        @vis = VehicleState::GetSingularVis(scene);
        replay = true;
    }
    if (vis is null) return;

    CSmArena@ arena = cast<CSmArena@>(playground.Arena);
    if (arena is null) return;

    if (arena.Players.Length == 0) return;

    CGamePlaygroundUIConfig::EUISequence sequence = playground.UIConfigs[0].UISequence;
    if (
        !(sequence == CGamePlaygroundUIConfig::EUISequence::Playing) &&
        !(sequence == CGamePlaygroundUIConfig::EUISequence::EndRound && replay)
    ) return;

    RenderSurfaces(vis.AsyncState);
}