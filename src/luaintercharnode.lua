function activate()
  luatexbase.add_to_callback('pre_linebreak_filter', intercharnode, 'Inter-char node processing')
end

function deactivate()
  luatexbase.remove_from_callback('pre_linebreak_filter', 'Inter-char node processing')
end
