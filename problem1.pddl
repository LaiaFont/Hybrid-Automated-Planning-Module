(define (problem project-instance)
  (:domain project-organization)

  ;; Declare all objects
  (:objects
    student1 student2 student3 - student
    task1 task2 task3 - task
    developer designer manager - role
    time1 time2 time3 time4 time5 - time
  )

  ;; Define time progression (using successor relationships)
  (:init
    (successor time1 time2)
    (successor time2 time3)
    (successor time3 time4)
    (successor time4 time5)
    (final-time time5)

    ;; Define initial availability and roles of students
    (available student1)
    (available student2)
    (available student3)
    (has-role student1 developer)
    (has-role student2 designer)
    (has-role student3 manager)

    ;; Set initial time for each task
    (time-remaining task1 time1)
    (time-remaining task2 time1)
    (time-remaining task3 time1)
  )

  ;; Define the goal state
  (:goal (and 
    (completed task1)
    (completed task2)
    (completed task3)
  ))
)