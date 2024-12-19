(define (problem web-page-project)
  (:domain planning)

  ;; Objects
  (:objects
    student1 student2 student3 student4 student5 - student
    coding design research - role
    task1 task2 task3 task4 task5 task6 - task
    meeting1 meeting2 meeting3 - meeting
  )

  ;; Initial state
  (:init
    ;; Roles for students
    (has-role student1 coding)
    (has-role student2 coding)
    (has-role student3 coding)
    (has-role student4 design)
    (has-role student5 research)
    (has-role student4 research)

    ;; Task roles
    (task-role task1 coding) ;; Create website backend
    (task-role task2 coding) ;; Develop frontend
    (task-role task3 design) ;; Create wireframes
    (task-role task4 design) ;; Design assets
    (task-role task5 research) ;; Research target audience
    (task-role task6 research) ;; Analyze competitor websites

    ;; Availability
    (available student1)
    (available student2)
    (available student3)
    (available student4)
    (available student5)

    ;; Numeric fluents
    (= (available-time student1) 30) ;; Student 1 can work full time
    (= (available-time student2) 30) ;; Student 2 can work full time
    (= (available-time student3) 15) ;; Student 3 has limited availability
    (= (available-time student4) 10) ;; Student 4 is less motivated
    (= (available-time student5) 10) ;; Student 5 is less motivated

    ;; Task priorities and durations
    (= (priority task1) 1)
    (= (priority task2) 2)
    (= (priority task3) 3)
    (= (priority task4) 4)
    (= (priority task5) 5)
    (= (priority task6) 6)
    (= (remaining-time task1) 10) ;; Estimated time for backend
    (= (remaining-time task2) 15) ;; Estimated time for frontend
    (= (remaining-time task3) 5)  ;; Estimated time for wireframes
    (= (remaining-time task4) 5)  ;; Estimated time for design assets
    (= (remaining-time task5) 5)  ;; Estimated time for research target audience
    (= (remaining-time task6) 5)  ;; Estimated time for competitor analysis
    (= (total-time) 30)

    ;; Meetings
    (meeting-for-role meeting1 research)
    (meeting-for-role meeting2 coding)
    (meeting-for-role meeting3 design)
  )

  ;; Goal state
  (:goal (and
    ;; All tasks completed
    (completed task1)
    (completed task2)
    (completed task3)
    (completed task4)
    (completed task5)
    (completed task6)

    ;; Meetings scheduled
    (meeting-scheduled meeting1)
    (meeting-scheduled meeting2)
    (meeting-scheduled meeting3)
  ))
)
