//
//  OldtownBrewTheme.swift
//  OldtownBrew
//
//  Created by Thomas Bonk on 23.05.22.
//

import Foundation
import Plot
import Publish

extension Theme where Site == OldtownBrew {
  static var oldtownBrew: Self {
    Theme(
      htmlFactory: OldtownBrewHTMLFactory(),
      resourcePaths: ["Resources/Theme/styles.css", "Resources/Images/Logo.png"])
  }

  private struct OldtownBrewHTMLFactory: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<OldtownBrew>) throws -> HTML {
      HTML(
        .lang(context.site.language),
        .head(for: index, on: context.site),
        .body {
          SiteHeader(context: context, selectedSelectionID: nil)
          Wrapper {
            ItemList(
              items: context.allItems(
                sortedBy: \.date,
                order: .descending
              ).filter({ $0.sectionID != .impressum && $0.sectionID != .links }),
              site: context.site
            )
          }
          SiteFooter()
        }
      )
    }

    func makeSectionHTML(for section: Section<OldtownBrew>, context: PublishingContext<OldtownBrew>) throws -> HTML {
      if section.id == .impressum {
        let imprint = section.items.first

        if let ip = imprint {
          return try makeItemHTML(for: ip, context: context)
        }
      } else if section.id == .links {
        let links = section.items.first

        if let ln = links {
          return try makeItemHTML(for: ln, context: context)
        }
      }

      return HTML(
        .lang(context.site.language),
        .head(for: section, on: context.site),
        .body {
          SiteHeader(context: context, selectedSelectionID: section.id)
          Wrapper {
            H1(section.title)
            ItemList(items: section.items, site: context.site)
          }
          SiteFooter()
        }
      )
    }

    func makeItemHTML(for item: Item<OldtownBrew>, context: PublishingContext<OldtownBrew>) throws -> HTML {
      HTML(
        .lang(context.site.language),
        .head(for: item, on: context.site),
        .body(
          .class("item-page"),
          .components {
            SiteHeader(context: context, selectedSelectionID: item.sectionID)
            Wrapper {
              Article {
                Div("\(display(date: item.date))").class("article-date")
                Div(item.content.body).class("content")
                if !item.tags.isEmpty {
                  Span("Schlagwörter: ")
                  ItemTagList(item: item, site: context.site)
                }
              }
            }
            SiteFooter()
          }
        )
      )
    }

    func makePageHTML(for page: Page, context: PublishingContext<OldtownBrew>) throws -> HTML {
      HTML(
        .lang(context.site.language),
        .head(for: page, on: context.site),
        .body {
          SiteHeader(context: context, selectedSelectionID: nil)
          Wrapper(page.body)
          SiteFooter()
        }
      )
    }

    func makeTagListHTML(for page: TagListPage, context: PublishingContext<OldtownBrew>) throws -> HTML? {
      HTML(
        .lang(context.site.language),
        .head(for: page, on: context.site),
        .body {
          SiteHeader(context: context, selectedSelectionID: nil)
          Wrapper {
            H1("Alle Schlagwörter")
            List(page.tags.sorted()) { tag in
              ListItem {
                Link(tag.string,
                     url: context.site.path(for: tag).absoluteString
                )
              }
              .class("tag")
            }
            .class("all-tags")
          }
          SiteFooter()
        }
      )
    }

    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<OldtownBrew>) throws -> HTML? {
      HTML(
        .lang(context.site.language),
        .head(for: page, on: context.site),
        .body {
          SiteHeader(context: context, selectedSelectionID: nil)
          Wrapper {
            H1 {
              Text("Schlagwort: ")
              Span(page.tag.string).class("tag")
            }

            Link("Alle Schlagwörter anzeigen",
                 url: context.site.tagListPath.absoluteString
            )
            .class("browse-all")

            ItemList(
              items: context.items(
                taggedWith: page.tag,
                sortedBy: \.date,
                order: .descending
              ),
              site: context.site
            )
          }
          SiteFooter()
        }
      )
    }

  }
}

private struct ItemList<Site: Website>: Component {
  var items: [Item<Site>]
  var site: Site

  var body: Component {
    List(items.sorted(by: { $0.date > $1.date })) { item in
      Article {
        H1(Link(item.title, url: item.path.absoluteString))
        Div("\(display(date: item.date))").class("date")
        ItemTagList(item: item, site: site)
        Paragraph(item.indexDescription)
      }
    }
    .class("item-list")
  }
}

private struct ItemTagList<Site: Website>: Component {
  var item: Item<Site>
  var site: Site

  var body: Component {
    List(item.tags) { tag in
      Link(tag.string, url: site.path(for: tag).absoluteString)
    }
    .class("tag-list")
  }
}

private struct SiteHeader<Site: Website>: Component {
  var context: PublishingContext<Site>
  var selectedSelectionID: Site.SectionID?

  var body: Component {
    Header {
      Wrapper {
        Link(url: "/") {
          Image("/images/Logo.png").attribute(Attribute<OldtownBrew>(name: "height", value: "60"))
        }
        .class("site-name")

        if Site.SectionID.allCases.count > 1 {
          navigation
        }
      }
    }
  }

  private var navigation: Component {
    Navigation {
      List(Site.SectionID.allCases) { sectionID in
        let section = context.sections[sectionID]

        return Link(
          section.title, url: section.path.absoluteString)
        //.class(sectionID == selectedSelectionID ? "selected" : "")
      }
    }
  }
}

private struct SiteFooter: Component {
  var body: Component {
    Footer {
      Paragraph {
        Text("Copyright (C) 2022 Thomas Bonk. ")
        Link("RSS feed", url: "/feed.rss")
      }
    }
  }
}

private struct Wrapper: ComponentContainer {
  @ComponentBuilder var content: ContentProvider

  var body: Component {
    Div(content: content).class("wrapper")
  }
}

func display(date: Date) -> String {
  let formatter = DateFormatter()
  formatter.dateStyle = .long
  formatter.timeStyle = .short
  return formatter.string(from: date)
}
