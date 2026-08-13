local specs = {
    "tests.structdiff_spec",
    "tests.keymaps_spec",
    "tests.treesitter_spec",
}

local failures = {}
local total = 0

for _, spec_name in ipairs(specs) do
    local ok, spec = pcall(require, spec_name)
    if not ok then
        table.insert(failures, spec_name .. " failed to load: " .. spec)
    else
        local names = {}
        for name, fn in pairs(spec) do
            if type(fn) == "function" and name:match("^test_") then
                table.insert(names, name)
            end
        end
        table.sort(names)
        for _, name in ipairs(names) do
            total = total + 1
            local test_ok, err = xpcall(spec[name], debug.traceback)
            if test_ok then
                print("ok " .. total .. " - " .. spec_name .. "." .. name)
            else
                print("not ok " .. total .. " - " .. spec_name .. "." .. name)
                table.insert(failures, spec_name .. "." .. name .. "\n" .. err)
            end
        end
    end
end

if #failures > 0 then
    print("\nFailures:")
    for _, failure in ipairs(failures) do
        print("---")
        print(failure)
    end
    vim.cmd("cquit 1")
end

print("\nAll " .. total .. " tests passed")
vim.cmd("qa")
