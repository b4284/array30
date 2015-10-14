(use-modules (ice-9 rdelim)
             (ice-9 format)
             (srfi srfi-1))

(define (input/output rp wp current-sector translator)
  (let ((line (read-line rp 'trim)))
    (if (not (eof-object? line))
        (cond
         ((string-prefix? "%" line)
          (write-line line wp)
          (input/output rp wp (substring (car (string-split line #\space)) 1)
                        translator))
         ((string-prefix? "#" line)
          (write-line line wp)
          (input/output rp wp current-sector translator))
         ((and (member current-sector '("keyname" "quick" "chardef"))
               (string-index line #\tab))
          (let ((pair (string-split line #\tab)))
            (format wp "~a\t~a\n" (translator (first pair)) (second pair)))
          (input/output rp wp current-sector translator))
         (else
          (write-line line wp)
          (input/output rp wp current-sector translator))))))

(define (make-translator org new)
  (let ((cm (zip (string->list org) (string->list new))))
    (lambda (s)
      (list->string
       (map
        (lambda (c)
          (let ((tc (assv-ref cm c)))
            (if tc (car tc) c)))
        (string->list s))))))

(define (main args)
  (call-with-input-file (second args)
    (lambda (rp)
      (call-with-output-file (third args)
        (lambda (wp)
          (input/output rp wp "" (make-translator (fourth args)
                                                  (fifth args))))))))
                
             
