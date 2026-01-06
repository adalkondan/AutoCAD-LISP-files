;-------------------------basu
;------------------
(DEFUN C:RTN()
 (SETVAR "CMDECHO" 0) 
 (SETVAR "BLIPMODE" 0)
 (setq fr(getvar "filletrad"))
 (INITGET 1 "15 30 45 60 75 90 120 135 150 180")
 (SETQ 
  rtrad xrtrad
  rtname(GETKWORD "\n  Select TURN Angle -
         ( 15, 30, 45, 60, 75, 90, 120, 135, 150 or 180 ) : ")
  rtstring(strcat "RT" rtname)
 )
 (PRINC "\n Enter RADIUS of turn < ")
 (princ rtrad)
 (setq rtrad (getdist " > : "))
 (cond ((= rtrad nul) (setq rtrad xrtrad)))
 (setq  xrtrad rtrad)
 
 (command "fillet" "r" rtrad "fillet" pause pause
          "setvar" "filletrad" fr)
   (setq ent(entget (entlast)))
   (setq arcen(cdr (assoc 10 ent))) 
   (setq arstr(rd (cdr (assoc 50 ent))))
   (setq arend(rd (cdr (assoc 51 ent))))
 (if (< arend arstr)
      (setq arang(+ (- 360.0 arstr) arend))
      (setq arang(- arend arstr))
 ) 
 (setq arsp(polar arcen (dr arstr) rtrad))
 (command "erase" "l" "" 
          "insert" rtstring arsp rtrad rtrad (+ 90.0 arstr))
 
 (SETVAR "CMDECHO" 1)
 (princ)
)
;------------------
(DEFUN rRT(rtang rtrad)
 (SETVAR "CMDECHO" 0) 
 (SETVAR "BLIPMODE" 0)
 (setq fr(getvar "filletrad"))
 
 (command "fillet" "r" rtrad "fillet" pause pause
          "setvar" "filletrad" fr)
   (setq ent(entget (entlast)))
   (setq arcen(cdr (assoc 10 ent))) 
   (setq arstr(rd (cdr (assoc 50 ent))))
   (setq arend(rd (cdr (assoc 51 ent))))
 (SETQ rtstring(strcat "RT" (itoa rtang)))
 (setq arsp(polar arcen (dr arstr) rtrad))
 (command "erase" "l" "" 
          "insert" rtstring arsp rtrad rtrad (+ 90.0 arstr))
 
 (SETVAR "CMDECHO" 1)
 (princ)
)
;------------
(defun c:R215() (rRT 15 609.6))
(defun c:R230() (rRT 30 609.6))
(defun c:R245() (rRT 45 609.6))
(defun c:R260() (rRT 60 609.6))
(defun c:R275() (rRT 75 609.6))
(defun c:R290() (rRT 90 609.6))
(defun c:R2120() (rRT 120 609.6))
(defun c:R2135() (rRT 135 609.6))
(defun c:R2150() (rRT 150 609.6))
(defun c:R2180() (rRT 180 609.6))
;--------
(defun c:R315() (rRT 15 914.4))
(defun c:R330() (rRT 30 914.4))
(defun c:R345() (rRT 45 914.4))
(defun c:R360() (rRT 60 914.4))
(defun c:R375() (rRT 75 914.4))
(defun c:R390() (rRT 90 914.4))
(defun c:R3120() (rRT 120 914.4))
(defun c:R3135() (rRT 135 914.4))
(defun c:R3150() (rRT 150 914.4))
(defun c:R3180() (rRT 180 914.4))
;--------------
(textscr)
(princ "\n RTN for roller turns of any radius.. & ")
(princ "\n r215 r230 r245 r260 r275 r290 r2120 r2135 r2150 r2180...for 2ft rad  &")
(princ "\n r315 r330 r345 r360 r375 r390 r3120 r3135 r3150 r3180...for 3ft radius.. Loaded")
(princ)