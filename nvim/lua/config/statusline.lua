require('nvim-web-devicons').setup()

local gl = require('galaxyline')
local fileinfo = require('galaxyline.provider_fileinfo')
local vcs = require('galaxyline.provider_vcs')
local gls = gl.section

local function file_readonly()
  if vim.bo.filetype == 'help' then
    return ''
  end
  if vim.bo.readonly == true then
    return ' '
  end

  return ''
end

function string:split(delimiter)
  local result = {}
  local from = 1
  local delim_from, delim_to = string.find(self, delimiter, from)
  while delim_from do
    table.insert(result, string.sub(self, from, delim_from - 1))
    from = delim_to + 1
    delim_from, delim_to = string.find(self, delimiter, from)
  end
  table.insert(result, string.sub(self, from))
  return result
end

-- Lua patterns are bullshit and there's no plain text gsub, you have to escape
-- them.
local function literalize(str)
  return str:gsub('[%(%)%.%%%+%-%*%?%[%]%^%$]', function(c)
    return '%' .. c
  end)
end

local get_current_file_path = function()
  local file = vim.fn.expand('%:t')
  local path = vim.fn.expand('%:p:h')
  local git_dir = vcs.get_git_dir(path)
  local home = os.getenv('HOME')

  if git_dir == nil and string.match(path, home) then
    path = '~' .. string.gsub(path, home, '')
  end

  if git_dir ~= nil then
    local del_table = string.split(git_dir, '/')
    local len = table.maxn(del_table)

    -- remove the .git directory from the path.
    del_table[len] = nil

    local del_str = table.concat(del_table, '/') .. '/'
    path = string.gsub(path, literalize(del_str), '')
  end

  if vim.fn.empty(file) == 1 then
    return ''
  end

  if string.len(file_readonly()) ~= 0 then
    return path .. '/' .. file .. file_readonly()
  end

  if vim.bo.modifiable then
    if vim.bo.modified then
      return path .. '/' .. file .. '  '
    end
  end

  return path .. '/' .. file .. ' '
end

local moonflyColors = {
  -- normal colors
  black = '#373c40',
  red = '#ff5454',
  green = '#8cc85f',
  yellow = '#e3c78a',
  blue = '#80a0ff',
  purple = '#d183e8',
  cyan = '#79dac8',
  white = '#de935f', -- more orange

  bright = {
    black = '#f09479',
    red = '#ff5189',
    green = '#36c692',
    yellow = '#bfbf97',
    blue = '#78c2ff',
    purple = '#ae81ff',
    cyan = '#85dc85',
    white = '#e2637f',
  },
}

-- Global Color Defenitions

local colors = {
  background = '#20212b',
  currentline = '#44475a',
  foreground = '#f8f8f2',
  comment = '#6272a4',
  cyan = '#8be9fd',
  green = '#50fa7b',
  orange = '#ffb86c',
  pink = '#ff79c6',
  purple = '#bd93f9',
  red = '#ff5555',
  yellow = '#f1fa8c',
  offsetGray = '#c1c2c9',
}

-- Mappings

local modes = {
  ['n'] = { colors.purple, 'Normal', '' },
  ['i'] = { colors.green, 'Insert', '' },
  ['v'] = { colors.pink, 'Visual', '' },
  [''] = { colors.pink, 'Visual Block', '' },
  ['V'] = { colors.pink, 'Visual Line', '' },
  ['c'] = { colors.orange, 'Command', '' },
  ['no'] = { colors.purple, 'MODE', '' },
  ['s'] = { colors.orange, 'MODE', '' },
  ['S'] = { colors.orange, 'MODE', '' },
  [''] = { colors.orange, 'MODE', '' },
  ['ic'] = { colors.yellow, 'MODE', '' },
  ['R'] = { colors.purple, 'MODE', '' },
  ['Rv'] = { colors.purple, 'MODE', '' },
  ['cv'] = { colors.red, 'MODE', '' },
  ['ce'] = { colors.red, 'MODE', '' },
  ['r'] = { colors.cyan, 'MODE', '' },
  ['rm'] = { colors.cyan, 'MODE', '' },
  ['r?'] = { colors.cyan, 'MODE', '' },
  ['!'] = { colors.red, 'MODE', '' },
  ['t'] = { colors.red, 'MODE', '' },
}

-- Helper functions

--- Abbreviate each individual word in a string
-- @param s String to abbreviate
-- @param n Number of characters to abbreviate each word to
local abbrev = function(s, n)
  local result = ''

  for token in string.gmatch(s, '[^%s]+') do
    result = result .. string.sub(token, 1, n) .. ' '
  end

  return result
end

--- Test if the buffer is empty
local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end

  return false
end

