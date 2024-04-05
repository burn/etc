function trim(s) return s:match'^%s*(.*)%s*' end

s = io.read("*all") 
s = string.gsub(s, 
     "(\nfunction[^>\n]+>[^;]+;)([^\n]+)\n",
     function(head,comment) 
        comment = trim(comment)
        comment = #comment == 0 and "" or "-- "..comment
        return "\n"..comment..head .."\n" end)

print(s)
