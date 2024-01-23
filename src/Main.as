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
    CGamePlayground@ Playground = App.CurrentPlayground;
#endif

    if (Playground is null)
        return;

    if (
        Playground.GameTerminals.Length != 1 ||
        Playground.UIConfigs.Length == 0
    )
        return;

#if TMNEXT
    ISceneVis@ Scene = App.GameScene;
#elif MP4
    CGameScene@ Scene = cast<CGameScene@>(App.GameScene);
#endif

    if (Scene is null)
        return;

#if TMNEXT
    CSceneVehicleVis@ Vis;
#elif MP4
    CSceneVehicleVisState@ Vis;
#endif

    CSmPlayer@ Player = cast<CSmPlayer@>(Playground.GameTerminals[0].GUIPlayer);
    if (Player !is null) {
        @Vis = VehicleState::GetVis(Scene, Player);
        replay = false;
    } else {
        @Vis = VehicleState::GetSingularVis(Scene);
        replay = true;
    }

    if (Vis is null)
        return;

    CGamePlaygroundUIConfig::EUISequence sequence = Playground.UIConfigs[0].UISequence;

    if (
        !(sequence == CGamePlaygroundUIConfig::EUISequence::Playing) &&
        !(sequence == CGamePlaygroundUIConfig::EUISequence::EndRound && replay)
    )
        return;

    RenderSurfaces(Vis.AsyncState);
}