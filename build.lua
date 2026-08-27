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
  "uniud-sigillo-blu.pdf",
  "uniud-sigillo-blu.svg",
  "uniud-footer-istituzionale-blu.pdf",
  "uniud-footer-istituzionale-blu.svg",
  "uniud-footer-certificazioni.pdf",
}

installfiles = {
  "*.cls",
  "*.sty",
  "*.lco",
  "uniudletter-version.tex",
  "uniud-sigillo-blu.pdf",
  "uniud-sigillo-blu.svg",
  "uniud-footer-istituzionale-blu.pdf",
  "uniud-footer-istituzionale-blu.svg",
  "uniud-footer-certificazioni.pdf",
}

textfiles = {
  "build.lua",
  "README.md",
  "INSTALL.md",
  "CHANGELOG.md",
  "LICENSE",
  "NOTICE",
  "VERSION",
  "release.sh",
  "install.sh",
  "uninstall.sh",
}

docfiles = {
  "examples/*.tex",
  "examples/*.pdf",
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
  ["uniud-sigillo-blu.pdf"] = "tex/latex/uniudletter",
  ["uniud-sigillo-blu.svg"] = "tex/latex/uniudletter",
  ["uniud-footer-istituzionale-blu.pdf"] = "tex/latex/uniudletter",
  ["uniud-footer-istituzionale-blu.svg"] = "tex/latex/uniudletter",
  ["uniud-footer-certificazioni.pdf"] = "tex/latex/uniudletter",
  ["README.md"] = "doc/latex/uniudletter",
  ["INSTALL.md"] = "doc/latex/uniudletter",
  ["CHANGELOG.md"] = "doc/latex/uniudletter",
  ["LICENSE"] = "doc/latex/uniudletter",
  ["NOTICE"] = "doc/latex/uniudletter",
  ["examples/*.tex"] = "doc/latex/uniudletter/examples",
  ["examples/*.pdf"] = "doc/latex/uniudletter/examples",
}

uploadconfig = {
  pkg = "uniudletter",
  version = version,
  author = "Luca Di Gaspero and contributors",
  license = "cc-by-nc-4",
  summary = "University of Udine letter class based on KOMA-Script",
  ctanPath = "/macros/latex/contrib/uniudletter",
  repository = "https://github.com/liuq/uniud-letter",
  bugtracker = "https://github.com/liuq/uniud-letter/issues",
  update = true,
}
