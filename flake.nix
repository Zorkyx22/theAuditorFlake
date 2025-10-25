{
  description = "A Nix flake for TheAuditor package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
	pkgs = nixpkgs.legacyPackages.${system};
      pypi = pkgs.python313Packages;
    in
      {
	packages.default = pypi.buildPythonPackage rec {
	  pname = "theauditor";
	  version = "v0";

	  src = pkgs.fetchFromGithub {
	    owner = "TheAuditorTool";
	    repo = "Auditor";
	    rev = "9a7d51168abcffcd6a560602bc71837495f7c775";
	    sha256 = "0000000000000000000000000000000000000000000000000000";		
	  };

	  nativeBuildInputs = [	pypi.hatchling ];
	  buildInputs = [ pkgs.tree-sitter ];

	  # Python dependencies from setup.py
	  propagatedBuildInputs = with pypi; [
	    # Core
	    click
	    pyyaml
	    jsonschema
	    ijson
	    json5
	
	    # 'ml' group
	    scikit-learn
	    numpy
	    scipy
	    joblib
	
	    # 'ast' group
	    tree-sitter
	    tree-sitter-language-pack
	    sqlparse
	    dockerfile-parse
	  ];
	
	  # 'dev' and 'linters' groups
	  checkInputs = with pypi; [
	    pytest
	    pytest-cov
	    pytest-xdist
	    ruff
	    mypy
	    black
	    bandit
	    pylint
	  ];
	  # We can skip the test phase for now
	  doCheck = false;
	
	  meta = with pkgs.lib; {
	    description = "Offline, air-gapped CLI for repo indexing, evidence checking, and task running";
	    homepage = "https://github.com/TheAuditorTool/Auditor";
	    license = licenses.agpl30;
	    platforms = platforms.linux;
	  };
	};
    });
}
