// Each package an application imports in Node, as npm installed it with its
// dependencies. react-ui's entry imports its CSS, which a bundler resolves and
// Node does not, so of react-ui npm's install is the check.
const packages = ["@xynolog/core", "@xynolog/observability", "@xynolog/http-transport", "@xynolog/sdk"];
for (const name of packages) {
  const exported = Object.keys(await import(name));
  if (exported.length === 0) throw new Error(`${name} exports nothing`);
  console.log(`${name}: ${exported.length} exports`);
}
const { XynologClient } = await import("@xynolog/sdk");
if (typeof XynologClient !== "function") throw new Error("@xynolog/sdk exports no XynologClient");
