import Foundation
import Subprocess

/// The user (or organization) and branch the current checkout pushes to, detected from the local git configuration.
///
/// Not tied to a hosting service: the user is whatever precedes the repository name in the remote's URL.
///
/// Works without the branch having been pushed: the owner comes from the remote's URL, which is set at clone time.
/// The remote is resolved the same way `git push` does: `branch.<name>.pushRemote`, then `remote.pushDefault`,
/// then `branch.<name>.remote`, then `origin`.
struct GitBranchInfo {
    let username: String
    let branch: String
    let remote: String

    struct DetectionError: Error, CustomStringConvertible {
        let description: String
    }

    static func detect(in directory: URL) async throws -> GitBranchInfo {
        let git = Git(directory: directory)

        guard let branch = try await git.run("symbolic-ref", "--quiet", "--short", "HEAD") else {
            throw DetectionError(description: "❌ Could not detect the current branch (detached HEAD or not a git repository). Check out a branch first.")
        }

        var remote = "origin"
        for candidate in [
            try await git.run("config", "--get", "branch.\(branch).pushRemote"),
            try await git.run("config", "--get", "remote.pushDefault"),
            try await git.run("config", "--get", "branch.\(branch).remote"),
        ] {
            if let candidate, candidate != "." {
                remote = candidate
                break
            }
        }

        guard let remoteURL = try await git.run("remote", "get-url", "--push", remote) else {
            throw DetectionError(description: "❌ Could not read the URL of git remote '\(remote)'.")
        }

        guard let username = owner(from: remoteURL) else {
            throw DetectionError(description: "❌ Could not detect a username from the URL of git remote '\(remote)'.")
        }

        return GitBranchInfo(username: username, branch: branch, remote: remote)
    }

    /// Returns the path before the repository name in a remote URL, for any host (GitHub, GitLab, Bitbucket, …):
    /// `https://host/owner/repo.git`, `ssh://user@host:22/owner/repo`, `user@host:owner/repo.git` and
    /// `host-alias:owner/repo` all give `owner`; GitLab nested groups (`host:group/subgroup/repo`) give `group/subgroup`.
    /// Local paths, `file://` URLs and URLs without an owner give `nil`.
    static func owner(from remoteURL: String) -> String? {
        guard !remoteURL.hasPrefix("file:") else { return nil }
        // Everything after `scheme://[user@]host[:port]/` or after scp-like `[user@]host:`
        let pattern = /^(?:[A-Za-z][A-Za-z0-9+.\-]*:\/\/[^\/]+|[^\/:]+:)(?<path>.*)$/
        guard let match = remoteURL.wholeMatch(of: pattern) else { return nil }
        let components = match.path.split(separator: "/")
        guard components.count >= 2 else { return nil }
        return components.dropLast().joined(separator: "/")
    }
}

private struct Git {
    let directory: URL

    /// Runs a git command and returns its trimmed standard output, or `nil` if it failed or printed nothing.
    func run(_ arguments: String...) async throws -> String? {
        let result = try await Subprocess.run(
            .name("git"),
            arguments: Arguments(["-C", directory.path] + arguments),
            output: .string(limit: 64 * 1024),
            error: .discarded
        )
        guard result.terminationStatus.isSuccess else { return nil }
        let output = result.standardOutput.trimmingCharacters(in: .whitespacesAndNewlines)
        return output.isEmpty ? nil : output
    }
}
