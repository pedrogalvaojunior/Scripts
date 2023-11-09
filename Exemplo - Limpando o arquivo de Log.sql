USE LATEX_SISTEMAS

backup log LATEX_SISTEMAS with truncate_only

Dbcc ShrinkFile (LATEX_SISTEMAS_LOG,100)

