(define (domain planning)
  (:requirements :typing :fluents :processes :numeric-fluents)
  (:types student task role)

  ;; Predicates
  (:predicates 
    (has-role ?s - student ?r - role)    ;; Student has a specific role
    (task-role ?t - task ?r - role)      ;; Task requires a specific role
    (assigned ?s - student ?t - task)   ;; Student is assigned to a task
    (completed ?t - task)               ;; Task is completed
  )

  ;; Numeric fluents
  (:functions
    (available-time ?s - student)
    (remaining-time ?t - task)          ;; Time left to complete a task
    (priority ?t - task)
    (total-time)                        ;; Total time to minimize (length of project in days)
  )

  ;; Action: Assign Task to a Student
  (:action assign-task
    :parameters (?s - student ?t - task ?r - role)
    :precondition (and
      (has-role ?s ?r)                  ;; Student has the required role
      (task-role ?t ?r)                 ;; Task requires the role
      (> (remaining-time ?t) 0)         ;; Task has remaining work
      (> (available-time ?s) 0)         ;; Student has remaining time to work
      (forall (?x - task)               ;; Check no higher-priority task is available
        (or
          (= (priority ?x) (priority ?t)) ;; Same priority as current task
          (> (priority ?x) (priority ?t)) ;; Lower priority or already completed
          (completed ?x)                 ;; Task is completed
          (not (> (remaining-time ?x) 0)) ;; No remaining work
        )
      )
      (forall (?x - task) (not (assigned ?s ?x))) ;; Student not already assigned
    )
    :effect (assigned ?s ?t)
  )

  ;; Process: Work on a Task
  (:process work-on-task
    :parameters (?s - student ?t - task)
    :precondition (and
      (assigned ?s ?t)                  ;; Student is assigned to the task
      (> (remaining-time ?t) 0)         ;; Task still has work to do
      (> (available-time ?s) 0)
    )
    :effect (and
      (decrease (remaining-time ?t) (* #t 1.0)) ;; Progress task over time
      (decrease (available-time ?s) (* #t 1.0))
      (decrease (total-time) (* #t 1.0))        ;; Decrease total time
    )
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
