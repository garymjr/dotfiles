local home = os.getenv('HOME')
local dir = home .. '/Code/somecoolproject'
print(dir:gsub(home, '~'))
