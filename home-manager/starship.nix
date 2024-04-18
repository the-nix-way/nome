{ pkgs }:

{
  enable = true;
  enableNushellIntegration = true;
  enableZshIntegration = true;
  package = pkgs.starship;
  settings = {
    add_newline = false;
    battery = {
      full_symbol = "🔋 ";
      charging_symbol = "⚡️ ";
      discharging_symbol = "💀 ";
    };
    erlang = { format = "via [e $version](bold red) "; };
    git_branch = { symbol = "🌱 "; };
    git_commit = {
      commit_hash_length = 4;
      tag_symbol = "🔖 ";
    };
    git_state = {
      format = "[($state($progress_current of $progress_total))]($style) ";
      cherry_pick = "[🍒 PICKING](bold red)";
    };
    git_status = {
      conflicted = "🏳";
      ahead = "🏎💨";
      behind = "😰";
      diverged = "😵";
      untracked = "🤷‍";
      stashed = "📦";
      modified = "📝";
      staged = "[++($count)](green)";
      renamed = "👅";
      deleted = "🗑";
    };
    hostname = {
      ssh_only = false;
      format = "on [work-box](bold red) ";
      disabled = false;
    };
    nix_shell = {
      disabled = false;
      impure_msg = "[impure shell](bold red)";
      pure_msg = "[pure shell](bold green)";
      format = "via [☃️ $state( ($name))](bold blue) ";
    };
    "$schema" = "https://starship.rs/config-schema.json";
    terraform = { format = "[🏎💨 $version$workspace]($style) "; };
    username = {
      style_user = "white bold";
      style_root = "black bold";
      format = "[$user]($style) ";
      disabled = false;
      show_always = true;
    };
  };
}
