//
//  Item+IndexDescription.swift
//  OldtownBrew
//
//  Created by Thomas Bonk on 29.05.22.
//

import Foundation
import Publish

private let PageBreak = "<!-- PAGEBREAK -->"

fileprivate extension String {
  func removingHtmlTags() -> String {
    return replacingOccurrences(
      of: "<[^>]+>",
      with: "",
      options: .regularExpression,
      range: nil)
  }
}

extension Item {
  var indexDescription: String {
    if self.content.body.html.contains(PageBreak) {
      return self.content.body.html
        .components(separatedBy: PageBreak)[0]
        .replacingOccurrences(
          of: "<h1>\(self.title)</h1>",
          with: "")
        .removingHtmlTags()
    } else {
      return self.description
    }

  }
}
