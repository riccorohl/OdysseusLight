const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const root = path.resolve(__dirname, '..');
const names = ['odysseus-plan-project', 'odysseus-plan-milestone', 'odysseus-review-plan'];
for (const name of names) {
  const file = path.join(root, 'skills', name, 'SKILL.md');
  const text = fs.readFileSync(file, 'utf8');
  assert.match(text, new RegExp(`^---\\r?\\nname: ${name}\\r?\\ndescription: .+\\r?\\n---`));
  assert.ok(text.length < 10000, `${name} entrypoint should remain concise`);
}
let checked = 0;
function walk(dir) {
  for (const entry of fs.readdirSync(dir, {withFileTypes: true})) {
    if (entry.name.startsWith('.') || entry.name === 'node_modules') continue;
    const file = path.join(dir, entry.name);
    if (entry.isDirectory()) { walk(file); continue; }
    if (!entry.name.endsWith('.md')) continue;
    checked++;
    const text = fs.readFileSync(file, 'utf8');
    for (const match of text.matchAll(/\[[^\]]*\]\(([^)]+)\)/g)) {
      const target = match[1].replace(/^<|>$/g, '').split('#')[0];
      if (!target || /^[a-z]+:/i.test(target)) continue;
      assert.ok(fs.existsSync(path.resolve(path.dirname(file), target)), `Broken link in ${path.relative(root, file)}: ${target}`);
    }
  }
}
walk(root);
const milestone = fs.readFileSync(path.join(root,'examples/draftbook/milestones/M01.md'),'utf8');
for (const heading of ['Outcome','Requirements and failure behavior','Acceptance examples and completion evidence','Non-goals and dependencies','Constraints and reasons','Suggestions and assumptions','Open decisions','Implementation handoff']) {
  assert.ok(milestone.includes(`## ${heading}`), `Missing example section ${heading}`);
}
console.log(`Validated ${names.length} skill entrypoints and relative links in ${checked} Markdown files. Semantic behavior requires review.`);
