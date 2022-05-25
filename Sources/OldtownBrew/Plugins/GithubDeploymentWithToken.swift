//
//  GithubDeploymentWithToken.swift
//  OldtownBrew
//
//  Created by Thomas Bonk on 25.05.22.
//

import Foundation
import Publish

extension DeploymentMethod {
  /// Deploy a website to a given GitHub repository.
  /// - parameter repository: The full name of the repository (including its username).
  /// - parameter tokenEnvName: The environment variable that contains the token
  /// - parameter branch: The branch to push to and pull from (default is master).
  /// - parameter useSSH: Whether an SSH connection should be used (preferred).
  static func gitHub(_ repository: String, tokenEnvName: String, branch: String = "master") -> Self {
    let token = ProcessInfo.processInfo.environment[tokenEnvName]!
    let prefix = "https://\(token)@github.com/"
    return git("\(prefix)\(repository).git", branch: branch)
  }
}
