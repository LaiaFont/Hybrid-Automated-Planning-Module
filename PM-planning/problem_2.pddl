(define (problem group-planning)
  (:domain planning)

  ;; Objects
  (:objects
    student1 student2 student3 - student
    design coding research - role
    task1 task2 task3 - task
    meeting1 meeting2 meeting3 - meeting
  )

  ;; Initial state
  (:init
    ;; Roles for students
    (has-role student1 design)
    (has-role student1 coding)
    (has-role student2 research)
    (has-role student3 research)
    (has-role student3 design)

    ;; Task roles
    (task-role task1 design)
    (task-role task2 coding)
    (task-role task3 research)

    ;; Availability and priorities
    (available student1)
    (available student2)
    (available student3)
    (= (available-time student1) 30)
    (= (available-time student2) 30)
    (= (available-time student3) 30)
    (= (priority task1) 1)
    (= (priority task2) 2)
    (= (priority task3) 3)
    (= (remaining-time task1) 10)
    (= (remaining-time task2) 15)
    (= (remaining-time task3) 5)
    (= (total-time) 30)

    ;; Meeting for roles
    (meeting-for-role meeting1 design)
    (meeting-for-role meeting2 coding)
    (meeting-for-role meeting3 research)
  )

  ;; Goal state
  (:goal (and
    (completed task1)
    (completed task2)
    (completed task3)
    (meeting-scheduled meeting1)
    (meeting-scheduled meeting2)
    (meeting-scheduled meeting3)
  ))

  (:metric minimize (total-time))
)
