{ config, pkgs, lib, ... }:

{
  programs.television = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      ui.theme_overrides = {
        # general
        background = "#181818";
        border_fg = "#717171";
        text_fg = "#cccccc";
        dimmed_text_fg = "#717171";
        # input
        input_text_fg = "#cccccc";
        result_count_fg = "#cccccc";
        # results
        result_name_fg = "#cccccc";
        result_line_number_fg = "#e5c07b";
        result_value_fg = "#abb2bf";
        selection_fg = "#ffffff";
        selection_bg = "#16385b";
        match_fg = "#55a8f7";
        # preview
        preview_title_fg = "#61afef";
        # modes
        channel_mode_fg = "#2c323c";
        channel_mode_bg = "#61afef";
        remote_control_mode_fg = "#2c323c";
        remote_control_mode_bg = "#98c379";
      };

      shell_integration = {
        fallback_channel = "files";

        channel_triggers = {
          "alias" = [ "alias" "unalias" ];
          "env" = [ "export" "unset" ];
          "dirs" = [ "cd" "ls" "rmdir" ];
          "files" = [
            "cat"
            "less"
            "head"
            "tail"
            "vim"
            "nano"
            "bat"
            "cp"
            "mv"
            "rm"
            "touch"
            "chmod"
            "chown"
            "ln"
            "tar"
            "zip"
            "unzip"
            "gzip"
            "gunzip"
            "xz"
            "nvim"
          ];
          "git-diff" = [ "git add" "git restore" ];
          "git-branch" = [
            "git checkout"
            "git branch"
            "git merge"
            "git rebase"
            "git pull"
            "git push"
          ];
          "git-log" = [ "git log" "git show" ];
          "docker-images" = [ "docker run" ];
          "git-repos" = [ "nvim" "code" "hx" "git clone" "ghq get" ];
        };

        keybindings = {
          "smart_autocomplete" = "ctrl-t";
          "command_history" = "ctrl-r";
        };
      };
    };

    channels = {
      alias = {
        metadata = {
          name = "alias";
          description = "A channel to select from shell aliases";
        };
        source = {
          command = "alias";
          interactive = true;
          output = "{split:=:0}";
        };
      };

      env = {
        metadata = {
          name = "env";
          description = "A channel to select from environment variables";
        };
        source = {
          command = "printenv";
          output = "{split:=:1..}";
        };
        preview = {
          command = "echo '{split:=:1..}'";
        };
        ui = {
          layout = "portrait";
          preview_panel = { size = 20; header = "{split:=:0}"; };
        };
        keybindings = {
          shortcut = "f3";
        };
      };

      dirs = {
        metadata = {
          name = "dirs";
          description = "A channel to select from directories";
          requirements = [ "fd" ];
        };
        source = {
          command = [ "fd -t d" "fd -t d --hidden" ];
        };
        preview = {
          command = "ls -la --color=always '{}'";
        };
        keybindings = {
          shortcut = "f2";
        };
      };

      files = {
        metadata = {
          name = "files";
          description = "A channel to select files and directories";
          requirements = [ "fd" "bat" ];
        };
        source = {
          command = "fd -t f";
        };
        preview = {
          command = "bat -n --color=always '{}'";
        };
        ui = {
          preview_panel = { size = 70; scrollbar = true; };
        };
        keybindings = {
          shortcut = "f1";
        };
      };

      git-diff = {
        metadata = {
          name = "git-diff";
          description = "A channel to select files from git diff commands";
          requirements = [ "git" ];
        };
        source = {
          command = "git diff --name-only HEAD";
        };
        preview = {
          command = "git diff HEAD --color=always -- '{}'";
        };
      };

      git-branch = {
        metadata = {
          name = "git-branch";
          description = "A channel to select from git branches";
          requirements = [ "git" ];
        };
        source = {
          command = "git --no-pager branch --all --format=\"%(refname:short)\"";
          output = "{split: :0}";
        };
        preview = {
          command = "git show -p --stat --pretty=fuller --color=always '{0}'";
        };
      };

      git-log = {
        metadata = {
          name = "git-log";
          description = "A channel to select from git log entries";
          requirements = [ "git" ];
        };
        source = {
          command = "git log --oneline --date=short --pretty=\"format:%h %s %an %cd\" \"$@\"";
          output = "{split: :0}";
        };
        preview = {
          command = "git show -p --stat --pretty=fuller --color=always '{0}'";
        };
      };

      docker-images = {
        metadata = {
          name = "docker-images";
          description = "A channel to select from Docker images";
          requirements = [ "docker" "jq" ];
        };
        source = {
          command = "docker images --format '{{.Repository}}:{{.Tag}} {{.ID}}'";
          output = "{split: :-1}";
        };
        preview = {
          command = "docker image inspect '{split: :-1}' | jq -C";
        };
      };

      git-repos = {
        metadata = {
          name = "git-repos";
          requirements = [ "fd" "git" ];
          description = ''
            A channel to select from git repositories on your local machine.

            This channel uses `fd` to find directories that contain a `.git` subdirectory, and then allows you to preview the git log of the selected repository.
          '';
        };
        source = {
          command = "fd -g .git -HL -t d -d 10 --prune ~ -E 'Library' -E 'Application Support' --exec dirname '{}'";
          display = "{split:/:-1}";
        };
        preview = {
          command = "cd '{}'; git log -n 200 --pretty=medium --all --graph --color";
        };
      };
    };
  };
}
