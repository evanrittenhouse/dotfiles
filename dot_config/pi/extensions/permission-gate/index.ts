/**
 * Permission Gate Extension
 *
 * Ports the opencode `permission.bash` policy: a set of safe commands run without
 * prompting, and every other bash command asks for confirmation in interactive
 * sessions. Mirrors opencode's `"*": "ask"` default plus its allowlist.
 *
 * Notes on equivalence:
 * - opencode's `permission.external_directory` allowlist has no pi equivalent: pi
 *   has no filesystem sandbox and already allows reads/writes anywhere, so those
 *   grants are a no-op here.
 * - Non-interactive runs (`-p`, including subagent child processes) cannot prompt,
 *   so they are not gated. This matches opencode granting subagents `bash: allow`.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

// Bash commands auto-allowed without a prompt. Ported verbatim from the opencode
// `permission.bash` allowlist.
const ALLOW_PATTERNS: string[] = [
	"npm *",
	"npx *",
	"node *",
	"bazel build *",
	"bazel test *",
	"bun *",
	"cargo *",
	"rustfmt *",
	"make *",
	"mkdir *",
	"gofmt *",
	"golangci-lint run *",
	"grep *",
	"echo *",
	"rg *",
	"ls *",
	"cat *",
	"head *",
	"tail *",
	"tee *",
	"sort *",
	"find *",
	"wc *",
	"which *",
	"git status *",
	"git branch *",
	"git log *",
	"git diff *",
	"git show *",
	"git branch -?",
	"git remote *",
	"git rev-parse *",
	"git worktree *",
	"git config --get *",
	"git merge-base *",
	"git symbolic-ref *",
	"~/.config/scripts/git-default-branch",
	"~/.config/scripts/git-default-branch *",
	"gh pr view *",
	"gh pr diff *",
];

// Convert an opencode bash glob (`*` = any run, `?` = single char) to an anchored
// RegExp. A trailing ` *` also matches the bare command with no arguments.
function globToRegExp(pattern: string): RegExp {
	let out = "";
	for (const ch of pattern) {
		if (ch === "*") out += ".*";
		else if (ch === "?") out += ".";
		else out += ch.replace(/[.+^${}()|[\]\\]/g, "\\$&");
	}
	out = out.replace(/ \.\*$/, "(?: .*)?");
	return new RegExp(`^${out}$`);
}

const ALLOW_REGEXPS = ALLOW_PATTERNS.map(globToRegExp);

export default function permissionGate(pi: ExtensionAPI): void {
	const sessionAllowed = new Set<string>();

	pi.on("tool_call", async (event, ctx) => {
		if (event.toolName !== "bash") return undefined;

		const command = ((event.input.command as string) ?? "").trim();

		// Auto-allow commands on the ported opencode allowlist.
		if (ALLOW_REGEXPS.some((re) => re.test(command))) return undefined;

		// No UI to prompt (scripts and `-p` subagent children): let it run.
		if (!ctx.hasUI) return undefined;

		if (sessionAllowed.has(command)) return undefined;

		const choice = await ctx.ui.select(`Allow bash command?\n\n  ${command}`, [
			"Yes",
			"Yes, don't ask again this session",
			"No",
		]);

		if (choice === "Yes, don't ask again this session") {
			sessionAllowed.add(command);
			return undefined;
		}
		if (choice === "Yes") return undefined;

		return { block: true, reason: "Bash command denied by user" };
	});
}
