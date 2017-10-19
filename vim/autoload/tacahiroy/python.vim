let &pyxversion = 3
pythonx << EOF
import sqlparse
import urllib.parse
from vim import *
def format_sql(firstline, lastline):
  buf = vim.current.buffer
  lines = ''.join(vim.eval('getline(%d, %d)' % (firstline + 1, lastline + 1)))

  sql = sqlparse.format(lines, reindent=True, keyword_case='upper')
  for l in range(firstline, lastline + 1):
      del buf[l-1]
  buf.append(sql.split("\n"), firstline)

def encode(line1, line2):
  for i in range(line1, line2+1):
    buf = vim.current.buffer
    buf[i] = urllib.parse.quote(buf[i])

def decode(line1, line2):
  for i in range(line1, line2+1):
    buf = vim.current.buffer
    buf[i] = urllib.parse.unquote(buf[i])
EOF
