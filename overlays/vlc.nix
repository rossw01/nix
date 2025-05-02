# VLC Blackscreen fix for AV1 video

self: super: {
  vlc = super.vlc.overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ])
      ++ [ super.makeWrapper ];

    postInstall = (oldAttrs.postInstall or "") + ''
      # don't wrap libvlc, only wrap vlc
      if [ -f "$out/bin/vlc" ]; then
        wrapProgram $out/bin/vlc --set VDPAU_TRACE 1
      fi
    '';
  });
}
