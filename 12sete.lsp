;This spl setup prg is created for wil -  basavaraju may-99.
;---------------------------------------------------
(DEFUN C:LAYTAB ()
   (SETVAR "CMDECHO" 0)
   (setq ts (tblsearch "LAYER" LANAM) XX "Yes")
   (if (null ts) 
      (PROGN (prompt "\nCreating new layer - ") 
        (PRINC LANAM) (PRINC "\n"))
      (progn
        (if (= (logand 1 (cdr (assoc 70 ts))) 1)
           (progn (PRINC "\n")
             (PRINC LANAM) (prompt " Layer is frozen. ")
             (initget  "Yes No")
             (setq XX (getkword "\nProceed? <Y>: "))
             (if (= XX NUL) (setq XX "Yes")) 
             (if (= XX "Yes") (command "LAYER" "T" LANAM ""))
           )
        )
      )
   )
   (if (= XX "Yes") (COMMAND "LAYER" "M" LANAM "C" CLRNO LANAM ""))
)
;--------------
(defun tdate(/ mm dd cdate)
 (setq cdate(rtos (getvar "cdate"))
	  yy(substr cdate 1 4)
	  mm(substr cdate 5 2)
	  dd(substr cdate 7 2))
 (cond ((= mm "01") (setq mm " Jan "))
       ((= mm "02") (setq mm " Feb "))
       ((= mm "03") (setq mm " Mar "))
       ((= mm "04") (setq mm " Apr "))
       ((= mm "05") (setq mm " May "))
       ((= mm "06") (setq mm " June "))
       ((= mm "07") (setq mm " July "))
       ((= mm "08") (setq mm " Aug "))
       ((= mm "09") (setq mm " Sep "))
       ((= mm "10") (setq mm " Oct "))
       ((= mm "11") (setq mm " Nov "))
       ((= mm "12") (setq mm " Dec ")))
 (setq today (strcat dd mm yy))
)
;--------------
(defun border1() 
  (command "insert" msb emin b b 0
           "zoom" "e")
)
;-------------
(defun border2() 
(SETVAR "ATTREQ" 1)
  (setq lanam "XF" clrno "106")(c:laytab)
  (setq drgno(strcat (substr cad 1 8))
        cadl (- (strlen cad) 4)
        cad  (substr cad 1 cadl)
  )
  (command "pspace" "attdia" "0"
           "insert" psb "0,0" "1" "1" 0
           "" "" drgno "" "" cad TODAY "" (strcat "1=" (rtos b))
           (strcat "WIL/")
           "" "" "" "" drawn "" "" "" "" "" "" "" "" ""
           "zoom" "e")
)
;--------------
(defun indata1 ()
 (setq vpx nil vpy nil psb nil msb nil)
 (command "setvar" "lunits" 2 
          "setvar" "luprec" 3 
          "setvar" "auprec" 3) 
 (princ "\n a0=0, a1=1, a2=2, a3=3 or a4=4" )
 (setq a(getint (strcat "\n  Sheet SIZE- A- < " (itoa oa) " > :")))
 (if (= nul a) (setq a oa) (setq oa a))
 (cond ((= a 0) 
   (setq dth 2.5 
        msb  "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/msa0"
        psb  "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/14enga0" 
        vpx 1137.0 vpy 797.0 llc '(13.0 13.0)))
 ((= a 1) 
  (setq dth 2.5 
        msb  "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/msa1"
        psb  "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/12enga1"
        vpx 831.0 vpy 540.0 llc '(10.0 10.0)))
 ((= a 2) 
  (setq dth 2.5 
        msb  "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/msa2" 
        psb  "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/14enga2"
        vpx 540.0 vpy 410.0 llc '(10.0 10.0)))
 ((= a 3) 
  (setq dth 2.0 
        msb  "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/msa3" 
        psb  "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/14enga3" 
        vpx 377.0 vpy 262.0 llc '(5.0 3.0)))
 ((= a 4) 
  (setq dth 2.0
        msb "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/msa4"
        psb "//WEBB_CAD_NEW/Std_Blocks/FORMATS/prg_ref/14enga4"
        vpx 267.0 vpy 182.0 llc '(3.0 3.0)))
 ((> a 4) 
  (progn
   (setq a nil)
   (princ " !! No Setup Available beyond A4 * sorry *")
  )
 )
))
;---------
(defun indata2 ()
 (if (or (= ob nil) (= ob 0)) (setq ob 1)) 
 (command "tilemode" "1")
 (setq obj(ssget "L"))
 (if obj
  (progn
     (command "zoom" "e")
     (setq emin(getvar "extmin")
           emax(getvar "extmax")
           yscale(/ (- (cadr emax) (cadr emin)) vpy)
           xscale(/ (- (car emax) (car emin)) vpx))
           (if (>= xscale yscale) (setq ub xscale) (setq ub yscale))
     (princ (strcat "\n  Your drawing extent SCALE ~ < " (rtos ub) " > ")) 
  ) (setq emin "0,0")
 )
 (setq b(getreal (strcat 
       "\n  Present setting < " (rtos ob) " > Enter SCALE to set 1: ")))
 (if b (setq ib(rtos b)))
 (if (= b nul) (setq b ob) (setq ob b))
 (initget  "Yes No")
 (if (= (getkword "\n  INSERTing MODEL space Border <N>: ") "Yes")
  (border1))
 (command "tilemode" til)
)
;--------------
(defun work1 ()
 (setq lts 8.0 dms 13.88)
 (command 
  "style" "FULL" "romans" dth "1" "0" "n" "n" "n"
  "dim"    
     "dimasz"  "0.18" 
     "DIMCEN"  "0.09"
     "dimclrd" "150" 
     "dimclre" "150"
     "dimclrt" "140"
     "dimdli"  "0.18"
     "dimexe"  "0.18"
     "dimexo"  "0.18"
     "dimfit"  "5"
     "dimgap"  "0.1"
     "dimlfac" "1.0"
     "dimrnd"  "0.1"
     "dimtad"  "off"
     "dimsd1"  "off"
     "dimsd2"  "off"
     "dimse1"  "off"
     "dimse2"  "off"
     "dimtix"  "off"
     "dimtih"  "off"
     "dimtoh"  "off"
     "dimtofl" "on"
     "dimtvp"  "0.0"
     "dimtxt"  "0.18"
     "dimtxsty" "FULL"
     "dimzin"  "8" 
 "setvar" "dimsho" "1"
  "Setvar" "dimaso" "1"
  "setvar" "textsize" dth
  "dimscale" dms "E"
 ) 
 (if (tblsearch "dimstyle" "FULL")
  (command "dim1" "sAVE" "FULL" "y")
  (command "dim1" "sAVE" "FULL")
 )
 (if (> b 1)
  (progn
   (setq dth(* b dth)
         lts(* b 8.0)
         dms(* b (/ 2.5 0.18))
   )
   (command 
     "dimscale" dms
     "style" (fix b) "romans" dth "1" "0" "n" "n" "n"
   )
   (if (tblsearch "dimstyle" (itoa (fix b)))
    (command "dimtxsty" (fix b) "dimstyle" "s" (fix b) "y")
    (command "dimtxsty" (fix b) "dimstyle" "s" (fix b))
   )
  )
 )
 (command 
   "ltscale" lts
   "psltscale" 0
 )
)
;---------------
(defun work2 ()
 (command "mspace")
 (setq cvp(getvar "cvport"))
 (cond 
  ((= cvp 1) 
   (progn
    (princ "\n* * NO view port found * *")
    (initget "Yes No")
    (if (= (getkword "\n  CREATE view port- Y/N  <N> : ") "Yes")
     (progn 
      (setq lanam "xv" clrno "31")(c:laytab)
      (setq urc (list vpx vpy))
      (command "mview" llc urc)
     )
    )
   )
  )
 ) 
 (command "zoom" "e" "mspace")
 (setq cvp(getvar "cvport"))
 (cond 
  ((> cvp 1) 
   (progn
    (initget "Yes No")
    (if (= (getkword "\n  SET SCALE in view port- Y/N  <N> : ") "Yes")
     (progn 
      (setq  scalevp(strcat (rtos(/ 1 b)) "xp"))
      (command "zoom" "e" "zoom" scalevp)
      (initget "Yes No")
      (if (= (getkword "\n  SAVE viewport  <N> ") "Yes")
       (progn
        (princ (strcat "\n  NAME to save <" (itoa (fix b)) "> :"))
        (setq vpn(getstring ))
        (if (or (= vpn "") (= vpn (itoa (fix b)))) 
         (command "view" "save" (itoa (fix b)))
         (command "view" "save" vpn)
        )
       )
      )
     )
    )
   )
  )
 ) 
)
;----------
(DEFUN C:SETUPE (/ 
    til ssl emin emax ubb xx ib b today
    dth vpx psb msb vpy a urc llc cvp scalevp vpn)
 (C:LAYERS)
 (setvar "cmdecho" 0) 
 (setq oa(getvar "useri1")
       ol(getvar "clayer")
       drawn(getvar "loginname")
       ob(getvar "userr1")
       cad(getvar "dwgname")
      til (getvar "tilemode")
 )
 (indata1)
 (if (and (>= a 0) (< a 5))
  (progn 
   (indata2)
   (work1)
   (setq til (getvar "tilemode"))
   (cond 
    ((= til 0) 
     (PROGN 
      (work2) 
      (COMMAND"PSPACE") 
      (princ "\n  INSERTing Border/ Title block")   
      (initget  "Yes No")
      (setq xx (getkword "\n  Proceed? <N>: "))
      (if (= xx "Yes") (progn (tdate) (border2)))
     )
    )
   ) 
   (command 
    "setvar" "userr1" b
    "setvar" "useri1" a 
    "setvar" "textsize" dth
   )
   (setvar "luprec" 1)
   (setvar "auprec" 1)
   (setvar "cmdecho" 1) 
   (setvar "clayer" ol) 
   (princ"\......setup Engineering done.")
  ) (princ " TRY next time")
 )
 (princ)
)