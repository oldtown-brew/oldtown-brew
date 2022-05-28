//
//  main.swift
//  OldtownBrew
//
//  Created by Thomas Bonk on 26.05.22.
//

import Foundation
import Publish
import Plot

let now = Date()

// This will generate your website using the built-in Foundation theme:
try OldtownBrew().publish(using: [
  .addMarkdownFiles(),
  .removeAllItems(matching: Predicate(matcher: { item in item.date > now })),
  .removeAllItems(matching: \.metadata.draft == true),
  .generateHTML(withTheme: .oldtownBrew),
  .copyResources(),
  .generateSiteMap(),
  .generateRSSFeed(including: [.posts]),
  .addCNAME(customUrl: "blog.oldtown-brew.de"),
  //.deploy(using: .gitHub("oldtown-brew/oldtown-brew", tokenEnvName: "AUTHENTICATION_TOKEN", branch: "main"))
  .deploy(using: .gitHub("oldtown-brew/oldtown-brew", branch: "main", useSSH: false))
])
