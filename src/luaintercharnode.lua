function intercharnode(head)
  local glyph_id = node.id('glyph')
  local node_types = node.types

  for n in node.traverse(head) do
    local node_info = 'NODE TYPE ' .. node_types()[n.id]
    if n.id == glyph_id then node_info = node_info .. ' ' .. n.char end
    texio.write_nl('term and log', node_info)
  end

  return head
end

function activate()
  luatexbase.add_to_callback('pre_linebreak_filter', intercharnode, 'Inter-char node processing')
end

function deactivate()
  luatexbase.remove_from_callback('pre_linebreak_filter', 'Inter-char node processing')
end
