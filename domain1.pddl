(define
    (domain car_nonlinear_mt_sc)

    (:predicates
        (engine_running)
        (engine_stopped)
    )

    (:functions
        (d)
        (v)
        (a)
        (drag_coefficient)
        (max_acceleration)
        (min_acceleration)
        (max_speed)
    )

    (:constraint speed_limit
        :parameters ()
        :condition (and (>= (v) (* -1 (max_speed))) (<= (v) (max_speed)))
    )

    (:process displacement
        :parameters ()
        :precondition (and (engine_running) (> (v) 0))
        :effect (increase (d) (* #t (v)))
    )

    (:process moving_drag
        :parameters ()
        :precondition (engine_running)
        :effect (and
                    (increase (v)  (* #t (a)) )   ;; velocity changes because of the acceleration
        )
    )
    (:process drag_ahead
        :parameters ()
        :precondition (and (engine_running) (> (v) 0))
        :effect (and
                    (decrease (v)  (* #t (* (^ (v) 2) (drag_coefficient)  ) )  ) 
        )
    )

    (:action accelerate
        :parameters ()
        :precondition (and (< (a) (max_acceleration)) (engine_running) )
        :effect (increase (a) 1.0)  ;;
    )

    (:action stop_car
        :parameters ()
        :precondition (and (> (v) -0.1) (< (v) 0.1) (= (a) 0.0) (engine_running))
        :effect (and
                        (assign (v) 0.0)
                        (engine_stopped)
                        (not (engine_running))
                )

    )

    (:action start_car
        :parameters ()
        :precondition (engine_stopped)
        :effect (and
                    (engine_running)
                    (not (engine_stopped))
                )
    )


    (:action decelerate
        :parameters ()
        :precondition (and (> (a) (min_acceleration)) (engine_running))
        :effect (decrease (a) 1.0) ;;
    )
)