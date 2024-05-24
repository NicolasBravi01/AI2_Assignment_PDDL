
(define (problem CoffeProblem)(:domain CoffeDomain)

(:objects
    sens - sensor
    a - agent

    closetFood table closetPlates sink stovetop fridge - location
    coffeCont sugarCont grinder moka bottMoka filterMoka topMoka coffeSpoon sugarSpoon cup1 cup2 milkBottle - container

    liquidCoffe coffe water milk sugar - ingredient
    
)

(:init
    ;AGENT
    (free a)
    (atLocation a table)
    

    ;LOC/CONT
    (isTable table)
    (open_l table)
    (isSink sink)
    (open_l sink)
    (isFridge fridge)


    ;CONT
    (container_in coffeCont closetFood)
    (container_in sugarCont closetFood)
    (container_in grinder table)

    (container_in moka closetPlates)
    (container_in cup1 closetPlates)
    (container_in cup2 closetPlates)
    (open_c cup1) (open_c cup2)

    
    (isInputContainer cup1)
    (isInputContainer cup2)
    (isInputContainer filterMoka)
    (isInputContainer grinder)    



    ;robot can move container ?c to location ?l
    (IsPossibleToMove milkBottle table)
    
    (IsPossibleToMove coffeCont table)
    (IsPossibleToMove sugarCont table)

    (IsPossibleToMove moka stovetop)
    (IsPossibleToMove moka table)

    (IsPossibleToMove bottMoka sink)
    (IsPossibleToMove bottMoka table)
    (IsPossibleToMove filterMoka table)
    (IsPossibleToMove topMoka table)

    (IsPossibleToMove coffeSpoon table)
    (IsPossibleToMove sugarSpoon table)
    
    (IsPossibleToMove cup1 table)
    (IsPossibleToMove cup2 table)




    ;ingredient
    (ingredient_in coffe coffeCont)
    (ingredient_in sugar sugarCont)
    (grounded sugar)
    (isWater water)
    (isLiquid milk)
    

    ;coffe
    (isCoffe coffe)
    ;(grounded coffe) ;uncomment if you want to start with grounded coffe
    (isCoffe liquidCoffe)
    (isLiquid liquidCoffe)
    
    ;milk
    (isLiquid milk)
    (container_in milkBottle fridge)
    (ingredient_in milk milkBottle)
    

    ;moka
    (unpickupable bottMoka)
    (unpickupable filterMoka)
    (unpickupable topMoka)
    
    (isBottMoka bottMoka) (isFilterMoka filterMoka) (isTopMoka topMoka)
    (isMoka moka)
    (open_c topMoka)

    (isMokaPart bottMoka)
    (isMokaPart filterMoka)
    (isMokaPart topMoka)
    
    (mokaPotAfterPot topMoka filterMoka)
    (mokaPotAfterPot filterMoka bottMoka)



    ;spoon    
    (isSpoon coffeSpoon)
    (isSpoon sugarSpoon)
    (isCoffeSpoon coffeSpoon)
    (open_c coffeSpoon)
    (open_c sugarSpoon)
    (container_in coffeSpoon closetPlates)
    (container_in sugarSpoon closetPlates)


    ;grinder
    (isGrinder grinder)
    (unpickupable grinder)


    ;stopvetop
    (isStovetop stovetop)
    (open_l stovetop)


    ;cups
    (isCup cup1)(isCup cup2)



)



(:goal (and

    ;close closets
    (forall (?l - location) (or (isSink ?l)  (isTable ?l) (isStovetop ?l)(not(open_l ?l))))


    ;coffe in cup1, cup2
    (ingredient_in liquidCoffe cup1)
    (ingredient_in liquidCoffe cup2)
    
    ;sugar in cup1
    (ingredient_in sugar cup1)
    (not(ingredient_in sugar cup2))
    
    ;milk in cup2
    (not(ingredient_in milk cup1))
    (ingredient_in milk cup2)            
    

))




)