import eslint from "@eslint/js";
import ymlPlugin from "eslint-plugin-yml";

export default [
  eslint.configs.recommended,
  ...ymlPlugin.configs["flat/standard"],
  {
    files: ["packages/**/*.yml", "packages/**/*.yaml"],
    rules: {
      "yml/no-empty-mapping-value": "error",
      "yml/require-string-key": "error",
    },
  },
  {
    ignores: ["node_modules", "dist", ".changeset", ".github"],
  },
];
