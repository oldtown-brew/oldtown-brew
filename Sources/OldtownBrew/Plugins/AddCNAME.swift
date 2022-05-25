//
//  AddCNAME.swift
//  OldtownBrew
//
//  Created by Thomas Bonk on 25.05.22.
//

import Foundation
import Publish

extension PublishingStep {
  static func addCNAME(customUrl: String) -> Self{
    return step(named: "Adding CNAME file for cusom URL \(customUrl)") { context in
      let outputFile = try context.createOutputFile(at: "CNAME")

      try outputFile.write(customUrl)
    }
  }
}
