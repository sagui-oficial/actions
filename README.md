# setup-node-pnpm

GitHub Composite Action que configura Node.js (via `.nvmrc`), pnpm e instala dependências.

## Inputs

| Input               | Required | Default            | Description                          |
| ------------------- | -------- | ------------------ | ------------------------------------ |
| `node-version-file` | No       | `.nvmrc`           | Caminho para o arquivo de versão do Node.js |
| `install-args`      | No       | `--frozen-lockfile` | Argumentos adicionais para `pnpm install` |

## Outputs

| Output         | Description                          |
| -------------- | ------------------------------------ |
| `node-version` | Versão do Node.js resolvida (ex: `24.0.0`) |

## Usage

```yaml
- name: Setup Node, pnpm and dependencies
  id: setup_node_pnpm
  uses: sagui-oficial/actions@setup-node-pnpm/v1

- name: Use node version
  run: echo "Node version: ${{ steps.setup_node_pnpm.outputs.node-version }}"
```

### Com argumentos customizados

```yaml
- name: Setup Node, pnpm and dependencies
  uses: sagui-oficial/actions@setup-node-pnpm/v1
  with:
    node-version-file: .node-version
    install-args: --no-frozen-lockfile
```

> Pin exato: `@setup-node-pnpm/v1.0.0`
