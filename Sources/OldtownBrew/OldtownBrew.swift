//
//  OldtownBrew.swift
//  OldtownBrew
//
//  Created by Thomas Bonk on 26.05.22.
//

import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct OldtownBrew: Website {
  enum SectionID: String, WebsiteSectionID {
    // Add the sections that you want your website to contain here:
    case posts
    case impressum
  }

  struct ItemMetadata: WebsiteItemMetadata {
    // Add any site-specific metadata that you want to use here.
    var draft: Bool = false
  }

  // Update these properties to configure your website:
  var url = URL(string: "https://blog.oldtown-brew.de/")!
  var name = "Oldtown Brew"
  var description = "Die Hobbybrauerei in Kirkel-Altstadt"
  var language: Language { .german }
  var imagePath: Path? { "images" }
}
