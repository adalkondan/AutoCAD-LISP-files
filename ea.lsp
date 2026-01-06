(defun C:EA (/  ATT EL OLDVAL DH NEWVAL)
    (while 
     (setq ATT (car (nentsel "\n Select attribute: ")))
	(setq EL (entget ATT))
     (cond 
        ((not (= (cdr (assoc 0 EL)) "ATTRIB"))
 		(princ "\n Object is not an Attribute."
         )
	)
	( 't
		(setq  OLDVAL (cdr (assoc 1 EL))
		           DH (load_dialog "ea")
			)
	(if (and DH (new_dialog "ea" DH))
		(progn
		  (set_tile "att_edit" OLDVAL)
		  (action_tile
			   "att_edit"
			   "(setq newval  $value)"
			)
		(if (= ( start_dialog) 1)
   ;if ok is picked
		(progn	
			(setq EL (subst
					(cons 1 NEWVAL)
					(assoc 1 EL)
							EL
						)
					       )
					(entmod EL)
					(entupd ATT)
						)
					       )
		(unload_dialog  DH)	
		) ;end progn
		(exit)  ;if the DCL file con't be found
		)  ; end if
		)  ; end 'T
	) ; end cond
	) ; end while
        (princ)
    )  ; end c:ea