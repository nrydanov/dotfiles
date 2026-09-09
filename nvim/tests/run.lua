local specs = { vim.env.SPEC or "tests.structdiff_spec" }

local failures, total = {}, 0

for _, spec_name in ipairs(specs) do
    local ok, spec = pcall(require, spec_name)
    if not ok then
        failures[#failures + 1] = spec_name .. " failed to load: " .. spec
    else
        local names = {}
        for name, fn in pairs(spec) do
            if type(fn) == "function" and name:match("^test_") then
                names[#names + 1] = name
            end
        end
        table.sort(names)
        for _, name in ipairs(names) do
            total = total + 1
            local test_ok, err = xpcall(spec[name], debug.traceback)
            print((test_ok and "ok " or "not ok ") .. total .. " - " .. name)
            if not test_ok then
                failures[#failures + 1] = name .. "\n" .. err
            end
        end
    end
end

if #failures > 0 then
    print("\nFailures:")
    for _, failure in ipairs(failures) do
        print("---\n" .. failure)
    end
    vim.cmd("cquit! 1")
end
print("\nAll " .. total .. " tests passed")
vim.cmd("qa!")
