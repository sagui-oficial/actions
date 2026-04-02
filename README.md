# Shared GitHub Actions

Monorepo de GitHub Actions compartilhadas, versionadas com [Changesets](https://github.com/changesets/changesets).

## Actions disponíveis

| Action | Descrição |
| --- | --- |
| [notify-teams](./packages/notify-teams/README.md) | Notificação para Microsoft Teams via webhook |

## Como usar em outro repositório

```yaml
uses: sagui-oficial/actions/packages/<action-name>@<action-name>/v1
```

Exemplo concreto:

```yaml
- name: Notify Teams
  uses: sagui-oficial/actions/packages/notify-teams@notify-teams/v1
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    webhook-uri: ${{ secrets.TEAMS_WEBHOOK_URI }}
```

> Para pin exato: `@notify-teams/v1.1.0`
>
> Para repositórios privados, o repo de actions deve estar como **Internal** ou na mesma organização.

## Desenvolvimento

### Pré-requisitos

- Node.js >= 20
- pnpm >= 9

### Setup

```bash
pnpm install
```

### Criando uma nova action

1. Crie uma pasta em `packages/<nome-da-action>/` com:
   - `action.yml` — composite action com inputs padronizados
   - `package.json` — scope `@sagui-actions/`, script `validate`
   - `README.md` — documentação de inputs e uso

2. Registre a changeset:

```bash
pnpm changeset
```

### Scripts

| Script | Descrição |
| --- | --- |
| `pnpm changeset` | Criar changeset |
| `pnpm version-packages` | Aplicar changesets e bumpar versões |
| `pnpm release` | Gerar tags de release |
| `pnpm lint` | Lint de todos os pacotes |
| `pnpm validate` | Lint + validação por pacote |

### Versionamento

- `<action>/v1.0.0` — tag exata
- `<action>/v1` — tag major (aponta para o último `v1.x.x`)

No `uses`, o ref é o nome da tag: `@<action>/v1` (major) ou `@<action>/v1.2.3` (pin exato).
