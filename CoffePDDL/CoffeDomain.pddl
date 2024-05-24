
(define (domain CoffeDomain)

    (:requirements 
    :strips 
    :typing 
    :negative-preconditions
    :disjunctive-preconditions 
    )


    ;TYPES
    (:types
        sensor
        agent

        location
        container

        ingredient
    )


    ;PREDICATES
    (:predicates
        (MapCalibrated) ;robot has calibrated kitchen map
        (activated ?s - sensor) ;robot has activited sensors


        ;AGENT
        (free ?a - agent)   ;agent is free
        (atLocation ?a - agent ?l - location) ;agent is at location
        (blocked)   ;this precondition blocks some essential action such as move



        ;Location
        (open_l ?l - location)  ;location/closet is open
        (isTable ?l - location);location is a table
        (isFridge ?l - location);location is a fridge
        
        (isSink ?l - location);location is a sink
        (isTapTurnedOn);tap is a turned on

        (isStovetop ?l - location) ;location is stovetop
        (isStovetopOn) ;stovetop is on




        ;Container
        (open_c ?c - container) ;container is open
        (container_in ?c - container ?l - location) ;container ?c is in location ?l
        (unpickupable ?c - container) ;container is unpickable
        (containerOnContainer ?c1 ?c2 - container);container is on container

        (IsPossibleToMove ?c - container ?l - location);robot can move container ?c to location ?l
        
        (isInputContainer ?c - container);it is possible to insert ingredients inside the container ?c
                
        (hold ?a - agent ?c - container) ;agent is holding a container
        
        (isReady ?c - container) ;container is ready (necessary before doing some actions)


        ;moka        
        (isBottMoka ?c - container)  ;container is the bottom of the moka
        (isFilterMoka ?c - container) ;container is the filter of the moka     
        (isTopMoka ?c - container)  ;container is the top of the moka
        (isMoka ?c - container)  ;container is the moka
        (isMokaPart ?c - container) ;container is a moka part
        (mokaPotAfterPot ?c1 ?c2 - container)

        ;spoon
        (isSpoon ?c - container) ;container is a spoon
        (isCoffeSpoon ?c - container) ;container is the coffeSpoon

        ;cups
        (isCup ?c - container)  ;container is a cup


        ;ingredient
        (ingredient_in ?i - ingredient ?c - container) ;ingredient is in container
        (waterFilled) ;bottom moka is filled with water
        (isWater ?i - ingredient) ;ingredient is water
        (distribuitedCoffe  ?i - ingredient) ;the grounded coffe is distribuited on filter
        (levelledCoffe  ?i - ingredient) ;the grounded coffe is levelled on filter

        (isLiquid ?i - ingredient) ;ingredient is a liquid
        
        


        ;coffe
        (isCoffe ?i - ingredient) ;ingredient is coffe
        (grounded ?i - ingredient) ;ingredient is grounded
        (isCoffeReady) ;coffe is ready
        (boiled) ;is coffe boiled


        ;grinder
        (isGrinder ?c - container) ;container is grinder
        (grinderOn) ;is grinder on
                

        
    )


;ACTIONS
    
    ;activate sensors
    (:action activateSensors 
        :parameters (?s - sensor)
        :precondition (and
            (not(activated ?s))
        )
        :effect (and
            (activated ?s)
        )
    )
    
    ;calibrate the kitchen map
    (:action calibrateMap
        :parameters (?s - sensor)
        :precondition (and
            (not(MapCalibrated)) 
            (activated ?s)
        )
        :effect (and
            (MapCalibrated)
        )
    )


    

    ;agent move from to a location
    (:action moveToLocation 
        :parameters (?a - agent ?from_loc ?to_loc - location)
        :precondition (and
            (MapCalibrated)
            (atLocation ?a ?from_loc)
            (not(blocked))

            ;cannot go to the fridge if the coffe is not ready
            (or (not(isFridge ?to_loc))(isCoffeReady))
        )
        
        :effect (and
            (atLocation ?a ?to_loc)
            (not(atLocation ?a ?from_loc))
        )
    )



    
    ;open a closet
    (:action open_closet 
        :parameters (?a - agent ?l - location)
        :precondition (and
            (MapCalibrated)
            (not(blocked ))

            (free ?a)

            (not(open_l ?l))
            (atLocation ?a ?l)
        )
        :effect (and
            (open_l ?l)
        )
    )
    
    
    
    ;close a closet
    (:action close_closet ; this action is only for picking from table
        :parameters (?a - agent ?l - location)
        :precondition (and
            (MapCalibrated)
            (not(blocked ))

            (free ?a)
            (open_l ?l)
            (atLocation ?a ?l)

            ;they cannot be closed
            (not(isTable ?l))
            (not(isStovetop ?l))
            (not(isSink ?l))

            ;before closing closets, robot must prepare coffe
            (isCoffeReady)
        )
        :effect (and
            (not(open_l ?l))
        )
    )
    

    
    ;open a container
    (:action open_container ; this action is only for picking from table
        :parameters (?a - agent ?c - container ?l - location)
        :precondition (and
            (MapCalibrated)
            (not(blocked ))

            (free ?a)

            (not(open_c ?c))
            (open_l ?l)
            (isTable ?l)

            (atLocation ?a ?l)
            (container_in ?c ?l)
            
            (not(isMoka ?c))
            (not(isMokaPart ?c))

            ;before opening grinder, fill bottom moka with water
            (or (not(isGrinder ?c))(waterFilled))

        )
        :effect (and
            (open_c ?c)
        )
    )
    
    
    
    ;close a container
    (:action close_container ; this action is only for picking from table
        :parameters (?a - agent ?c - container ?l - location)
        :precondition (and
            (MapCalibrated)
            (not(blocked ))

            (free ?a)
            (open_c ?c)

            (atLocation ?a ?l)
            (container_in ?c ?l)

            (isTable ?l)

            ;they cannot be closed
            (not(isMoka ?c))
            (not(isMokaPart ?c))
            (not(isCup ?c))
            (not(isSpoon ?c))

        )
        :effect (and
            (not(open_c ?c))
        )
    )

    
    ;pickup a container
    (:action pickup
        :parameters (?a - agent ?l - location ?c - container)
        :precondition (and
            (MapCalibrated)
            (not(blocked))

            (free ?a)
            (not(hold ?a ?c))
            (open_l ?l)

            (atLocation ?a ?l)
            (container_in ?c ?l)

            (not(unpickupable ?c))

            ;the containers have different preconditions
            (or
                (and (not(isMoka ?c)) (not(isCup ?c))) ; pickup general container
                (and (isMoka ?c) (not(isCup ?c)) (not(open_c ?c))) ;pickup moka
                (and (isCup ?c) (isCoffeReady) ) ; pickup cup
            )

        )
        :effect (and
            (not(container_in ?c ?l))

            (not(free ?a))
            (hold ?a ?c)
        )
    )


    ;putdown a container
    (:action putdown
        :parameters (?a - agent ?c - container ?l - location)
        :precondition (and
            (MapCalibrated)

            (hold ?a ?c)
            (not (free ?a))

            (atLocation ?a ?l)            
            (not(container_in ?c ?l))
            (open_l ?l)
            
            (IsPossibleToMove ?c ?l)
        )
        :effect (and
            (not (hold ?a ?c))
            (free ?a)
            (container_in ?c ?l)
        )
    )
    

    
    ;pour ingredient from container to container
    (:action pourIngredient
        :parameters (?a - agent ?cFrom ?cTo - container ?i - ingredient ?l - location)
        :precondition (and
            (MapCalibrated)  

            (not(grounded ?i))
            (not(isLiquid ?i))
            
            (isTable ?l)

            (atLocation ?a ?l)
            (container_in ?cTo ?l)

            (open_c ?cFrom)
            (open_c ?cTo)
            
            (ingredient_in ?i ?cFrom)
            
            (hold ?a ?cFrom)
            (not (free ?a))

            (not(isBottMoka ?cTo))
            (not(isFilterMoka ?cTo))
            (not(isTopMoka ?cTo))
            (not(isMoka ?cTo))
            
            (isInputContainer ?cTo)
        )

        :effect (and
            (not (ingredient_in ?i ?cFrom))
            (ingredient_in ?i ?cTo)
            
        )
    )



 

    ; Switch on the grinder
    (:action switchOnGrinder 
        :parameters (?a - agent ?c - ingredient ?gr - container ?t - location)
        :precondition (and
            (MapCalibrated)

            (not(grounded ?c))
            (isCoffe ?c)
            (ingredient_in ?c ?gr)
            

            (isTable ?t)
            (atLocation ?a ?t)
            (free ?a)

            (isGrinder ?gr)
            (not(grinderOn))

            (not (open_c ?gr))
            
            (container_in ?gr ?t)
            (not(blocked ))
        )
        :effect (and
            (grinderOn)
            (blocked )
        )
    )
    

    ;grind
    (:action grind 
        :parameters (?c - ingredient ?gr - container ?t - location)
        :precondition (and
            (MapCalibrated)
            (isCoffe ?c)
            (not(grounded ?c))
            (ingredient_in ?c ?gr)
            (isGrinder ?gr)
            (grinderOn )

            (isTable ?t)
            
            (container_in ?gr ?t)

            
            (blocked )
            
        )
        :effect (and
            
            (grounded ?c)         
        )
    )

    ;after grind, switch off the grinder
    (:action switchOffGrinder ; this action is only for picking from table
        :parameters (?a - agent ?c - ingredient ?gr  - container ?t - location)
        :precondition (and
            (MapCalibrated)
            (isCoffe ?c)

            (free ?a)
            (isTable ?t)
            (atLocation ?a ?t)

            (ingredient_in ?c ?gr)
            (isGrinder ?gr)
            (grinderOn)
            (container_in ?gr ?t)
            
            (blocked )
        )
        :effect (and
            (not(grinderOn))
            
            (not(blocked ))

        )
    )


    
    ;unscrew the moka, on the table
    (:action unscrew_moka 
        :parameters (?a - agent ?moka ?bot ?fil ?top - container ?t - location)
        :precondition (and
            (MapCalibrated)

            (isMoka ?moka)
            (isTable ?t)

            (isBottMoka ?bot)
            (isFilterMoka ?fil)
            (isTopMoka ?top)
            
            (container_in ?moka ?t)
            (atLocation ?a ?t)
                   
            (free ?a)
            (not(open_c ?moka))
        
        )
        :effect (and

            (open_c ?moka)

            (container_in ?bot ?t)
            (container_in ?fil ?t)
            (container_in ?top ?t)
            
            (open_c ?bot)
            (open_c ?fil)

            (not (unpickupable ?bot))
            (not (unpickupable ?fil))
            (not (unpickupable ?top))
            
            (not(isReady ?moka))
        )
    )
    

    
    ;turn on the tao
    (:action turnOnTap 
        :parameters (?a - agent ?bot - container ?l - location )
        :precondition (and
            (MapCalibrated)

            (not(blocked))
            (not (waterFilled))

            (free ?a)

            (isBottMoka ?bot)

            (container_in ?bot ?l)
            (atLocation ?a ?l)

            (isSink ?l)

            
        )
        :effect (and
            (isTapTurnedOn)
            (blocked)
        )
    )





    ;with tap turned on, fill water
    (:action fillWater
        :parameters (?a - agent ?bot - container ?l - location ?i - ingredient)
        :precondition (and
            (MapCalibrated)
            
            (blocked)

            (free ?a)

            (isBottMoka ?bot)

            (container_in ?bot ?l)
            (atLocation ?a ?l)

            (isSink ?l)

            (isWater ?i)
            
        )
        :effect (and
            (ingredient_in ?i ?bot)
            (waterFilled)
        )
    )




    
    ;turn off the tap
    (:action turnOffTap 
        :parameters (?a - agent ?bot - container ?l - location )
        :precondition (and
            (MapCalibrated)

            (blocked)
            (waterFilled)

            (free ?a)

            (isBottMoka ?bot)

            (container_in ?bot ?l)
            (atLocation ?a ?l)

            (isSink ?l)
            
        )
        :effect (and
            (not(isTapTurnedOn))
            (not(blocked))

            (isReady ?bot)
        )
    )




    
    ;with agent holding a spoon, take a spoon of grounded ingredient from container
    (:action takeSpoonIngr
        :parameters (?a - agent ?cFrom ?spoon - container ?i - ingredient ?l - location)
        :precondition (and
            (MapCalibrated)

            (grounded ?i)

            (hold ?a ?spoon)
            (isSpoon ?spoon)

            (container_in ?cFrom ?l)
            (isTable ?l)

            (ingredient_in ?i ?cFrom)
            
            (atLocation ?a ?l)

            (open_c ?cFrom)
            
            (not(isMokaPart ?cFrom))
            (not(isSpoon ?cFrom))
        )
        :effect (and
            (ingredient_in ?i ?spoon)
            (blocked)           
        )
    )



    
    
    ;pour grounded ingredient from spoon to container
    (:action pourGroundIngr 
        :parameters (?a - agent ?spoon ?cTo - container ?i - ingredient ?l - location)
        :precondition (and
            (MapCalibrated)

            (grounded ?i)
            (not(isLiquid ?i))
            (isTable ?l)
            
            (isSpoon ?spoon)
            (not (isMoka ?cTo))
            

            (hold ?a ?spoon)
            (not (free ?a))

            (atLocation ?a ?l)
            (container_in ?cTo ?l)

            (ingredient_in ?i ?spoon)

            (open_c ?spoon)
            (open_c ?cTo)
            
            (not(isBottMoka ?cTo))
            (not(isTopMoka ?cTo))

            (waterFilled) 

            (isInputContainer ?cTo)
            
        )
        :effect (and
            (ingredient_in ?i ?cTo)
            (not (ingredient_in ?i ?spoon))
            (not(blocked))

        )
    )





    ;level grounded coffe
    (:action levelCoffe 
        :parameters (?a - agent ?fil ?spoon - container ?i - ingredient ?l - location)
        :precondition (and
            (MapCalibrated)
            
            (not(levelledCoffe ?i))

            (grounded ?i)
            (isCoffe ?i)
            (isCoffeSpoon ?spoon)

            (hold ?a ?spoon)
            (not (free ?a))

            (isSpoon ?spoon)
            (isFilterMoka ?fil)
            ;(isTopMoka ?top)

            ;(container_in ?top ?l)

            (container_in ?fil ?l)
            (isTable ?l)

            (ingredient_in ?i ?fil)
            
            (atLocation ?a ?l)

            (open_c ?fil)
            (distribuitedCoffe  ?i)
            
                        
        )
        :effect (and
        
            (not(blocked))

            (levelledCoffe ?i)
            (isReady ?fil)
            (unpickupable ?spoon)
        )
    )

    
    
    ;distribuite coffe
    (:action distribuiteCoffe 
        :parameters (?a - agent  ?bot ?fil ?spoon - container ?i - ingredient ?l - location)
        :precondition (and
            (MapCalibrated)

            (isTable ?l)

            (grounded ?i)
            (isCoffe ?i)

            (isCoffeSpoon ?spoon)
            (isSpoon ?spoon)
            (hold ?a ?spoon)

            (isFilterMoka ?fil)
            (isBottMoka ?bot)
            (open_c ?fil)

            (container_in ?fil ?l)
            (containerOnContainer ?fil ?bot)
            (ingredient_in ?i ?fil)
            
            (atLocation ?a ?l)            
        )
        :effect (and

            (distribuitedCoffe ?i)
            (blocked)
        )
    )

    
    ;put moka part on moka part
    (:action putMokaPartOnMokaPart 
        :parameters (?a - agent  ?c2 ?c1 - container ?t - location )
        :precondition (and
            (MapCalibrated)

            (hold ?a ?c2)
            (not (free ?a))
            
            (mokaPotAfterPot ?c2 ?c1)
            
            (isMokaPart ?c1)
            (isMokaPart ?c2)

            (isReady ?c1)

            (isTable ?t)

            (container_in ?c1 ?t)

            (not(isCoffeReady))

            (atLocation ?a ?t)
        )
        :effect (and
            (not (hold ?a ?c2))
            (free ?a)

            (containerOnContainer ?c2 ?c1)
            (container_in ?c2 ?t)
        )
    )


    ;screw the moka
    (:action screw_moka 
        :parameters (?a - agent ?moka ?bot ?fil ?top - container ?i - ingredient ?t - location)
        :precondition (and
            (MapCalibrated)

            (isMoka ?moka)
            (isTable ?t)

            (isCoffe ?i)
            (levelledCoffe  ?i)

            (container_in ?moka ?t)
            (container_in ?bot ?t)

            (containerOnContainer ?fil ?bot)
            (containerOnContainer ?top ?fil)

            (isBottMoka ?bot)
            (isFilterMoka ?fil)
            (isTopMoka ?top)

            (free ?a)

            (atLocation ?a ?t)

            (open_c ?moka)
            
            (not (unpickupable ?bot))
            (not (unpickupable ?fil))
            (not (unpickupable ?top))

            (not(isCoffeReady))
        
        )
        :effect (and
            (not(open_c ?moka))

            (not(container_in ?bot ?t))
            (not(container_in ?fil ?t))
            (not(container_in ?top ?t))
            
            (not (open_c ?bot))
            (not (open_c ?fil))

            (unpickupable ?bot)
            (unpickupable ?fil)
            (unpickupable ?top)

            (isReady ?moka)

        )
    )
    
    


    ;switch on the stovetop
    (:action switchOnStovetop
        :parameters (?a - agent ?c - container ?l - location)
        :precondition (and

            (not (isStovetopOn))

            (isStovetop ?l)
            (atLocation ?a ?l)

            (free ?a)
            
            (isMoka ?c)
            (isReady ?c)

            (container_in ?c ?l)
        )
        :effect (and
            (isStovetopOn)

            (blocked)
        )
    )





    ;boil coffe
    (:action boil 
        :parameters (?i ?i_liquid - ingredient ?c ?c1 - container ?l - location)
        :precondition (and

            (isCoffe ?i)
            (isCoffe ?i_liquid)
            (isLiquid ?i_liquid)
            
            (isMoka ?c)
            (isTopMoka ?c1)
            (isStovetop ?l)

            (isStovetopOn)
            (isReady ?c)
            
            (container_in ?c ?l)
            (not (open_c ?c))         
            
        )
        :effect (and       
            (ingredient_in ?i_liquid ?c1)
            (boiled)
        )
    )

    ;switch off the stovetop
    (:action switchOffStovetop
        :parameters (?a - agent ?i - ingredient ?c - container?l - location)
        :precondition (and

            (isStovetopOn)
            (isStovetop ?l)
            (atLocation ?a ?l)
            
            (blocked)
            
            (isMoka ?c)
            (isCoffe ?i)

            (free ?a)
            
            (not (open_c ?c))    
            (container_in ?c ?l)
            
            (boiled)

        )
        :effect (and
            (not (isStovetopOn))
            (isCoffeReady)
            (not (blocked))

        )
    )


    

    
    ;pour liquid ingredient from container to a cup
    (:action pourLiquidIngredient 
        :parameters (?a - agent ?cFrom ?cTo - container ?i - ingredient ?l - location)
        :precondition (and
            (MapCalibrated)
            
            (isCoffeReady)     
            
            (isLiquid ?i)            
            (isTable ?l)

            (atLocation ?a ?l)
            (container_in ?cTo ?l)

            (open_c ?cFrom)
            (open_c ?cTo)
            
            (ingredient_in ?i ?cFrom)
            
            (hold ?a ?cFrom)
            (not (free ?a))
            
            (not(isCup ?cFrom))
            (isCup ?cTo)

            (isInputContainer ?cTo)

            (not (exists (?c - container ?l - location) 
               (and (isCup ?c) (isTable ?l) (not(container_in ?c ?l)))            
            ))
            
        )

        :effect (and
            (ingredient_in ?i ?cTo)
            (unpickupable ?cTo)
        )
    )




)