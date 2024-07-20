{ lib, fetchFromGitHub, buildGoModule, installShellFiles, testers, juju }:

buildGoModule rec {
  pname = "juju";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "juju";
    repo = "juju";
    rev = "v${version}";
    hash = "sha256-HdV6bRAMQ7LynEGjrFOX36g7+1Zb9AiFtF6O4yu7+NU=";
  };

  vendorHash = "sha256-FCN+0Wx2fYQcj5CRgPubAWbGGyVQcSSfu/Om6SUB6TQ=";

  subPackages = [
    "cmd/juju"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # Disable tests because it attempts to use a mongodb instance
  doCheck = false;

  postInstall = ''
    for file in etc/bash_completion.d/*; do
      installShellCompletion --bash "$file"
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = juju;
    command = "HOME=\"$(mktemp -d)\" juju --version";
  };

  meta = with lib; {
    description = "Open source modelling tool for operating software in the cloud";
    homepage = "https://juju.is";
    license = licenses.mit;
    maintainers = with maintainers; [ citadelcore ];
    mainProgram = "juju";
  };
}
