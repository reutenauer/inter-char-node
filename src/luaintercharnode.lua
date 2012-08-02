function intercharnode(head)
  local glyph_id, kern_id = node.id('glyph'), node.id('kern')
  local node_types = node.types

  local function isascii(charnode)
    local c = charnode.char
    return c > 0x40 and c <= 0x5A or c > 0x60 and c <= 0x7A
  end

  local emspace = node.new(kern_id, 1)
  emspace.kern = tex.sp('1em')

  local prevnode
  for currnode in node.traverse(head) do
    local node_info = 'NODE TYPE ' .. node_types()[currnode.id]
    if currnode.id == glyph_id then node_info = node_info .. ' ' .. currnode.char end
    if prevnode and prevnode.id == glyph_id and currnode.id == glyph_id then
      texio.write_nl(prevnode.char .. ' and ' .. currnode.char)
      if isascii(prevnode) and isascii(currnode) then
        texio.write_nl("Inserting stuff")
        node.insert_after(head, prevnode, node.copy(emspace))
      end
    end

    texio.write_nl('term and log', node_info)
    prevnode = currnode
  end

  return head
end

function activate()
  luatexbase.add_to_callback('pre_linebreak_filter', intercharnode, 'Inter-char node processing')
end

function deactivate()
  luatexbase.remove_from_callback('pre_linebreak_filter', 'Inter-char node processing')
end
