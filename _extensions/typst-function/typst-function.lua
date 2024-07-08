-- lifted from Quarto's Typst templates, under CC0 1.0
-- https://github.com/quarto-ext/typst-templates/blob/main/ams
local function endTypstBlock(blocks)
  local lastBlock = blocks[#blocks]
  if lastBlock.t == 'Para' or lastBlock.t == 'Plain' then
    lastBlock.content:insert(pandoc.RawInline('typst', ']\n'))
    return blocks
  else
    blocks:insert(pandoc.RawBlock('typst', ']\n'))
    return blocks
  end
end

-- adapted from Quarto's latex-environment template, under MIT
-- https://github.com/quarto-ext/latex-environment
local classFunctions = pandoc.MetaMap({})

-- helper that identifies arrays
local function tisarray(t)
  local i = 0
  for _ in pairs(t) do
    i = i + 1
    if t[i] == nil then return false end
  end
  return true
end

-- reads the functions
local function readFunctions(meta)
  local env = meta['functions']
  if env ~= nil then
    if tisarray(env) then
      -- read an array of strings
      for i, v in ipairs(env) do
        local value = pandoc.utils.stringify(v)
        classFunctions[value] = value
      end
    else
      -- read key value pairs
      for k, v in pairs(env) do
        local key = pandoc.utils.stringify(k)
        local value = pandoc.utils.stringify(v)
        classFunctions[key] = value
      end
    end
  end
end

local blki = 0

-- generalizes the AMS template to arbitrary classes using
-- the latex-environment workflow
local function writeFunctions(el)
  if quarto.doc.is_format('typst') then
    for k, v in pairs(classFunctions) do
      if el.classes:includes(k) then
        blki = blki + 1
        print(blki)
        local beginFunc = '#' .. k
        local args = el.attributes['arguments']
        local spread = el.attributes['spread']
        print("args:", args)
        if args then
          beginFunc = beginFunc .. '(' .. args .. ')'
        end
        beginFunc = beginFunc .. '['
        local blocks = pandoc.List({
          pandoc.RawBlock('typst', beginFunc)
        })
        blocks:extend(el.content)
        blocks = endTypstBlock(blocks)

        local label = el.attributes['label']

        if label then
          blocks:insert(pandoc.RawBlock('typst', '<' .. label .. '>'))
        end

        return blocks
      end
    end
  end
end

return {
  { Meta = readFunctions },
  { Div = writeFunctions }
}
