let
  workspaces = map toString (builtins.genList (n: n + 1) 9);
  perWorkspace = f: builtins.listToAttrs (map f workspaces);
in
{
  # Tiling window manager: https://nikitabobko.github.io/AeroSpace/guide
  aerospace = {
    enable = true;

    settings = {
      # Gaps leave room for the JankyBorders outline
      gaps = {
        inner = {
          horizontal = 8;
          vertical = 8;
        };
        outer = {
          bottom = 8;
          left = 8;
          right = 8;
          top = 8;
        };
      };

      # Move the mouse to the focused monitor when focus changes monitors
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

      mode.main.binding = {
        # Focus
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        # Move windows
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        # Resize
        alt-minus = "resize smart -50";
        alt-equal = "resize smart +50";

        # Layout
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";
        alt-f = "fullscreen";
        alt-shift-space = "layout floating tiling";

        # Jump back to the previous workspace
        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        alt-shift-semicolon = "mode service";
      }
      // perWorkspace (n: {
        name = "alt-${n}";
        value = "workspace ${n}";
      })
      // perWorkspace (n: {
        name = "alt-shift-${n}";
        value = "move-node-to-workspace ${n}";
      });

      # Rarely used commands; press esc to leave the mode
      mode.service.binding = {
        esc = [
          "reload-config"
          "mode main"
        ];
        r = [
          "flatten-workspace-tree"
          "mode main"
        ];
        f = [
          "layout floating tiling"
          "mode main"
        ];
        backspace = [
          "close-all-windows-but-current"
          "mode main"
        ];
      };
    };
  };

  # Outline around the focused window: https://github.com/FelixKratz/JankyBorders
  jankyborders = {
    enable = true;
    active_color = "0xffe1e3e4";
    hidpi = true;
    inactive_color = "0x00494d64";
    style = "round";
    width = 5.0;
  };
}
