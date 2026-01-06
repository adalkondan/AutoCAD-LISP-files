;to insert Rev block on DRG. -basu
;-----------------------------------
 (defun seterr (s)
  (if (/= s "Function cancelled")
      (princ (strcat "\n:ERROR: " s)))
  (setq *error* olderr)
  (princ))
;-----------------
(defun c:extra (/ 
;clay format dwgp addblk
)
 (setvar "cmdecho" 0) 
 (setq olderr *error*
       *error* seterr
      clay (getvar "clayer")
      format (getvar "useri1")
      dwgp(getvar "dwgprefix")
 )
 (cond ((= format 0) (setq addblk "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/bonusA0"))
       ((= format 1) (setq addblk "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/bonusA1"))
       ((= format 2) (setq addblk "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/bonusA2"))
       ((= format 3) (setq addblk "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/bonusA3"))
       ((= format 4) (setq addblk "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/bonusA4"))
       ((> format 4) (princ "\n Sorry no way i can help, run setup.."))
 )
 (laytab "sl" 211)
 (if addblk 
  (command "tilemode" "0" ps
           "insert" addblk "none" "0,0" "1" "1" "0"))
 (c:normal)
)