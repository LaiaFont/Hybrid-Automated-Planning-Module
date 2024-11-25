(define (problem simple-project-plan)
  (:domain simple-planning)

  (:objects
    student1 - student
    task1 - task
  )

  (:init
    ;; Task duration
    (= (remaining-time task1) 2)   ;; Task requires 2 units of time
  )

  (:goal
    (completed task1)              ;; The goal is to complete the task
  )
)
