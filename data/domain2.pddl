(define (domain planning)
  (:requirements :typing :fluents :processes :numeric-fluents)
  (:types student task role)

  ;; Predicates
  (:predicates 
    (has-role ?s - student ?r - role)    ;; Student has a specific role
    (task-role ?t - task ?r - role)      ;; Task requires a specific role
    (assigned ?s - student ?t - task)   ;; Student is assigned to a task
    (completed ?t - task)               ;; Task is completed
    (available ?s - student)            ;; Student is available for a new task
  )

  ;; Numeric fluents
  (:functions
    (remaining-time ?t - task)  
    (priority ?t - task) ;; Add a priority fluent to balance task scheduling
    (total-workload ?s - student) ;; Track workload assigned to each student    
  )

  ;; Instantaneous action to start a task
  (:action start-task
    :parameters (?s - student ?t - task ?r - role)
    :precondition (and 
      (available ?s)
      (task-role ?t ?r)
      (has-role ?s ?r)
      (> (remaining-time ?t) 0)
    )
    
    :effect (and
      (assigned ?s ?t)
      (not (available ?s))
      (increase (total-workload ?s) (priority ?t)) ;; Track workload based on priority
    )
  )

  ;; Assign task to student
  (:action assign-task
    :parameters (?s - student ?t - task ?r - role)
    :precondition (and
      (not (assigned ?s ?t))
      (has-role ?s ?r)
      (task-role ?t ?r)
      (> (remaining-time ?t) 0)
    )
    :effect (assigned ?s ?t)
  )


  ;; Process to work on a task
  (:process work-on-task
    :parameters (?s - student ?t - task)
    :precondition (and
      (assigned ?s ?t) ;; Only start work if the student is assigned
      (> (remaining-time ?t) 0)
    )
    :effect (and
      (decrease (remaining-time ?t) (* #t 1.0)) ;; Reduce remaining time
      (when (= (remaining-time ?t) 0) (completed ?t)) ;; Mark task as completed
    )
  )


  ;; Instantaneous action to finish a task
  (:action finish-task
    :parameters (?s - student ?t - task)
    :precondition (and 
      (assigned ?s ?t)                  ;; Student must be assigned to the task
      (<= (remaining-time ?t) 0)        ;; Task must have no remaining time
    )
    :effect (and
      (completed ?t)                    ;; Task is marked completed
      (not (assigned ?s ?t))            ;; Student is unassigned from the task
      (available ?s)                    ;; Student becomes available again
    )
  )
)
