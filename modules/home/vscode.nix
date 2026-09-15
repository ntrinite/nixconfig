{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dex.vscode;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib) mkIf;
  inherit (lib.types) attrs listOf package;
  vscode_version = (pkgs.forVSCodeVersion cfg.package.version);
in
{
  options.dex.vscode = {
    enable = mkEnableOption "Enable VSCode";
    package = mkOption {
      type = package;
      default = pkgs.vscode;
    };
    extraSettings = mkOption {
      type = attrs;
      default = { };
    };
    extraExtensions = mkOption {
      type = listOf package;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = cfg.package;
      mutableExtensionsDir = true;
      profiles.default = {
        userSettings = {
          "git.autofetch" = "all";
          "git.autofetchPeriod" = 43200;
          "files.trimTrailingWhitespace" = true;
          "files.autoSave" = "afterDelay";
          "editor.bracketPairColorization.enabled" = true;
          "editor.guides.bracketPairs" = true;
          "terminal.integrated.stickyScroll.enabled" = false;
          "files.associations" = {
            "*.py" = "python";
          };
          "files.insertFinalNewline" = true;
          # "security.workspace.trust.untrustedFiles" = "open";
          "diffEditor.ignoreTrimWhitespace" = false;
          "workbench.colorTheme" = "Baby Panda";
          "workbench.editor.pinnedTabsOnSeparateRow" = true;

          "todo-tree.general.tags" = [
            "BUG"
            "HACK"
            "FIXME"
            "TODO"
            "XXX"
            "[ ]"
            "[x]"
            "REVISIT"
          ];

          "better-comments.tags" = [
            {
              "tag" = "!";
              "color" = "#FF2D00";
              "strikethrough" = false;
              "underline" = false;
              "backgroundColor" = "transparent";
              "bold" = false;
              "italic" = false;
            }
            {
              "tag" = "?";
              "color" = "#3498DB";
              "strikethrough" = false;
              "underline" = false;
              "backgroundColor" = "transparent";
              "bold" = false;
              "italic" = false;
            }
            {
              "tag" = "/X";
              "color" = "#474747";
              "strikethrough" = true;
              "underline" = false;
              "backgroundColor" = "transparent";
              "bold" = false;
              "italic" = false;
            }
            {
              "tag" = "todo";
              "color" = "#FF8C00";
              "strikethrough" = false;
              "underline" = false;
              "backgroundColor" = "transparent";
              "bold" = true;
              "italic" = false;
            }
            {
              "tag" = "revisit";
              "color" = "#3FE8E5";
              "strikethrough" = false;
              "underline" = false;
              "backgroundColor" = "transparent";
              "bold" = true;
              "italic" = false;
            }
            {
              "tag" = "NOTE";
              "color" = "#D041E0";
              "strikethrough" = false;
              "underline" = false;
              "backgroundColor" = "transparent";
              "bold" = true;
              "italic" = false;
            }
            {
              "tag" = "*";
              "color" = "#98C379";
              "strikethrough" = false;
              "underline" = false;
              "backgroundColor" = "transparent";
              "bold" = false;
              "italic" = false;
            }
          ];

          "indentRainbow.colors" = [
            "rgba(242,244,245,0.07)"
            "rgba(115,250,115,0.07)"
            "rgba(255,127,255,0.07)"
            "rgba(96,252,252,0.07)"
          ];
          "indentRainbow.ignoreErrorLanguages" = [
            "markdown"
            "haskell"
            "cpp"
          ];

          "C_Cpp.intelliSenseEngine" = "disabled";
          "clangd.path" = "${pkgs.clang-tools}/bin/clangd";

          "cmake.configureOnEdit" = false;
          "cmake.showConfigureWithDebuggerNotification" = false;
          "cmake.configureOnOpen" = false;
          "cmake.automaticReconfigure" = false;

          "workbench.iconTheme" = "material-icon-theme";

          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
          "nix.serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = [ "${pkgs.nixfmt}/bin/nixfmt" ];
              };
            };
          };

          "[markdown]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
            "editor.wordWrap" = "off";
          };

          "[python]" = {
            "editor.defaultFormatter" = "charliermarsh.ruff";
            "editor.formatOnSave" = true;
            "editor.codeActionsOnSave" = {
              "source.organizeImports" = "always";
            };
          };

          "mypy-type-checker.args" = [
            "--disallow-untyped-defs"
            "--explicit-package-bases"
            "--namespace-packages"
          ];

          "mypy-type-checker.severity" = {
            "error" = "Error";
            "note" = "Information";
            "warning" = "Warning";
          };

          "github.copilot.enable" = false;
          "github.copilot.editor.enableAutoCompletions" = false;
          "github.copilot.editor.enableCodeActions" = false;
          "github.copilot.nextEditSuggestions.enabled" = false;
          "github.copilot.renameSuggestions.enabled" = false;
          "chat.commandCenter.enabled" = false;
          "chat.agent.enabled" = false;
          "chat.disableAIFeatures" = true;

          "extensions.ignoreRecommendations" = true;
          "workbench.browser.autoReloadOnFileChange" = true;
        }
        // cfg.extraSettings;
        extensions =
          (with vscode_version.vscode-marketplace; [
            ms-python.python
            ms-python.vscode-pylance
            llvm-vs-code-extensions.vscode-clangd
            mkhl.direnv
            oderwat.indent-rainbow
            jnoortheen.nix-ide
            ms-vscode-remote.remote-ssh
            mhutchie.git-graph
            tamasfe.even-better-toml
            ms-vscode.cmake-tools
            twxs.cmake
            davidanson.vscode-markdownlint
            mechatroner.rainbow-csv
            drblury.protobuf-vsc
            pkief.material-icon-theme
            gruntfuggly.todo-tree
            ms-azuretools.vscode-docker
            gsgualbano.baby-panda
            cschlosser.doxdocgen
            aaron-bond.better-comments
            randomfractalsinc.geo-data-viewer
            rust-lang.rust-analyzer
            bierner.markdown-mermaid
            esbenp.prettier-vscode
            ms-python.mypy-type-checker
            yahyabatulu.vscode-markdown-alert
            bbenoist.qml
          ])
          ++ cfg.extraExtensions;
      };

    };
  };

}
