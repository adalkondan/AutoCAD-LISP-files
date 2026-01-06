; ******************************************************************
;                          CL.LSP

;    By Simon Jones    Autodesk Ltd , London      March 1987

;  This macro constructs a pair of center lines through the
;  center of a circle. The lines are put on a layer "CL".

; ******************************************************************

(defun clerr (s)
   (if (/= s "Function cancelled")   ; If an error (such as CTRL-C) occurs
      (princ (strcat "\nError: " s)) ; while this command is active...
   )
   (command "UCS" "P")               ; Restore previous UCS
   (setvar "BLIPMODE" sblip)         ; Restore saved modes
   (setvar "GRIDMODE" sgrid)
   (setvar "HIGHLIGHT" shl)
   (setvar "UCSFOLLOW" sucsf)
   (command "LAYER" "S" clay "")
   (command "undo" "e")
   (setvar "CMDECHO" scmde)
   (setq *error* olderr)             ; Restore old *error* handler
   (princ)
)

(defun C:CLN (/ olderr clay sblip scmde sgrid shl sucsf e cen rad d ts xx)
   (setq olderr  *error*
         *error* clerr)
   (setq scmde (getvar "CMDECHO"))
   (command "undo" "group")
   (setq clay  (getvar "CLAYER"))
   (setq sblip (getvar "BLIPMODE"))
   (setq sgrid (getvar "GRIDMODE"))
   (setq shl   (getvar "HIGHLIGHT"))
   (setq sucsf (getvar "UCSFOLLOW"))
   (setvar "CMDECHO" 0)
   (setvar "GRIDMODE" 0)
   (setvar "UCSFOLLOW" 0)
   (setq e nil xx "Yes")
   (setq ts (tblsearch "LAYER" "CL"))
   (if (null ts)
       (prompt "\nCreating new layer - CL. ")
       (progn
        (if (= (logand 1 (cdr (assoc 70 ts))) 1)
            (progn
             (prompt "\nLayer CL is frozen. ")
             (initget  "Yes No")
             (setq xx (getkword "\nProceed? <N>: "))
             (if (= xx "Yes")
                 (command "LAYER" "T" "CL" "")
             )
            )
        )
       )
   )
   (if (= xx "Yes")
      (progn
       (while (null e)
          (setq e (entsel "\nSelect arc or circle: "))
          (if e
              (progn
               (setq e (car e))
               (if (and
                     (/= (cdr (assoc 0 (entget e))) "ARC")
                     (/= (cdr (assoc 0 (entget e))) "CIRCLE")
                   )
                   (progn (prompt "\nEntity is a ")
                          (princ (cdr (assoc 0 (entget e))))
                          (setq e nil)
                   )
               )
              )
          )
       )
       (command "UCS" "e" e)
       (setq cen (trans (cdr (assoc 10 (entget e))) e 1))
       (setq rad (cdr (assoc 40 (entget e))))
       (prompt "\nRadius is ")
       (princ (rtos rad))
       (initget 7 "Length")
       (setq d (getdist "\nLength/<Extension>: "))
       (if (= d "Length")
        (progn
         (initget 7)
         (setq d (getdist cen "\nLength: "))
        )
        (setq d (+ rad d))
       )
       (setvar "BLIPMODE" 0)
       (setvar "HIGHLIGHT" 0)
       (command "LAYER" "M" "CL" "C" "252" "" "LT" "CENTER" "" "")
       (command "LINE" (list (car cen) (- (cadr cen) d) (caddr cen))
                       (list (car cen) (+ (cadr cen) d) (caddr cen))
                       ""
       )
       (command "LINE" (list (- (car cen) d) (cadr cen) (caddr cen))
                       (list (+ (car cen) d) (cadr cen) (caddr cen))
                       ""
       )
       (command "LAYER" "S" clay "")
      )
   )
   (command "UCS" "P")               ; Restore previous UCS
   (setvar "BLIPMODE" sblip)         ; Restore saved modes
   (setvar "GRIDMODE" sgrid)
   (setvar "HIGHLIGHT" shl)
   (setvar "UCSFOLLOW" sucsf)
   (command "undo" "e")
   (setvar "CMDECHO" scmde)
   (setq *error* olderr)             ; Restore old *error* handler
   (princ)
)
(princ)
