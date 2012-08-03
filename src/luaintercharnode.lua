function intercharnode(head)
  local inter_char_nodes = { }
  local glyph_id, kern_id = node.id('glyph'), node.id('kern')
  local node_types = node.types

  local function isascii(charnode)
    local c = charnode.char
    return c > 0x40 and c <= 0x5A or c > 0x60 and c <= 0x7A
  end

  local function charclass(charnode)
    if isascii(charnode) then
      return 1
    elseif charnode.char == 0x3A then
      return 2
    end
  end

  local emspace = node.new(kern_id, 1)
  emspace.kern = tex.sp('1em')

  -- TODO Find something better than that
  -- inter_char_nodes[{ 1, 1 }] = emspace
  inter_char_nodes[1] = { }
  inter_char_nodes[1][1] = emspace

  function internodes(c1, c2)
    if inter_char_nodes[c1] then
      return inter_char_nodes[c1][c2]
    end
  end

  if node.is_node(emspace) then
    texio.write_nl('emspace is a node')
  else
    texio.write_nl('emspace is NOT a node')
  end

  if node.is_node(inter_char_nodes[{ 1, 1 }]) then
    texio.write_nl('internodes[{ 1, 1 }] is a node')
  else
    texio.write_nl('internodes[{ 1, 1 }] is NOT a node')
  end

  local prevnode
  for currnode in node.traverse(head) do
    local node_info = 'NODE TYPE ' .. node_types()[currnode.id]
    if currnode.id == glyph_id then node_info = node_info .. ' ' .. currnode.char end
    if prevnode and prevnode.id == glyph_id and currnode.id == glyph_id then
      local prevclass = charclass(prevnode)
      local currclass = charclass(currnode)
      if prevclass and currclass then
        texio.write_nl(prevclass .. ' and ' .. currclass)
        local internode = internodes(prevclass, currclass)
        texio.write_nl('internode is a ' .. type(internode))
        if node.is_node(internode) then
          texio.write_nl("Inserting stuff")
          node.insert_after(head, prevnode, node.copy(internode))
        end
      end
    end

    texio.write_nl('term and log', node_info)
    prevnode = currnode
  end

  texio.write_nl('internodes[{ 1, 1 }] is a ' .. type(inter_char_nodes[{ 1, 1 }]))
  return head
end

function activate()
  luatexbase.add_to_callback('pre_linebreak_filter', intercharnode, 'Inter-char node processing')
end

function deactivate()
  luatexbase.remove_from_callback('pre_linebreak_filter', 'Inter-char node processing')
end
