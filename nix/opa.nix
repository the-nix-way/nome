{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "open-policy-agent";
  version = "1.16.2";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "opa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f9t/BB0ldSUTaApjM75W9nw7jRC8Hp1t/KFRM/ky67s=";
  };

  vendorHash = "sha256-m+Mb2Llny7O9cfn8Js7MEaeYM9zC/CwWBAuliWE7G1E=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X github.com/open-policy-agent/opa/version.Version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd opa \
      --bash <($out/bin/opa completion bash) \
      --fish <($out/bin/opa completion fish) \
      --zsh <($out/bin/opa completion zsh)
  '';

  doCheck = false;
})
