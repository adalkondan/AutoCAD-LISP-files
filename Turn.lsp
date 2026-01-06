;-----------------------basu
(defun c:turn()
 (SETVAR "CMDECHO" 0) 
 (SETVAR "BLIPMODE" 0)
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
 (setq sp (getpoint "\n pick POINT to insert..."))
 (princ "\n Rotation angle....<0> ") 
 (command "insert" rtstring sp rtrad rtrad pause)
 (princ)
)

