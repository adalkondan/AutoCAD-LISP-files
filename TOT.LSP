; to ADD THE TEXT Nos.   - jan-1993 -Basu.
;--------------------------------------------------------------
(defun myerror (s)
   (if (/= s "Function cancelled")  
      (princ (strcat "\nError: " s))
   )
   (setq p nil)                     
   (setvar "cmdecho" 0) 
   (setq *error* olderr)            
   (princ)
)
(DEFUN C:TOT (/ chm d p l en pl a b c d)
   (setq 
   olderr  *error*
       *error* myerror
         	   chm  0
			   d    0)
   (setq p (ssget))
   (if p 
     (progn (setq l 0  n (sslength p))
        (while (< l n)
            (setq en (cdr (assoc 0 (setq pl (entget (ssname p l))))))
			(cond ((= en "TEXT") 
                   (progn
				    (setq a (assoc 1 pl)
                          b (cdr a)
					      c (atof b)
					      d (+ d c)
					)
				    (cond ((/= c 0.0) (setq chm(1+ chm)))) 
				   ) 
				  )
		    ) (setq l (1+ l))
	     ) 
      )
   )
   (setq *error* olderr)
   (setvar "cmdecho" 1) 
   (princ "\n  ")
   (princ chm) (princ " items")
   (princ "\n Total = ") (princ d) 
   (princ)
)
