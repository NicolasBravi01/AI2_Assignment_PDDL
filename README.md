# Home Assistance Robot AR-1: Coffee Making Scenario
Assignment of Artificial Intelligence 2 course at UNIGE, Robotics Engineering Master Degree.

## Introduction

In the context of home assistance for elderly people, a next-generation domestic assistant robot, named AR-1, is designed to perform a series of household tasks, meal preparation and, in general, working in the kitchen. Equipped with a flexible structure and a wide range of advanced sensors (including cameras, tactile and pressure sensors, temperature sensors), AR-1 can operate (partially) autonomously within the home environment, of which it has a 3D mapping obtained during an initial calibration phase.

## Task Description: Making Coffee with an Italian Moka Machine

Let us focus on a robot capable of making coffee (“espresso”) using an Italian moka machine in the kitchen. The whole process can be described as follows:

### 1. Prepare Ingredients

AR-1 must gather the necessary ingredients for making coffee, including coffee beans or ground coffee, filtered water, and optionally, sugar or milk. The ingredients are in various locations of the kitchen. Their locations in the kitchen must be specified as part of the problem.

AR-1 knows how to:
- a) pick up, put down and in general manipulate all necessary objects;
- b) open and close drawers and closets;
- c) open and close jars and other containers;
- d) operate kitchen appliances, such as the water tap, etc.

### 2. Grind Coffee

If using whole coffee beans, AR-1 must grind them to a medium-fine consistency. The grind size should be like that of table salt for best results. Both options (coffee beans or ground coffee) are possible, and this should be specified in advance.

AR-1 knows how to:
- a) pour coffee beans inside the grinder;
- b) operate (switching on and off, activate) the grinder.

### 3. Fill Water Reservoir

AR-1 must unscrew the top part of the moka pot and fill the bottom reservoir with filtered water.

AR-1 knows how to:
- a) manipulate (screw, unscrew) the moka pot and its parts;
- b) pour water inside the bottom reservoir.

### 4. Insert Filter and Coffee

AR-1 must place the filter basket into the bottom chamber of the moka pot; add the ground coffee into the filter basket, distributing it evenly and leveling it off with a tool (for example, a coffee spoon) to ensure uniform extraction.

AR-1 knows how to:
- a) extract the ground coffee from a container (for example, with a small spoon);
- b) fill the filter basket with ground coffee (for example, with a small spoon);
- c) level the coffee on the filter (for example, with a spoon).

### 5. Assemble Moka Pot and Heat

AR-1 must screw the top portion of the moka pot onto the bottom reservoir tightly but without applying excessive force; it must also place the moka pot on the stovetop burner set to medium heat.

AR-1 knows how to:
- a) manipulate (screw, unscrew) the moka pot and its parts;
- b) operate the stovetop burner.

It is assumed here that the stovetop burner will automatically stop when the coffee is ready: however, any ideas about how to model the processes of screwing the moka without excessive force, or of waiting for the coffee to be ready?

### 6. Serve

AR-1 must untap the top portion of the moka pot and pour the freshly brewed coffee into cups or mugs.

AR-1 knows how to:
- a) manipulate (screw, unscrew) the moka pot and its parts;
- b) pour liquids into coffee cups.

## Problem

You must design and implement a PDDL domain which models the “coffee making scenario”. Furthermore, you must design at least one PDDL problem generating a valid plan. Use ALL the things AR-1 knows.


## How to run
A PDDL planner is necessary to run it. For this problem the **BFWS--FF** planner was used. It does not give an optimize plan, but BFWS--FF computes it quickly.

## Author
Nicolas Bravi, nicolasbravi2001@gmail.com
