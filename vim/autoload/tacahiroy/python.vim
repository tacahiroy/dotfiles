let &pyxversion = 2
pythonx << EOF
import sqlparse
from vim import *
def format_sql(firstline, lastline):
  buf = vim.current.buffer
  lines = ''.join(vim.eval('getline(%d, %d)' % (firstline + 1, lastline + 1)))

  sql = sqlparse.format(lines, reindent=True, keyword_case='upper')
  for l in range(firstline, lastline + 1):
      del buf[l-1]
  buf.append(sql.split("\n"), firstline)
EOF
