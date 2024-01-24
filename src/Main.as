// c 2023-08-16
// m 2024-01-23

bool         replay = false;
const string title  = "\\$F00" + Icons::Road + "\\$G Current Surfaces";

void RenderMenu() {
    if (UI::MenuItem(title, "", S_Enabled))
        S_Enabled = !S_Enabled;
}

void Main() {
    ChangeFont();
}

void OnSettingsChanged() {
    if (currentFont != S_Font)
        ChangeFont();
}

void Render() {
    if (
        !S_Enabled ||
        (S_HideWithGame && !UI::IsGameUIVisible()) ||
        (S_HideWithOP && !UI::IsOverlayShown())
    )
        return;

    CTrackMania@ App = cast<CTrackMania@>(GetApp());

#if TMNEXT
    CSmArenaClient@ Playground = cast<CSmArenaClient@>(App.CurrentPlayground);
#elif MP4
    auto Playground = App.CurrentPlayground;  // could be CTrackManiaRaceNew@ or CTrackManiaRace1P@
#endif

    if (Playground is null)
        return;

    if (
        Playground.GameTerminals.Length != 1 ||
        Playground.UIConfigs.Length == 0
    )
        return;

    if (App.GameScene is null)
        return;

#if TMNEXT
    ISceneVis@ Scene = App.GameScene;
    CSceneVehicleVis@ Vis;
    CSmPlayer@ Player = cast<CSmPlayer@>(Playground.GameTerminals[0].GUIPlayer);
#elif MP4
    CGameScene@ Scene = App.GameScene;
    CSceneVehicleVisState@ Vis;
    CTrackManiaPlayer@ Player = cast<CTrackManiaPlayer@>(Playground.GameTerminals[0].GUIPlayer);
#endif

    if (Player !is null) {
        @Vis = VehicleState::GetVis(Scene, Player);
        replay = false;
    } else {
        @Vis = VehicleState::GetSingularVis(Scene);
        replay = true;
    }

    if (Vis is null)
        return;

    CGamePlaygroundUIConfig::EUISequence sequence = playground.UIConfigs[0].UISequence;
    if (
        !(sequence == CGamePlaygroundUIConfig::EUISequence::Playing) &&
        !(sequence == CGamePlaygroundUIConfig::EUISequence::EndRound && replay)
    )
        return;

    RenderSurfaces(Vis.AsyncState);
}