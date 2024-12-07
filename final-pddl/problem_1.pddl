(define (problem plan1)
  (:domain planning)

  (:objects
    student1 student2 student3 - student
    coding1 coding2 - task
    design1 design2 - task
    research1 research2 - task
    developer designer researcher - role
    dev-meeting - meeting
    design-meeting - meeting
    research-meeting - meeting
  )

  (:init
    ;; Student roles
    (has-role student1 developer)
    (has-role student3 developer)
    (has-role student2 designer)
    (has-role student2 researcher)
    (has-role student3 researcher)

    ;; Students are initially available
    (available student1)
    (available student2)
    (available student3)

    ;; Available time for each student
    (= (available-time student1) 6)
    (= (available-time student2) 8)
    (= (available-time student3) 10)

    ;; Task roles
    (task-role coding1 developer)
    (task-role coding2 developer)
    (task-role design1 designer)
    (task-role design2 designer)
    (task-role research1 researcher)
    (task-role research2 researcher)

    ;; Task durations
    (= (remaining-time coding1) 2)
    (= (remaining-time coding2) 2)
    (= (remaining-time design1) 1)
    (= (remaining-time design2) 1)
    (= (remaining-time research1) 4)
    (= (remaining-time research2) 4)

    ;; Task priorities
    (= (priority coding1) 3)
    (= (priority coding2) 4)
    (= (priority design1) 2)
    (= (priority design2) 3)
    (= (priority research1) 1)
    (= (priority research2) 1)

    ;; Points are initially 0
    (= (points student1) 0)
    (= (points student2) 0)
    (= (points student3) 0)

    ;; Meetings are initially unscheduled
    (not (meeting-scheduled dev-meeting))
    (not (meeting-scheduled design-meeting))
    (not (meeting-scheduled research-meeting))

    ;; Assign meetings to roles
    (meeting-for-role dev-meeting developer)
    (meeting-for-role design-meeting designer)
    (meeting-for-role research-meeting researcher)

    ;; Initialize total time
    (= (total-time) 60)
  )

  (:goal
    (and
      (completed coding1)
      (completed coding2)
      (completed design1)
      (completed design2)
      (completed research1)
      (completed research2)
      (meeting-scheduled dev-meeting)
      (meeting-scheduled design-meeting)
      (meeting-scheduled research-meeting)
      (>= (points student1) 10)
      (>= (points student2) 15)
      (>= (points student3) 10)
    )
  )

  (:metric minimize (total-time))
)
