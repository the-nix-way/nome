extensions = with pkgs.vscode-extensions; [
(extension {
publisher = "ms-azuretools";
name = "vscode-docker";
version = "1.24.0";
sha256 = "sha256-zZ34KQrRPqVbfGdpYACuLMiMj4ZIWSnJIPac1yXD87k=";
})
(extension {
publisher = "octref";
name = "vetur";
version = "0.37.3";
sha256 = "sha256-3hi1LOZto5AYaomB9ihkAt4j/mhkCDJ8Jqa16piwHIQ=";
})
(extension {
publisher = "redhat";
name = "vscode-yaml";
version = "1.12.2";
sha256 = "sha256-EjHQvWiEEfLxM+c/SWAJ2H9ltGEgzMSC84Zyl5u+eqQ=";
})
(extension {
publisher = "rust-lang";
name = "rust-analyzer";
version = "0.4.1470";
sha256 = "sha256-WzOBzPhjjrWKI4gQgL/fRhJzz3qs16IeMyYq+tZL6KE=";
})
(extension {
publisher = "bungcip";
name = "better-toml";
version = "0.3.2";
sha256 = "sha256-g+LfgjAnSuSj/nSmlPdB0t29kqTmegZB5B1cYzP8kCI=";
})
(extension {
publisher = "kubukoz";
name = "nickel-syntax";
version = "0.0.2";
sha256 = "sha256-ffPZd717Y2OF4d9MWE6zKwcsGWS90ZJvhWkqP831tVM=";
})
(extension {
publisher = "B4dM4n";
name = "nixpkgs-fmt";
version = "0.0.1";
sha256 = "sha256-vz2kU36B1xkLci2QwLpl/SBEhfSWltIDJ1r7SorHcr8=";
})
(extension {
publisher = "TheNuProjectContributors";
name = "vscode-nushell-lang";
version = "1.0.0";
sha256 = "sha256-2FHAFh4ipYKegir7o59Ypb78MOzy2iu+3p3aUUgsatw=";
})
(extension {
publisher = "karino2";
name = "oilshell-extension";
version = "1.3.0";
sha256 = "sha256-rUAHB8rdUHh2G+2Fp8F7Pwmie+43PSWr9pLFfpj1cyw=";
})
(extension {
publisher = "tsandall";
name = "opa";
version = "0.12.1";
sha256 = "sha256-HoFX0pNTbL4etkmZVvezmL0vKE54QZtIPjcAp2/llqs=";
})
(extension {
publisher = "benfradet";
name = "vscode-unison";
version = "0.4.0";
sha256 = "sha256-IDM9v+LWckf20xnRTj+ThAFSzVxxDVQaJkwO37UIIhs=";
})
(extension {
publisher = "benfradet";
name = "vscode-unison";
version = "0.4.0";
sha256 = "sha256-IDM9v+LWckf20xnRTj+ThAFSzVxxDVQaJkwO37UIIhs=";
})
(extension {
publisher = "Vue";
name = "volar";
version = "1.3.14";
sha256 = "sha256-fnsVi24nVH915YZ9lx43hS9rwXGP3RwWOVeOd0hZKc4=";
})
(extension {
publisher = "GitHub";
name = "github-vscode-theme";
version = "6.3.2";
sha256 = "sha256-CbFZsoRiiwSWL7zJdnBcfrxuhE7E9Au2AlQjqYXW+Nc=";
})

(extension {
publisher = "unifiedjs";
name = "vscode-mdx";
version = "1.0.3";
sha256 = "sha256-RxMQ7S+at2pKAnyEMSU3C3sDnDBWrRF2BuxCrfE1e+I=";
})
(extension {
publisher = "jq-syntax-highlighting";
name = "jq-syntax-highlighting";
version = "0.0.2";
sha256 = "sha256-Bwq+aZuDmzjHw+ZnIWlL4aGz6UnqxaKm5WUko0yuIWE=";
})
(extension {
publisher = "csstools";
name = "postcss";
version = "1.0.9";
sha256 = "sha256-5pGDKme46uT1/35WkTGL3n8ecc7wUBkHVId9VpT7c2U=";
})
(extension {
publisher = "HashiCorp";
name = "HCL";
version = "0.2.1";
sha256 = "sha256-5dBLDJ7Wgv7p3DY0klqxtgo2/ckAHoMOm8G1mDOlzZc=";
})
(extension {
publisher = "HashiCorp";
name = "terraform";
version = "2.23.0";
sha256 = "sha256-3v2hEf/cEd7NiXfk7eJbmmdyiQJ7bWl9TuaN+y5k+e0=";
})
(extension {
publisher = "Gleam";
name = "gleam";
version = "2.0.0";
sha256 = "sha256-P71WDMYidD1qz4EQpVOer2npRe16glRcOA/I76jkZuM=";
})
(extension {
publisher = "golang";
name = "Go";
version = "0.35.1";
sha256 = "sha256-MHQrFxqSkcpQXiZQoK8e+xVgRjl3Db3n72hrQrT98lg=";
})
(extension {
publisher = "ms-vscode";
name = "makefile-tools";
version = "0.5.0";
sha256 = "sha256-oBYABz6qdV9g7WdHycL1LrEaYG5be3e4hlo4ILhX4KI=";
})
(extension {
publisher = "BazelBuild";
name = "vscode-bazel";
version = "0.5.0";
sha256 = "sha256-JJQSwU3B5C2exENdNsWEcxFSgWHnImYas4t/KLsgTj4=";
})
(extension {
publisher = "bufbuild";
name = "vscode-buf";
version = "0.5.0";
sha256 = "sha256-ePvmHgb6Vdpq1oHcqZcfVT4c/XYZqxJ6FGVuKAbQOCg=";
})
(extension {
publisher = "PKief";
name = "material-icon-theme";
version = "4.25.0";
sha256 = "sha256-/lD3i7ZdF/XOi7RduS3HIYHFXhkoW2+PJW249gQxcyk=";
})
(extension {
publisher = "EditorConfig";
name = "EditorConfig";
version = "0.16.4";
sha256 = "sha256-j+P2oprpH0rzqI0VKt0JbZG19EDE7e7+kAb3MGGCRDk=";
})
(extension {
publisher = "ms-vscode";
name = "vscode-typescript-next";
version = "5.0.202302090";
sha256 = "sha256-LTB3lwu712Rxmi3hDGHP+l1DnQSjuy2fORf1df37d08=";
})
(extension {
publisher = "bradlc";
name = "vscode-tailwindcss";
version = "0.8.6";
sha256 = "sha256-v15KuD3eYFCsrworCJ1SZAMkyZKztAwWKmfwmbirleI=";
})
];
