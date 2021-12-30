/**
* Name: project
* Based on the internal empty template. 
* Author: aykhazanchi and vasigarans
* Tags: 
*/


model project

/* Insert your model definition here */

Agents
------
RockAgent 
IndieAgent
PopAgent
ClassicalAgent
RapAgent

Global
------
BarAgent -> fixed location
ConcertHallAgent -> fixed location 
GlobalMood -> Calculate average of moods of all agents


Agent Attributes
------------------
mood -> variable
talkative -> fixed (0 - 10)
creative -> fixed (0 - 10)
shy -> fixed (0 - 10)
adventurous -> fixed
emotional ->

myPersonality -> calculated from above with weightage (details below)
genre -> fixed (type of agent)
index -> fixed


Implementation
--------------

--- Personality
- Each agent has some personality traits they like over other traits. For example, classical agent like creative and shy but doesnt like talkative
- Weightage:
-- Classical: { T * 0.5 | C * 1 | S * 0.75 | A * 0.25 | E * 0 } B - 5, CH + 5
-- Rock: { T * 1 | C * 0.75 | S * 0 | A * 0.5 | E * 0.25 } B + 5, CH - 5
-- Pop: { T * 0.75 | C * 0.5 | S * 1 | A * 0 | E * 0.25 } B + 5, CH - 5
-- Indie: { T * 0 | C * 0.25 | S * 1 | A * 0.75 | E * 0.5 } B - 5, CH + 5
-- Rap: { T * 0.25 | C * 0 | S * 0.5 | A * 1 | E * 0.75 } B + 0, CH - 0

- myPersonality = sum of values above
- barPersonality = myPersonality * someBarValueForEachAgent (different for each type of agent)
- concertHallPersonality = myPersonality * someConcertHallValueForEachAgent (different for each type of agent)

- if P1 < P2 then M1-- and M2++
- if P1 = P2 then M1+=2 and M2+=2
- if P1 > P2 then M1-- and M2++

--- Interaction
- all guests randomly wander all the time (wander = true, interaction=false)
- pick two people at random from global array to go a location (global) (wander = false, interaction=true)
- make them wait until they are in a location area and then start conversation (while interaction = true and locationArea = someDefiendArea of Bar/Concert ahll)
- they send each other their personality values (barPersonality or concertHallPersonality) and do computation of mood on that
- compute the result and then wander (wander = true, interaction = false, location = random coordinate)
 
