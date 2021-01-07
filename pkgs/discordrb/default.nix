{ lib, bundlerEnv, bundlerUpdateScript, ruby }:

bundlerEnv {
  pname = "discordrb";
  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "discordrb";

  meta = with lib; {
    description = "Discord API for Ruby";
    homepage = "https://github.com/discordrb/discordrb";
    license = licenses.mit;
    maintainers = [ maintainers.tckmn ];
    platforms = platforms.all;
  };
}
