{ stdenvNoCC
, lib
, fetchFromGitHub
, fetchpatch

, libffi
, pkg-config
, zeromq
}:

let
  inherit (lib) licenses;
in
rec {
  # Thin wrapper over stdenvNoCC.mkDerivation.
  mkGem = attrs: stdenvNoCC.mkDerivation ({
    # "Static" name. Just like source packages.
    name = if attrs.src ? name then attrs.src.name else "source";

    # Skip these, as they may be accidentally triggered.
    configurePhase = ":";
    buildPhase = ":";

    installPhase = ''
      echo " :: Copying mrbgem"
      cp -vr . $out
    '';
  } // attrs);

  mruby-dir = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-dir";
      owner = "iij";
      rev = "89dceefa1250fb1ae868d4cb52498e9e24293cd1";
      sha256 = "0zrhiy9wmwmc9ls62iyb2z86j2ijqfn7rn4xfmrbrfxygczarsm9";
    };

    meta.license = licenses.mit;
  };

  mruby-dir-glob = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-dir-glob";
      owner = "gromnitsky";
      rev = "334c040a2e2c4c2689f8c3440168011f64d57ada";
      sha256 = "1ji826s9mbwk6rmn5fccxp53hfgnq6ayaphv6ccznr0k6pim8cv5";
    };

    postPatch = ''
      # Disable all tests, they're not kind with gems :/
      rm -vrf test test.local
    '';

    patches = [
      ./mruby-dir-glob/0001-HACK-Removes-test-only-dependencies.patch
    ];

    requiredGems = [
      mruby-dir
      mruby-errno
      mruby-file-stat
      mruby-regexp-pcre
    ];

    meta.license = licenses.mit;
  };

  mruby-env = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-env";
      owner = "iij";
      rev = "056ae324451ef16a50c7887e117f0ea30921b71b";
      sha256 = "19fpp6lv8asjxhf0zraj15ds5fiskjz7zzcg0k64m5q0kzwra62w";
    };

    meta.license = licenses.mit;
  };

  mruby-erb = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-erb";
      owner = "jbreeden";
      rev = "7ea27f1338fe5e971d818034d0163ca46ecd7d33";
      sha256 = "1ainldbh51wpsf8q62fgv1cg42sh5ykznr0dy0cchkab3rzkipf1";
    };

    requiredGems = [
      mruby-regexp-pcre
    ];

    meta.license = licenses.ruby;
  };

  mruby-errno = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-errno";
      owner = "iij";
      rev = "b4415207ff6ea62360619c89a1cff83259dc4db0";
      sha256 = "12djcwjjw0fygai5kssxbfs3pzh3cpnq07h9m2h5b51jziw380xj";
    };

    meta.license = licenses.mit;
  };

  mruby-fiddle = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-fiddle";
      owner = "mobile-nixos";
      rev = "f4ee03fcf9022d21e68de6d3b6e58e14b9c6cf43";
      sha256 = "1w2mzmdgkk9qvn0cz0i09xs14mjcvryjxicl2n09l2bjk0plqdm4";
    };

    gemBuildInputs = [
      libffi
    ];

    meta.license = licenses.mit;
  };

  mruby-file-stat = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-file-stat";
      owner = "ksss";
      rev = "f3e858f01361b9b4a8e77ada52470068630c9530";
      sha256 = "11lba0gyqmqj3rj0sh3ml3cj2yzz30w4wpbjazb0yhhjfl279ffj";
    };

    patches = [
      ./mruby-file-stat/0001-HACK-Rely-on-nixos-isms-for-.-configure.patch
    ];

    postPatch = ''
      # Uh... they are testing that they are not implementing something.
      # Though it may be implemented anywya!
      rm -vf test/io.rb

      substituteInPlace test/file-stat.rb \
        --replace 'dir = __FILE__[0..-18] # 18 = /test/file-stat.rb' \
        'skip "Fails in Nix sandbox"'
    '';

    meta.license = licenses.mit;
  };

  mruby-inotify = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-inotify";
      owner = "projectivetech";
      rev = "cd00265532384f5eb71bb343eaad1a11d5041db3";
      sha256 = "1h9cmam6grz32ry0gi17nimv4m7crn8jggmicgd0cz1g7kscsw5a";
    };

    meta.license = licenses.mit; # See mrbgem.rake
  };

  mruby-json = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-json";
      owner = "mattn";
      rev = "054699892b0d681110e7348440cddb70a3fd671e";
      sha256 = "0pmlsjb5j2zdm1a1j1lah1nj3wn7bmy22z6nwqq5ydhj36rranf1";
    };

    meta.license = licenses.mit;
  };

  mruby-logger = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-logger";
      owner = "katzer";
      rev = "5e703e5c2f11e92867a7d56292f1f0c7b4f42f69";
      sha256 = "0ip3mxpzyf9rswkh3wjc9nnml4gw1gzr50krbqhaz2mj10xdqfxw";
    };

    patches = [
      ./mruby-logger/0001-Skip-logger-test-with-read-only-source-directory.patch
    ];

    meta.license = licenses.mit;
  };

  mruby-open3 = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-open3";
      owner = "mrbgems";
      rev = "d6ab1bcd13446661c2e134ad8343caba9d15e59a";
      sha256 = "1kx4ibzm1s6m1q5nrpx10s4l3qbgbsca0kxx5vgm3i2frz5rxrm7";
    };

    requiredGems = [
      mruby-process
    ];

    meta.license = licenses.mit;
  };

  mruby-os = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-os";
      owner = "appPlant";
      rev = "670eeb019e0abb657f5b9dbfd0ee993133edaa99";
      sha256 = "1whqhikiq8dkv9nsilsibcy5qw0xydxh6ysz6mjkp7vh0hpirlzs";
    };

    patches = [
      (fetchpatch {
        url = "https://github.com/appPlant/mruby-os/pull/1.patch";
        sha256 = "06mnj2w2dj9l1l3fd09w1zkrdnxdgll8rjkd5hn3mz4vhc4qrx19";
      })
    ];

    meta.license = licenses.mit;
  };

  mruby-pack = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-pack";
      owner = "iij";
      rev = "383a9c79e191d524a9a2b4107cc5043ecbf6190b";
      sha256 = "003glxgxifk4ixl12sy4gn9bhwvgb79b4wga549ic79isgv81w2d";
    };

    meta.license = licenses.asl20;
  };

  mruby-proc-irep-ext = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-proc-irep-ext";
      owner = "Asmod4n";
      rev = "66ec9ed10982ff03e998b51a8652c9bb2b75ec44";
      sha256 = "0jlsla7gkhkhf1x4gjwixyl1la3cjlqhpf0yrysfjpd17mr3wxjz";
    };

    meta.license = licenses.asl20;
  };

  mruby-process = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-process";
      owner = "appPlant";
      rev = "d33886359dd2622994c4452997c2011b13463a6e";
      sha256 = "1q47v1mavdi12x3jrv5l58ax3kx83byxpn7nwbb4wxb4r4q23i0l";
    };

    patches =  [
      ./mruby-process/0001-dln-Fix-bad-environment-assumptions.patch
    ];

    postPatch = ''
      # Fixup a bad assumption about ability to write to (mruby) source tree
      substituteInPlace mrbgem.rake \
        --replace "File.join(dir, 'tmp')" '"/tmp/mruby-process"'

      # Fixup bad assumptions about interpreters in the test files
      substituteInPlace test/process.rb \
        --replace "/bin/bash" "$(type -P bash)"
    '';

    requiredGems = [
      mruby-env
      mruby-os
    ];

    meta.license = licenses.mit;
  };

  mruby-process-clock_gettime = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-process-clock_gettime";
      owner = "mobile-nixos";
      rev = "23d7f64178876d1074d7ff5b4b1d2adb8a277d6c";
      sha256 = "052q3963lblw6465i1bjbfna88cyk8v1mmznqi4x5a6wddpiwwbj";
    };

    meta.license = licenses.mit;
  };

  mruby-regexp-pcre = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-regexp-pcre";
      owner = "iij";
      rev = "a961225c0953dd2bd987111f0836821573616de2";
      sha256 = "1d6frx8xxjkjly11pl6y7shncvnrsbw4fhdpcxzayilvg8v4csi7";
    };

    patches = [
      (fetchpatch {
        url = "https://github.com/iij/mruby-regexp-pcre/commit/d07d8b4689554da825d3b30725a3ecb272079de0.patch";
        sha256 = "0n0bf3x4j98nps3yvdngpkbkjfhijz1q9yxdfnp0jmr3nws6asb4";
      })
    ];

    meta.license = licenses.mit;
  };

  mruby-require = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-require";
      owner = "mattn";
      rev = "b2b95a27b8658c46c5cb05abd168e77a12aef2a4";
      sha256 = "09074m8c6szafs89xb8a1nhvc44jcj3hl8xcwgajzmkif39p72if";
    };

    patches = [
      ./mruby-require/0001-HACK-Skip-turning-gems-to-library-for-tests-output.patch
      ./mruby-require/0001-HACK-Prefer-first-target-if-host-is-not-present.patch
      ./mruby-require/0001-Skip-realpath-on-absolute-paths.patch
    ];

    meta.license = licenses.mit;
  };

  mruby-secure-random = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-secure-random";
      owner = "monochromegane";
      rev = "4971702e8cd299054b3220b4adb6bc3031ae2881";
      sha256 = "sha256-fnMuTgGHM0CNado/ZzMFLfZ+Ah6ug5A0nQ2Kf9inPto=";
    };

    meta.license = licenses.mit;
  };

  mruby-sha1 = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-sha1";
      owner = "mattn";
      rev = "528419eefb415203b989650f7b792b3556e3d475";
      sha256 = "05y1l7pprwrnizbbhsgcss0863y4z5fqnz31qsngr344c50v79sh";
    };

    meta.license = licenses.gpl;
  };

  mruby-simplemsgpack = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-simplemsgpack";
      owner = "Asmod4n";
      rev = "2d908b1c9cdfb5f12319866ef483179be22660ad";
      sha256 = "0kssfzd53k4svl1mj63b4jgd3pfffz277iki91kdfkxxjmwas7z7";
      fetchSubmodules = true;
    };

    meta.license = licenses.asl20;
  };

  mruby-singleton = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-singleton";
      owner = "ksss";
      rev = "73dd4bae1a47d82e49b8f85bf27f49ec4462052e";
      sha256 = "0yyf9vfsm46m2fi46f8w6ympkwzlaqnbpjkfnkzyapf94rg23g6i";
    };

    meta.license = licenses.mit;
  };

  mruby-tempfile = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-tempfile";
      owner = "iij";
      rev = "b8e4fb65ecce9f0cc3584480d93b53a60cc6dd36";
      sha256 = "05g3yq8l0m0r0ipa4wxcv9d45iyzwgbcw6qdklrfcgg7r1q2bivz";
    };

    requiredGems = [
      mruby-dir
      mruby-env
      mruby-errno
    ];

    meta.license = licenses.mit;
  };

  mruby-time-strftime = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-time-strftime";
      owner = "monochromegane";
      rev = "ea8a77504f43fe9f985529b987f3d88bf2a2291a";
      sha256 = "1yh6sd7m4kqljp30yp6sy3zj6669bvzcans7vvla2rrzm0vdghlk";
    };

    meta.license = licenses.mit;
  };

  mruby-zmq = mkGem {
    src = fetchFromGitHub {
      repo = "mruby-zmq";
      owner = "zeromq";
      rev = "ed45cef4d6f813978a0c3cc60b5f62208af7cf71";
      sha256 = "0vx0akd4kmb1iwvxd5dn8q65f6f3paw2rswxy8h23lgf6yxyks3h";
    };

    patches = [
      ./mruby-zmq/0001-Work-around-missing-pthread.patch
      ./mruby-zmq/0001-HACK-cross-build-is-not-special-with-Nixpkgs.patch
    ];

    gemBuildInputs = [
      (zeromq.override {
        enableDrafts = true;
      })
    ];

    gemNativeBuildInputs = [
      pkg-config
    ];

    requiredGems = [
      mruby-errno
      mruby-proc-irep-ext
      mruby-simplemsgpack
      mruby-pack
      mruby-env
    ];

    meta.license = licenses.mpl20;
  };
}
