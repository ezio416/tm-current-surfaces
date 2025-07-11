// c 2023-08-16
// m 2025-07-11

const string  pluginColor = "\\$F00";
const string  pluginIcon  = Icons::Road;
Meta::Plugin@ pluginMeta  = Meta::ExecutingPlugin();
const string  pluginTitle = pluginColor + pluginIcon + "\\$G " + pluginMeta.Name;
bool          replay      = false;

void Main() {
    ChangeFont();
}

void OnSettingsChanged() {
    if (currentFont != S_Font) {
        ChangeFont();
    }
}

void Render() {
    if (false
        or !S_Enabled
        or (S_HideWithGame && !UI::IsGameUIVisible())
        or (S_HideWithOP && !UI::IsOverlayShown())
    ) {
        return;
    }

    auto App = cast<CTrackMania>(GetApp());

#if TMNEXT
    auto Playground = cast<CSmArenaClient>(App.CurrentPlayground);
#elif MP4
    auto Playground = App.CurrentPlayground;  // could be CTrackManiaRaceNew@ or CTrackManiaRace1P@
#endif

    if (Playground is null) {
        return;
    }

    if (false
        or Playground.GameTerminals.Length == 0
        or Playground.UIConfigs.Length == 0
        or App.GameScene is null
    ) {
        return;
    }

#if TMNEXT
    ISceneVis@ Scene = App.GameScene;
    CSceneVehicleVis@ Vis;
    CSmPlayer@ Player = cast<CSmPlayer>(Playground.GameTerminals[0].GUIPlayer);
#elif MP4
    CGameScene@ Scene = App.GameScene;
    CSceneVehicleVisState@ Vis;
    CTrackManiaPlayer@ Player = cast<CTrackManiaPlayer>(Playground.GameTerminals[0].GUIPlayer);
#endif

    if (Player !is null) {
        @Vis = VehicleState::GetVis(Scene, Player);
        replay = false;
    } else {
        @Vis = VehicleState::GetSingularVis(Scene);
        replay = true;
    }

    if (Vis is null) {
        return;
    }

    switch (Playground.UIConfigs[0].UISequence) {
        case CGamePlaygroundUIConfig::EUISequence::Playing:
            break;

        case CGamePlaygroundUIConfig::EUISequence::EndRound:
            if (!replay) {
                return;
            }
            break;

        default:
            return;
    }

    RenderSurfaces(Vis.AsyncState);
}

void RenderMenu() {
    if (UI::MenuItem(pluginTitle, "", S_Enabled)) {
        S_Enabled = !S_Enabled;
    }
}
