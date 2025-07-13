// c 2023-08-16
// m 2025-07-13

const string  pluginColor = "\\$F00";
const string  pluginIcon  = Icons::Road;
Meta::Plugin@ pluginMeta  = Meta::ExecutingPlugin();
const string  pluginTitle = pluginColor + pluginIcon + "\\$G " + pluginMeta.Name;

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
    auto Playground = EzGame::Playground;

    if (false
        or Playground is null
        or Playground.GameTerminals.Length == 0
        or App.GameScene is null
    ) {
        return;
    }

#if TMNEXT
    CSceneVehicleVis@ Vis;
#elif MP4 || TURBO
    CSceneVehicleVisState@ Vis;
#endif

#if TMNEXT || MP4
    auto Player = cast<CSmPlayer>(Playground.GameTerminals[0].GUIPlayer);

    if (Player !is null) {
        @Vis = VehicleState::GetVis(App.GameScene, Player);
    } else {
        @Vis = VehicleState::GetSingularVis(App.GameScene);
    }
#elif TURBO
    @Vis = VehicleState::ViewingPlayerState();
#endif

    if (Vis is null) {
        return;
    }

    switch (EzState::sequence) {
        case CGamePlaygroundUIConfig::EUISequence::Playing:
            break;

        case CGamePlaygroundUIConfig::EUISequence::EndRound:
            if (!EzState::viewingReplay) {
                return;
            }
            break;

        default:
            return;
    }

#if TMNEXT || MP4
    RenderSurfaces(Vis.AsyncState);
#elif TURBO
    RenderSurfaces(Vis);
#endif
}

void RenderMenu() {
    if (UI::MenuItem(pluginTitle, "", S_Enabled)) {
        S_Enabled = !S_Enabled;
    }
}
