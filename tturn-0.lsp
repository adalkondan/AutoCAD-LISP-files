;-------------------------basu
;------------------
(DEFUN C:TTN()
 (SETVAR "CMDECHO" 0) 
 (SETVAR "BLIPMODE" 0)
 (setq fr(getvar "filletrad"))
 (INITGET 1 "90 135 150 180")
 (SETQ 
  ttrad xttrad
  ttname(GETKWORD "\n  Select TURN Angle -
         ( 90, 135, 150 or 180 ) : ")
  rtstring(strcat "TT" ttname)
 )
 (PRINC "\n Enter RADIUS of turn < ")
 (princ rtrad)
 (setq ttrad (getdist " > : "))
 (cond ((= ttrad nul) (setq ttrad xttrad)))
 (setq  xttrad ttrad)
 
 (command "fillet" "r" ttrad "fillet" pause pause
          "setvar" "filletrad" fr)
   (setq ent(entget (entlast)))
   (setq arcen(cdr (assoc 10 ent))) 
   (setq arstr(rd (cdr (assoc 50 ent))))
   (setq arend(rd (cdr (assoc 51 ent))))
 (if (< arend arstr)
      (setq arang(+ (- 360.0 arstr) arend))
      (setq arang(- arend arstr))
 ) 
 (setq arsp(polar arcen (dr arstr) ttrad))
 (command "erase" "l" "" 
          "insert" rtstring arsp ttrad ttrad (+ 90.0 arstr))
 
 (SETVAR "CMDECHO" 1)
 (princ)
)

;------------------
(DEFUN c:RT()
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
;------------
(defun c:RT2()
 (SETVAR "CMDECHO" 0) 
 (SETVAR "BLIPMODE" 0)
 (setq fr(getvar "filletrad"))
 (command "fillet" "r" "609.6" "fillet" pause pause
          "setvar" "filletrad" fr)
   (setq ent(entget (entlast)))
   (setq arcen(cdr (assoc 10 ent))) 
   (setq arstr(rd (cdr (assoc 50 ent))))
   (setq arend(rd (cdr (assoc 51 ent))))
 (if (< arend arstr)
      (setq arang(+ (- 360.0 arstr) arend))
      (setq arang(- arend arstr))
 ) 
 (setq arsp(polar arcen (dr arstr) 609.6))
 (setq rtstring(strcat "RT" (itoa (fix arang))))
 (command "erase" "l" "" 
          "insert" rtstring arsp 609.6 609.6 (+ 90.0 arstr))
 (SETVAR "CMDECHO" 1)
 (princ)
)
;------
;-----
(defun c:RT3()
 (SETVAR "CMDECHO" 0) 
 (SETVAR "BLIPMODE" 0)
 (setq fr(getvar "filletrad"))
 (command "fillet" "r" "914.4" "fillet" pause pause
          "setvar" "filletrad" fr)
   (setq ent(entget (entlast)))
   (setq arcen(cdr (assoc 10 ent))) 
   (setq arstr(rd (cdr (assoc 50 ent))))
   (setq arend(rd (cdr (assoc 51 ent))))
 (if (< arend arstr)
      (setq arang(+ (- 360.0 arstr) arend))
      (setq arang(- arend arstr))
 ) 
 (setq arsp(polar arcen (dr arstr) 914.4))
 (setq rtstring(strcat "RT" (itoa (fix arang))))
 (command "erase" "l" "" 
          "insert" rtstring arsp 914.4 914.4 (+ 90.0 arstr))
 (SETVAR "CMDECHO" 1)
 (princ)
)
;------------
(defun c:RT245()
 (SETVAR "CMDECHO" 0) 
 (SETVAR "BLIPMODE" 0)
 (setq fr(getvar "filletrad"))
 (command "fillet" "r" "609.6" "fillet" pause pause
          "setvar" "filletrad" fr)
   (setq ent(entget (entlast)))
   (setq arcen(cdr (assoc 10 ent))) 
   (setq arstr(rd (cdr (assoc 50 ent))))
   (setq arend(rd (cdr (assoc 51 ent))))
 (setq arsp(polar arcen (dr arstr) 609.6))
 (command "erase" "l" "" 
          "insert" "rt45" arsp 609.6 609.6 (+ 90.0 arstr))
 (SETVAR "CMDECHO" 1)
 (princ)
)
;------------
(defun c:RT345()
 (SETVAR "CMDECHO" 0) 
 (SETVAR "BLIPMODE" 0)
 (setq fr(getvar "filletrad"))
 (command "fillet" "r" "914.4" "fillet" pause pause
          "setvar" "filletrad" fr)
   (setq ent(entget (entlast)))
   (setq arcen(cdr (assoc 10 ent))) 
   (setq arstr(rd (cdr (assoc 50 ent))))
   (setq arend(rd (cdr (assoc 51 ent))))
 (setq arsp(polar arcen (dr arstr) 914.4))
 (command "erase" "l" "" 
          "insert" "rt45" arsp 914.4 914.4 (+ 90.0 arstr))
 (SETVAR "CMDECHO" 1)
 (princ)
)

(textscr)
(princ "\n RTN for roller turns of any radius.. & ")
(princ "\n r215 r230 r245 r260 r275 r290 r2120 r2135 r2150 r2180...for 2ft rad  &")
(princ "\n r315 r330 r345 r360 r375 r390 r3120 r3135 r3150 r3180...for 3ft radius.. Loaded")
(princ)