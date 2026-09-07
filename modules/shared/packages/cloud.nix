{ pkgs, ... }:

{
  home.packages = with pkgs; [
    awscli2
    k9s
    ktop
    kubectl
    kubernetes-helm
    kustomize
    k3d
    terraform # Infrastructure as code tool
    terraform-ls # Terraform language server
    tflint # Terraform linter
    velero
  ];
}
