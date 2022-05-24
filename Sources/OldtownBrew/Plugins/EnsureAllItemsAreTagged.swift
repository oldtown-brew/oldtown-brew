//
//  EnsureAllItemsAreTagged.swift
//  OldtownBrew
//
//  Created by Thomas Bonk on 23.05.22.
//

import Foundation
import Publish

extension Plugin {
  static var ensureAllItemsAreTagged: Self {
    Plugin(name: "Ensure that all items are tagged") { context in
      let allItems = context.sections.flatMap { $0.items }

      for item in allItems {
        guard !item.path.string.starts(with: "imprint/")
                || !item.path.string.starts(with: "about/")
                || !item.tags.isEmpty else {
          
          throw PublishingError(
            path: item.path,
            infoMessage: "Item has no tags"
          )
        }
      }
    }
  }
}
