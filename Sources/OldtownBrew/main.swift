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
  var imagePath: Path? { "Images" }
}

let now = Date()
// This will generate your website using the built-in Foundation theme:
try OldtownBrew().publish(using: [
  .addMarkdownFiles(),
  .if(true, .removeAllItems(matching: Predicate(matcher: { item in item.date > now }))),
  .if(true, .removeAllItems(matching: \.metadata.draft == true)),
  .generateHTML(withTheme: .oldtownBrew),
  .copyResources(),
  .generateSiteMap(),
  .generateRSSFeed(including: [.posts]),
  .addCNAME(customUrl: "blog.oldtown-brew.de"),
  .deploy(using: .gitHub("oldtown-brew/oldtown-brew", tokenEnvName: "GH_TOKEN", branch: "main"))
])
