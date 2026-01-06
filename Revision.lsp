;to insert Rev block on DRG. -basu
;-----------------------------------
 (defun seterr (s)
  (if (/= s "Function cancelled")
      (princ (strcat "\n:ERROR: " s)))
  (setq *error* olderr)
  (princ))
;-----------------
(defun c:revision (/ clay scale format dwgp revblk)
 (setvar "cmdecho" 0) 
 (setq olderr *error*
       *error* seterr
      clay (getvar "clayer")
      scale (getvar "userr1")
      format (getvar "useri1")
      dwgp(getvar "dwgprefix")
 )
 (cond ((= format 0) (setq revblk "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/revfilA0"))
       ((= format 1) (setq revblk "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/revfilA1"))
       ((= format 2) (setq revblk "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/revfilA2"))
       ((= format 3) (setq revblk "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/revfilA3"))
       ((= format 4) (setq revblk "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/revfilA4"))
       ((> format 4) (princ "\n Sorry no way i can't help, run setup.."))
 )
 (laytab "xf" 106)
 (command "tilemode" "0" ps "zoom" "e")
 (if revblk (command "insert" revblk pause "1" "1" "0" "" "" "" "" "" ""))
 (c:normal)
)