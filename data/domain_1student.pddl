(define (domain simple-planning)
  (:requirements :typing :fluents :processes :numeric-fluents)
  (:types student task role)

  ;; Predicates
  (:predicates 
    (assigned ?s - student ?t - task)  ;; Indicates a student is assigned to a task
    (completed ?t - task)             ;; Indicates a task is completed
    
  )

  ;; Numeric fluents
  (:functions
    (remaining-time ?t - task)        ;; Remaining time to complete a task
  )

  ;; Action: Assign Task
  (:action assign-task
    :parameters (?s - student ?t - task)
    :precondition (and
      (not (assigned ?s ?t))          ;; Student not already assigned to this task
      (> (remaining-time ?t) 0)       ;; Task must have remaining time
    )
    :effect (assigned ?s ?t)          ;; Assign the student to the task
  )

  ;; Process: Work on Task
  (:process work-on-task
    :parameters (?s - student ?t - task)
    :precondition (and
        (assigned ?s ?t)                ;; Student is assigned to the task
        (> (remaining-time ?t) 0)       ;; Task has remaining time
    )
    :effect (decrease (remaining-time ?t) (* #t 1.0)) ;; Reduce remaining time
    )
  (:action complete-task
    :parameters (?s - student ?t - task)
    :precondition (and
        (assigned ?s ?t)
        (= (remaining-time ?t) 0)       ;; Task must be complete
    )
    :effect (and
        (completed ?t)                  ;; Mark task as completed
        (not (assigned ?s ?t))          ;; Unassign the student
    )
    )


)
