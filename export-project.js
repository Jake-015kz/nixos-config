import fs from "fs";
import path from "path";

const IGNORED_DIRS = ["node_modules", ".git", "dist", "build"];
const IGNORED_EXT = [".png", ".jpg", ".jpeg", ".gif", ".svg", ".ico", ".lock"];

function readDirRecursive(dir) {
  const result = {};

  const items = fs.readdirSync(dir);

  for (const item of items) {
    const fullPath = path.join(dir, item);
    const stat = fs.statSync(fullPath);

    // Игнор папок
    if (stat.isDirectory()) {
      if (IGNORED_DIRS.includes(item)) continue;
      result[item] = readDirRecursive(fullPath);
    } else {
      const ext = path.extname(item);

      // Игнор бинарников
      if (IGNORED_EXT.includes(ext)) continue;

      try {
        const content = fs.readFileSync(fullPath, "utf-8");
        result[item] = {
          type: "file",
          content,
        };
      } catch (e) {
        result[item] = {
          type: "file",
          content: "BINARY_OR_UNREADABLE",
        };
      }
    }
  }

  return result;
}

const targetDir = process.argv[2] || ".";
const output = readDirRecursive(targetDir);

fs.writeFileSync("project.json", JSON.stringify(output, null, 2));

console.log("✅ Готово: project.json создан");
