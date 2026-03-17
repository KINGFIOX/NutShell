{
  description = "NutShell (果壳) RISC-V 处理器开发环境";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import ./nix/overlay.nix) ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "nutshell-dev";

          packages = with pkgs; [
            # ========================
            # 基础构建工具
            # ========================
            gnumake
            git
            zip

            # ========================
            # Scala/Chisel 工具链
            # ========================
            jdk21
            mill_0_11_7
            circt # 包含 firtool，Chisel 7 生成 Verilog 需要
            metals
            scalafmt

            # ========================
            # Verilog 仿真
            # ========================
            verilator
            gcc

          ];

          # 环境变量
          VERILATOR_ROOT = "${pkgs.verilator}/share/verilator";

          shellHook = ''
            export NUTSHELL_HOME="$(pwd)"
            export NOOP_HOME="$(pwd)"

            # Java
            export JAVA_HOME="${pkgs.jdk21}"

            # Chisel/CIRCT: 使用 Nix 提供的 firtool
            export FIRTOOL="${pkgs.circt}/bin/firtool"
            export CHISEL_FIRTOOL_PATH="${pkgs.circt}/bin"

            echo "🚀 NutShell 开发环境已加载!"
            echo "   NUTSHELL_HOME: $NUTSHELL_HOME"
            echo ""
            echo "📦 常用命令:"
            echo "   make              - 生成 Verilog (build/TopMain.v)"
            echo "   make emu          - 构建仿真器并运行"
            echo "   make init         - 初始化 git 子模块 (difftest)"
            echo "   make help         - 查看配置选项"
            echo ""
            echo "📌 可选参数: BOARD=sim|pynq|axu3cg  CORE=inorder|ooo|embedded"
          '';
        };
      }
    );
}
