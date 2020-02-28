// jsonnet manifest.jsonnet --ext-str browser=chrome|firefox -o extension/manifest.json
local icons() = {
    [size]: "icon.png"
    for size in ["16","48","128"]
};
local manifest = {
      manifest_version: 2,
      name: "Rust Search Extension",
      description: "A handy browser extension to search crates and official docs in the address bar (omnibox)",
      version: "0.8",
      icons: icons(),
      browser_action: {
        default_icon: icons(),
        default_popup: "popup.html",
        default_title: "A handy browser extension to search crates and official docs in the address bar (omnibox)"
      },
      content_security_policy: "script-src 'self'; object-src 'self';",
      omnibox: {
        keyword: "rs"
      },
      content_scripts: [{
            matches: [
              "*://docs.rs/*"
            ],
            js: [
              "script/docs-rs.js"
            ],
            run_at: "document_start"
      }],
      background: {
        scripts: [
          "compat.js",
          "settings.js",
          "deminifier.js",
          "search/doc.js",
          "search/book.js",
          "search/crate.js",
          "search/attribute.js",
          "index/books.js",
          "index/crates.js",
          "index/std-docs.js",
          "command/base.js",
          "command/history.js",
          "command/manager.js",
          "omnibox.js",
          "main.js",
          "app.js",
        ]
      },
      permissions: [
        "tabs"
      ],
      appendContentSecurityPolicy(policy)::self + {
            content_security_policy +: policy,
      }
};

if std.extVar("browser") == "firefox" then
  manifest
else
  manifest.appendContentSecurityPolicy(" script-src-elem 'self' https://rust-search-extension.now.sh/crates/index.js;")