module = "uniudletter"
ctanpkg = "uniudletter"
packtdszip = true

local function read_version()
  local f = assert(io.open("VERSION", "r"), "Cannot open VERSION")
  local value = assert(f:read("*l"), "VERSION is empty")
  f:close()
  value = value:match("^%s*(.-)%s*$")
  assert(value:match("^%d+%.%d+%.%d+$"), "Invalid VERSION: " .. value)
  return value
end

local version = read_version()

sourcefiles = {
  "*.cls",
  "*.sty",
  "*.lco",
  "uniudletter-version.tex",
}

installfiles = {
  "*.cls",
  "*.sty",
  "*.lco",
  "uniudletter-version.tex",
}

textfiles = {
  "build.lua",
  "README.md",
  "INSTALL.md",
  "ASSETS.md",
  "CHANGELOG.md",
  "LICENSE",
  "NOTICE",
  "VERSION",
  "release.sh",
  "install.sh",
  "install-assets.sh",
  "check-assets.sh",
  "uninstall.sh",
}

docfiles = {
  "examples/*.tex",
}

typesetfiles = {}

checkengines = {"xetex"}
stdengine = "xetex"
checkruns = 2

-- Keep the release archive self-contained and TeX Directory Structure-ready.
tdslocations = {
  ["*.cls"] = "tex/latex/uniudletter",
  ["*.sty"] = "tex/latex/uniudletter",
  ["*.lco"] = "tex/latex/uniudletter",
  ["uniudletter-version.tex"] = "tex/latex/uniudletter",
  ["README.md"] = "doc/latex/uniudletter",
  ["INSTALL.md"] = "doc/latex/uniudletter",
  ["ASSETS.md"] = "doc/latex/uniudletter",
  ["CHANGELOG.md"] = "doc/latex/uniudletter",
  ["LICENSE"] = "doc/latex/uniudletter",
  ["NOTICE"] = "doc/latex/uniudletter",
  ["examples/*.tex"] = "doc/latex/uniudletter/examples",
  ["install-assets.sh"] = "scripts/uniudletter",
  ["check-assets.sh"] = "scripts/uniudletter",
}

uploadconfig = {
  pkg = "uniudletter",
  version = version,
  author = "Luca Di Gaspero and contributors",
  license = "mit",
  summary = "University of Udine letter class based on KOMA-Script",
  ctanPath = "/macros/latex/contrib/uniudletter",
  repository = "https://github.com/liuq/uniud-letter",
  bugtracker = "https://github.com/liuq/uniud-letter/issues",
  update = true,
}
