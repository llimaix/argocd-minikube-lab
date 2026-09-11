# Argo CD + Minikube Lab

Laboratorio local para aprendizaje de Kubernetes, GitOps y Argo CD.

## Stack

- macOS
- Docker
- Minikube
- Kubernetes
- kubectl
- Argo CD
- Kustomize
- Git
- GitHub
- GitHub Actions

## Arquitectura

GitHub será utilizado como fuente de verdad para los manifiestos declarativos.

Argo CD ejecutado dentro de Minikube observará el repositorio y reconciliará
el estado de Kubernetes con el estado definido en Git.

## Directorios

```text
bootstrap/   Bootstrap del cluster y Argo CD
apps/        Aplicaciones administradas por Argo CD
exercises/   Ejercicios del curso
docs/        Documentación
scripts/     Utilidades del laboratorio
