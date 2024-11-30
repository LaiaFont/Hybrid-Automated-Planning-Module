(define (problem project-plan)
  (:domain planning-v2)

  (:objects
    student1 student2 student3 - student
    coding1 coding2 - task
    design1 design2 - task
    research1 research2 - task
    developer designer researcher - role
    dev-meeting1 dev-meeting2 - meeting
    team-meeting1 - meeting
  )

  (:init
    ;; Student roles
    (has-role student1 developer)
    (has-role student3 developer)
    (has-role student2 designer)
    (has-role student2 researcher)
    (has-role student3 researcher)

    (not (available student1))
    (not (available student2))
    (not (available student3))

    (= (available-time student1) 5)
    (= (available-time student2) 8)
    (= (available-time student3) 10)

    (= (points student1) 0)
    (= (points student2) 0)
    (= (points student3) 0)

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
    (= (remaining-time research1) 7)
    (= (remaining-time research2) 7)

    ;; Task priorities
    (= (priority coding1) 3) ;; Highest priority
    (= (priority coding2) 4)
    (= (priority design1) 2)
    (= (priority design2) 3)
    (= (priority research1) 1)
    (= (priority research2) 1)

    ;; Initialize total time (arbitrarily high value for minimization)
    (= (total-time) 60)

    (= (completed-task-count) 0)
  )

  (:goal
    (and
      (completed coding1)
      (completed coding2)
      (completed design1)
      (completed design2)
      (completed research1)
      (completed research2)
      (meeting-scheduled dev-meeting1)
      (meeting-scheduled dev-meeting2)
      (meeting-scheduled team-meeting1)
    )
  )

 
  (:metric minimize (total-time))
)
