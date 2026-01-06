;-------------------------basu
;------------------
(DEFUN twT(twname twrad)
 (SETVAR "CMDECHO" 0) 
 (SETVAR "BLIPMODE" 0)
 (setq fr(getvar "filletrad"))
 
 (command "fillet" "r" twrad "fillet" pause pause
          "setvar" "filletrad" fr)
   (setq ent(entget (entlast)))
   (setq arcen(cdr (assoc 10 ent))) 
   (setq arstr(rd (cdr (assoc 50 ent))))
   (setq arend(rd (cdr (assoc 51 ent))))

 (setq arsp(polar arcen (dr arstr) twrad))
 (command "erase" "l" "")
 (command "insert" twname arsp 1 1 (+ 90.0 arstr))
 
 (SETVAR "CMDECHO" 1)
 (princ)
)
;------------
(defun c:T390() (twT 14603 457.2))
(defun c:T3135() (twT 87397 457.2))
(defun c:T3150() (twT 64656 457.2))
(defun c:T3180() (twT 14199 457.2))
;--------------
(defun c:T490() (twT 490 609.6))
(defun c:T4135() (twT 4135 609.6))
(defun c:T4150() (twT 4150 609.6))
(defun c:T4180() (twT 4180 609.6))
;------
(textscr)
(princ "\n")
(princ "\n T390, T3135, T3150, T3180...for 3ft TW Turns. &")
(princ "\n T490, T4135, T4150, T4180....for 4ft TW Turns....Loaded")
(princ)