--- Test if the window is wide enough to display git added/removed/changed stats
local checkwidth = function()
  local squeeze_width = vim.fn.winwidth(0) / 2

  if squeeze_width > 40 then
    return true
  end

  return false
end

local downcase = function(fn)
  return function()
    return string.lower(fn())
  end
end

local function addPart(section, entry)
  table.insert(section, entry)
end

-- local function getShortGitBranch()
--   local branch = vcs.get_git_branch()
--   local parts = branch:split("/")

--   -- If the branch is like dbalatero/BLAH-1234/foo
--   -- strip it to just be "foo"
--   local lastSection = parts[table.maxn(parts)]

--   return lastSection
-- end

-- Left Section

addPart(gls.left, {
  ViMode = {
    provider = function()
      local mode = vim.fn.mode()
      local mode_color = modes[mode][1]
      local mode_string = modes[mode][2]

      vim.api.nvim_command('hi GalaxyViMode guifg=' .. mode_color .. ' guibg=' .. colors.background .. ' gui=bold')

      return '▊ ' .. abbrev(mode_string, 2) .. ' '
    end,
  },
})

addPart(gls.left, {
  ScrollBar = {
    provider = function()
      return vim.api.nvim_eval('LineNoIndicator()')
    end,
    highlight = { colors.foreground, colors.background },
    separator = ' ',
    separator_highlight = { 'NONE', colors.background },
  },
})

addPart(gls.left, {
  FileIcon = {
    provider = 'FileIcon',
    condition = buffer_not_empty,
    highlight = {
      colors.foreground,
      colors.background,
    },
  },
})

addPart(gls.left, {
  FileName = {
    provider = get_current_file_path,
    condition = buffer_not_empty,
    highlight = {
      moonflyColors.bright.blue,
      colors.background,
      'bold',
    },
    separator = ' ',
    separator_highlight = { 'NONE', colors.background },
  },
})

addPart(gls.left, {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = { colors.red, colors.background },
    separator = '',
    separator_highlight = { 'NONE', colors.background },
  },
})

addPart(gls.left, {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = { colors.yellow, colors.background },
    separator = '',
    separator_highlight = { 'NONE', colors.background },
  },
})

addPart(gls.left, {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = { colors.cyan, colors.background },
    separator = '',
    separator_highlight = { 'NONE', colors.background },
  },
})

-- Right Section

addPart(gls.right, {
  FileEncode = {
    provider = downcase(fileinfo.get_file_encode),
    separator = ' ',
    separator_highlight = { 'NONE', colors.background },
    highlight = { colors.offsetGray, colors.background, 'bold' },
  },
})

addPart(gls.right, {
  FileFormat = {
    provider = downcase(fileinfo.get_file_format),
    separator = ' ',
    separator_highlight = { 'NONE', colors.background },
    highlight = { colors.offsetGray, colors.background, 'bold' },
  },
})

addPart(gls.right, {
  GitIcon = {
    provider = function()
      return '  '
    end,
    condition = vcs.check_git_workspace,
    separator = ' ',
    separator_highlight = { 'NONE', colors.background },
    highlight = { colors.purple, colors.background, 'bold' },
  },
})

addPart(gls.right, {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = checkwidth,
    separator = ' ',
    separator_highlight = { 'NONE', colors.background },
    icon = '  ',
    highlight = { colors.green, colors.background },
  },
})

addPart(gls.right, {
  DiffModified = {
    provider = 'DiffModified',
    condition = checkwidth,
    icon = ' 柳',
    highlight = { colors.orange, colors.background },
  },
})

addPart(gls.right, {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = checkwidth,
    icon = '  ',
    highlight = { colors.red, colors.background },
  },
})

-- Short Left Section

addPart(gls.short_line_left, {
  Spacer = {
    provider = function()
      return ' '
    end,
    highlight = { colors.white, colors.background, 'bold' },
  },
})

addPart(gls.short_line_left, {
  FileIconShort = {
    provider = 'FileIcon',
    condition = buffer_not_empty,
    highlight = { colors.white, colors.background },
  },
})

addPart(gls.short_line_left, {
  SFileName = {
    provider = function()
      local fname = fileinfo.get_current_file_name()

      for _, v in ipairs(gl.short_line_list) do
        if v == vim.bo.filetype then
          return ''
        end
      end

      return fname
    end,
    condition = buffer_not_empty,
    highlight = { colors.white, colors.background, 'bold' },
  },
})

-- Short Right Section

addPart(gls.short_line_right, {
  BufferIcon = {
    provider = 'BufferIcon',
    highlight = { colors.foreground, colors.background },
  },
})

addPart(gls.left, {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = { colors.blue, colors.background },
  },
})

-- Force manual load so that nvim boots with a status line
gl.load_galaxyline()
