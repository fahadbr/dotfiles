
local teststring = '/Users/fahadriaz/repos/veris/cdm-engine/server/src/main/java/com/axoni/veris/server'
local pkgpath = string.match(teststring, '.*/src/%w+/java/(.*)')
print(pkgpath)
local pkg = string.gsub(pkgpath, '/', '.')
print(pkg)

-- to test, run
-- `messages clear | luafile %`
