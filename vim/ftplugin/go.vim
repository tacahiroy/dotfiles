vim9script

if exists("b:did_go_ftplugin")
  finish
endif
b:did_go_ftplugin = 1

inoremap ;; :=
