(define (problem study-plan)
  (:domain planning)

  ;; Objects
  (:objects
    student1 - student
    role-learner - role
    topic1 topic2 topic3 topic4 topic5 - task
    meeting1 - meeting
  )

  ;; Initial State
  (:init
    ;; Assign the role to the student
    (has-role student1 role-learner)

    ;; Assign the roles to tasks (all tasks require the role of 'role-learner')
    (task-role topic1 role-learner)
    (task-role topic2 role-learner)
    (task-role topic3 role-learner)
    (task-role topic4 role-learner)
    (task-role topic5 role-learner)

    ;; All tasks have different lengths (remaining time needed to complete them)
    (= (remaining-time topic1) 10) ;; Topic 1 is harder
    (= (remaining-time topic2) 8)
    (= (remaining-time topic3) 7)
    (= (remaining-time topic4) 6)
    (= (remaining-time topic5) 5)

    ;; Set the priorities for tasks (higher priority = lower number)
    (= (priority topic1) 4) ;; Highest priority since the student struggles
    (= (priority topic2) 1)
    (= (priority topic3) 1)
    (= (priority topic4) 4)
    (= (priority topic5) 5)

    ;; The student's initial available time is 42 days
    (= (available-time student1) 42)

    ;; Set the total time (this can be adjusted or removed depending on usage)
    (= (total-time) 42)

    ;; Meeting role setup (not yet scheduled)
    (meeting-for-role meeting1 role-learner)
    (not (meeting-scheduled meeting1))

    ;; Points start at 0
    (= (points student1) 0)

    ;; Student is available
    (available student1)
  )

  ;; Goal: All tasks (topics) are completed, and the meeting is scheduled
  (:goal (and
    (completed topic1)
    (completed topic2)
    (completed topic3)
    (completed topic4)
    (completed topic5)
    (meeting-scheduled meeting1)
  ))

  ;; Metric: Maximize points (encourages efficiency)
  (:metric maximize (points student1))
)
