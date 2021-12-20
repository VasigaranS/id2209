/**
* Name: ID2209 Final Project
* Based on the internal empty template. 
* Author: vasigarans and aykhazanchi
* Tags: 
*/


model project

/* Insert your model definition here */

global {
	int firstArrival <- nil;	// this is a flag to decide who arrives first and they start conversation
	// when agent gets to target, if no neighbor found, consider itself first and set firstArrival to its own index
	int noAgents<-10;
	init{
	
		float globalMood <- 0.0; 
	
		create Bar with:(location:point (15,15));
		create ConcertHall with:(location:point (60,60));
		
		create RockGuest number:noAgents {
			index <- self.index;
		}
		create RapGuest number:noAgents {
			index <- self.index;
		}
		create PopGuest number:noAgents {
			index <- self.index;
		}
		create ClassicalGuest number:noAgents {
			index <- self.index;
		}
		create IndieGuest number:noAgents {
			index <- self.index;
		}		
	}
}

species RockGuest skills:[fipa, moving] {
	
	bool wander <- true; //	string travelStatus <- 'stopped'; // stopped , talking , moving
	bool travel <- false;
	string target <- nil;
	point targetPoint <- nil;
	int index;
	
	int mood;
	float talkative;
	float creative;
	float shy;
	float adventure;
	float emotional;
	float myPersonality;
    float barPersonality;
    float concertHallPersonality;
	
	init {
		talkative <- rnd(0,10.0);
		creative <- rnd(0,10.0);
		shy <- rnd(0,10.0);
		adventure <- rnd(0,10.0);
		emotional <- rnd(0,10.0);
		mood <- rnd(0,10); // start with a random mood
        // weighted personalities based on what attributes they like more
		myPersonality <- (talkative * 1) + (creative * 0.75) + (shy * 0) + (adventure * 0.5) + (emotional * 0.25);
        barPersonality <- myPersonality;    // +/- 0, ie no change in personality
        concertHallPersonality <- myPersonality;
	}

	aspect base {
		rgb agentcolor<- rgb('purple');
		draw circle(1) color: agentcolor;
	}
	
	action toggleFlag (bool wanderArg, bool travelArg) {
		wander <- wanderArg;
		travel <- travelArg;
	}

	reflex wander when: (wander = true) {
		//do goto target:{rnd(0,100),rnd(0,100)}; // go to random point and start wandering
		do wander;		
	}

	reflex go_travel when: (travel = true) {
		if (target = 'bar') {
			targetPoint <- {15,15}; // Bar location
			//do goto target:targetPoint;
		} else {
			targetPoint <- {60,60};	// Concert hall location
			//do goto target:targetPoint;
		}
	}
	
	// This only gets triggered if the agent is at location == target
    reflex findNeighbor when: (location = targetPoint) {
		agent neighbor <- agents at_distance(1); // finds any agent located at a distance <= 2 from the caller agent. This will only happen if an agent is already at the same target point
		if (neighbor = nil) {
			if (firstArrival = nil) {
				// set yourself as firstArrival
				firstArrival <- index;
			}
		}
		else { // neighbor is not nil
			if (firstArrival = index) {
				// start conversation
				do startConveration;
			}
		}
	}
	
	reflex respondToInitiator when:(!empty(requests)) {
		message requestFromInitiator<-(requests at 0);
		float initiatorPersonality <- requestFromInitiator.contents;
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [barPersonality]);
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [concertHallPersonality]);
		}
	}

	reflex readGuestResponse when: (!(empty(informs))) {
		message responseFromGuest <- (informs at 0);
		float guestPersonality <- responseFromGuest.contents;
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, guestPersonality);
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, guestPersonality);
		}	
	}


	// not a reflex because we only want to run it when called
	action startConveration {
		agent neighbor <- agents at_distance(1); // find agent at distance of 1
		if (target = 'bar') {
			do start_conversation (to::list(agent),protocol::'fipa-contract-net',performative::'request',contents::[barPersonality]);
		} else {
			do start_conversation (to::list(agent),protocol::'fipa-contract-net',performative::'request',contents::[concertHallPersonality]);	
		}
	}

	action changeMood (float personality, float otherAgentPersonality) {
		// compute mood based on personality received
		if (personality < otherAgentPersonality) {
			mood <- mood + 1; // guest is greater personality, mood rises
		} else if (personality > otherAgentPersonality) {
			mood <- mood - 1; // guest is lower personality, mood falls
		} else {
			mood <- mood + 2; // guest and I are exact matches, mood rises double
		}
	}
}

species RapGuest skills:[fipa, moving] {

	bool wander <- true; //	string travelStatus <- 'stopped'; // stopped , talking , moving
	bool travel <- false;
	string target <- nil;
	point targetPoint <- nil;
	int index;
	
	int mood;
	float talkative;
	float creative;
	float shy;
	float adventure;
	float emotional;
	float myPersonality;
    float barPersonality;
    float concertHallPersonality;
	
	init {
		talkative <- rnd(0,10.0);
		creative <- rnd(0,10.0);
		shy <- rnd(0,10.0);
		adventure <- rnd(0,10.0);
		emotional <- rnd(0,10.0);
		mood <- rnd(0,10); // start with a random mood
        // weighted personalities based on what attributes they like more
		myPersonality <- (talkative * 0.25) + (creative * 0) + (shy * 0.5) + (adventure * 1) + (emotional * 0.75);
        barPersonality <- myPersonality;    // +/- 0, ie no change in personality
        concertHallPersonality <- myPersonality;
	}

	aspect base {
		rgb agentcolor<- rgb('orange');
		draw circle(1) color: agentcolor;
	}
	
	action toggleFlag (bool wanderArg, bool travelArg) {
		wander <- wanderArg;
		travel <- travelArg;
	}

	reflex wander when: (wander = true) {
		//do goto target:{rnd(0,100),rnd(0,100)}; // go to random point and start wandering
		do wander;		
	}

	reflex go_travel when: (travel = true) {
		if (target = 'bar') {
			targetPoint <- {15,15}; // Bar location
			//do goto target:targetPoint;
		} else {
			targetPoint <- {60,60};	// Concert hall location
			//do goto target:targetPoint;
		}
	}
	
	// This only gets triggered if the agent is at location == target
    reflex findNeighbor when: (location = targetPoint) {
		agent neighbor <- agents at_distance(1); // finds any agent located at a distance <= 2 from the caller agent. This will only happen if an agent is already at the same target point
		if (neighbor = nil) {
			if (firstArrival = nil) {
				// set yourself as firstArrival
				firstArrival <- index;
			}
		}
		else { // neighbor is not nil
			if (firstArrival = index) {
				// start conversation
				do startConveration;
			}
		}
	}
	
	reflex respondToInitiator when:(!empty(requests)) {
		message requestFromInitiator<-(requests at 0);
		float initiatorPersonality <- requestFromInitiator.contents;
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [barPersonality]);
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [concertHallPersonality]);
		}
	}

	reflex readGuestResponse when: (!(empty(informs))) {
		message responseFromGuest <- (informs at 0);
		float guestPersonality <- responseFromGuest.contents;
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, guestPersonality);
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, guestPersonality);
		}	
	}


	// not a reflex because we only want to run it when called
	action startConveration {
		agent neighbor <- agents at_distance(1); // find agent at distance of 1
		if (target = 'bar') {
			do start_conversation (to::list(agent),protocol::'fipa-contract-net',performative::'request',contents::[barPersonality]);
		} else {
			do start_conversation (to::list(agent),protocol::'fipa-contract-net',performative::'request',contents::[concertHallPersonality]);	
		}
	}

	action changeMood (float personality, float otherAgentPersonality) {
		// compute mood based on personality received
		if (personality < otherAgentPersonality) {
			mood <- mood + 1; // guest is greater personality, mood rises
		} else if (personality > otherAgentPersonality) {
			mood <- mood - 1; // guest is lower personality, mood falls
		} else {
			mood <- mood + 2; // guest and I are exact matches, mood rises double
		}
	}
}

species PopGuest skills:[fipa, moving] {

	bool wander <- true; //	string travelStatus <- 'stopped'; // stopped , talking , moving
	bool travel <- false;
	string target <- nil;
	point targetPoint <- nil;
	int index;

	int mood;
	float talkative;
	float creative;
	float shy;
	float adventure;
	float emotional;
	float myPersonality;
    float barPersonality;
    float concertHallPersonality;

	init {
		talkative <- rnd(0,10.0);
		creative <- rnd(0,10.0);
		shy <- rnd(0,10.0);
		adventure <- rnd(0,10.0);
		emotional <- rnd(0,10.0);
		mood <- rnd(0,10); // start with a random mood
        // weighted personalities based on what attributes they like more
		myPersonality <- (talkative * 0.75) + (creative * 0.5) + (shy * 1) + (adventure * 0) + (emotional * 0.25);
        barPersonality <- myPersonality + 5.0;
        concertHallPersonality <- myPersonality - 5.0;
	}
    
	aspect base{
		rgb agentcolor<- rgb('blue');
		draw circle(1) color: agentcolor;
	}
	
	action toggleFlag (bool wanderArg, bool travelArg) {
		wander <- wanderArg;
		travel <- travelArg;
	}

	reflex wander when: (wander = true) {
		//do goto target:{rnd(0,100),rnd(0,100)}; // go to random point and start wandering
		do wander;		
	}

	reflex go_travel when: (travel = true) {
		if (target = 'bar') {
			targetPoint <- {15,15}; // Bar location
			//do goto target:targetPoint;
		} else {
			targetPoint <- {60,60};	// Concert hall location
			//do goto target:targetPoint;
		}
	}
	
	// This only gets triggered if the agent is at location == target
    reflex findNeighbor when: (location = targetPoint) {
		agent neighbor <- agents at_distance(1); // finds any agent located at a distance <= 2 from the caller agent. This will only happen if an agent is already at the same target point
		if (neighbor = nil) {
			if (firstArrival = nil) {
				// set yourself as firstArrival
				firstArrival <- index;
			}
		}
		else { // neighbor is not nil
			if (firstArrival = index) {
				// start conversation
				do startConveration;
			}
		}
	}
	
	reflex respondToInitiator when:(!empty(requests)) {
		message requestFromInitiator<-(requests at 0);
		float initiatorPersonality <- requestFromInitiator.contents;
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [barPersonality]);
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [concertHallPersonality]);
		}
	}

	reflex readGuestResponse when: (!(empty(informs))) {
		message responseFromGuest <- (informs at 0);
		float guestPersonality <- responseFromGuest.contents;
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, guestPersonality);
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, guestPersonality);
		}	
	}


	// not a reflex because we only want to run it when called
	action startConveration {
		agent neighbor <- agents at_distance(1); // find agent at distance of 1
		if (target = 'bar') {
			do start_conversation (to::list(agent),protocol::'fipa-contract-net',performative::'request',contents::[barPersonality]);
		} else {
			do start_conversation (to::list(agent),protocol::'fipa-contract-net',performative::'request',contents::[concertHallPersonality]);	
		}
	}

	action changeMood (float personality, float otherAgentPersonality) {
		// compute mood based on personality received
		if (personality < otherAgentPersonality) {
			mood <- mood + 1; // guest is greater personality, mood rises
		} else if (personality > otherAgentPersonality) {
			mood <- mood - 1; // guest is lower personality, mood falls
		} else {
			mood <- mood + 2; // guest and I are exact matches, mood rises double
		}
	}
}

species ClassicalGuest skills:[fipa, moving] {

	bool wander <- true; //	string travelStatus <- 'stopped'; // stopped , talking , moving
	bool travel <- false;
	string target <- nil;
	point targetPoint <- nil;
	int index;

	int mood;
	float talkative;
	float creative;
	float shy;
	float adventure;
	float emotional;
	float myPersonality;
    float barPersonality;
    float concertHallPersonality;

	init {
		talkative <- rnd(0,10.0);
		creative <- rnd(0,10.0);
		shy <- rnd(0,10.0);
		adventure <- rnd(0,10.0);
		emotional <- rnd(0,10.0);
		mood <- rnd(0,10); // start with a random mood
        // weighted personalities based on what attributes they like more
		myPersonality <- (talkative * 0.5) + (creative * 1) + (shy * 0.75) + (adventure * 0.25) + (emotional * 0); // Range: [0 - 25]
        barPersonality <- myPersonality - 5.0;
        concertHallPersonality <- myPersonality + 5.0;
	}


	aspect base{
		rgb agentcolor<- rgb('pink');
		draw circle(1) color: agentcolor;
	}
	
	action toggleFlag (bool wanderArg, bool travelArg) {
		wander <- wanderArg;
		travel <- travelArg;
	}

	reflex wander when: (wander = true) {
		//do goto target:{rnd(0,100),rnd(0,100)}; // go to random point and start wandering
		do wander;		
	}

	reflex go_travel when: (travel = true) {
		if (target = 'bar') {
			targetPoint <- {15,15}; // Bar location
			//do goto target:targetPoint;
		} else {
			targetPoint <- {60,60};	// Concert hall location
			//do goto target:targetPoint;
		}
	}
	
	// This only gets triggered if the agent is at location == target
    reflex findNeighbor when: (location = targetPoint) {
		agent neighbor <- agents at_distance(1); // finds any agent located at a distance <= 2 from the caller agent. This will only happen if an agent is already at the same target point
		if (neighbor = nil) {
			if (firstArrival = nil) {
				// set yourself as firstArrival
				firstArrival <- index;
			}
		}
		else { // neighbor is not nil
			if (firstArrival = index) {
				// start conversation
				do startConveration;
			}
		}
	}
	
	reflex respondToInitiator when:(!empty(requests)) {
		message requestFromInitiator<-(requests at 0);
		float initiatorPersonality <- requestFromInitiator.contents;
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [barPersonality]);
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [concertHallPersonality]);
		}
	}

	reflex readGuestResponse when: (!(empty(informs))) {
		message responseFromGuest <- (informs at 0);
		float guestPersonality <- responseFromGuest.contents;
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, guestPersonality);
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, guestPersonality);
		}	
	}


	// not a reflex because we only want to run it when called
	action startConveration {
		agent neighbor <- agents at_distance(1); // find agent at distance of 1
		if (target = 'bar') {
			do start_conversation (to::list(agent),protocol::'fipa-contract-net',performative::'request',contents::[barPersonality]);
		} else {
			do start_conversation (to::list(agent),protocol::'fipa-contract-net',performative::'request',contents::[concertHallPersonality]);	
		}
	}

	action changeMood (float personality, float otherAgentPersonality) {
		// compute mood based on personality received
		if (personality < otherAgentPersonality) {
			mood <- mood + 1; // guest is greater personality, mood rises
		} else if (personality > otherAgentPersonality) {
			mood <- mood - 1; // guest is lower personality, mood falls
		} else {
			mood <- mood + 2; // guest and I are exact matches, mood rises double
		}
	}
}

species IndieGuest skills:[fipa, moving] {

	bool wander <- true; //	string travelStatus <- 'stopped'; // stopped , talking , moving
	bool travel <- false;
	string target <- nil;
	point targetPoint <- nil;
	int index;

	int mood;
	float talkative;
	float creative;
	float shy;
	float adventure;
	float emotional;
	float myPersonality;
    float barPersonality;
    float concertHallPersonality;

	init {
		talkative <- rnd(0,10.0);
		creative <- rnd(0,10.0);
		shy <- rnd(0,10.0);
		adventure <- rnd(0,10.0);
		emotional <- rnd(0,10.0);
		mood <- rnd(0,10); // start with a random mood
        // weighted personalities based on what attributes they like more
		myPersonality <- (talkative * 0) + (creative * 0.25) + (shy * 1) + (adventure * 0.75) + (emotional * 0.5);
        barPersonality <- myPersonality - 5.0;
        concertHallPersonality <- myPersonality + 5.0;
	}

	aspect base{
		rgb agentcolor<- rgb('black');	
		draw circle(1) color: agentcolor;
	}
	
	action toggleFlag (bool wanderArg, bool travelArg) {
		wander <- wanderArg;
		travel <- travelArg;
	}

	reflex wander when: (wander = true) {
		//do goto target:{rnd(0,100),rnd(0,100)}; // go to random point and start wandering
		do wander;		
	}

	reflex go_travel when: (travel = true) {
		if (target = 'bar') {
			targetPoint <- {15,15}; // Bar location
			//do goto target:targetPoint;
		} else {
			targetPoint <- {60,60};	// Concert hall location
			//do goto target:targetPoint;
		}
	}
	
	// This only gets triggered if the agent is at location == target
    reflex findNeighbor when: (location = targetPoint) {
		agent neighbor <- agents at_distance(1); // finds any agent located at a distance <= 2 from the caller agent. This will only happen if an agent is already at the same target point
		if (neighbor = nil) {
			if (firstArrival = nil) {
				// set yourself as firstArrival
				firstArrival <- index;
			}
		}
		else { // neighbor is not nil
			if (firstArrival = index) {
				// start conversation
				do startConveration;
			}
		}
	}
	
	reflex respondToInitiator when:(!empty(requests)) {
		message requestFromInitiator<-(requests at 0);
		float initiatorPersonality <- requestFromInitiator.contents;
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [barPersonality]);
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [concertHallPersonality]);
		}
	}

	reflex readGuestResponse when: (!(empty(informs))) {
		message responseFromGuest <- (informs at 0);
		float guestPersonality <- responseFromGuest.contents;
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, guestPersonality);
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, guestPersonality);
		}	
	}


	// not a reflex because we only want to run it when called
	action startConveration {
		agent neighbor <- agents at_distance(1); // find agent at distance of 1
		if (target = 'bar') {
			do start_conversation (to::list(agent),protocol::'fipa-contract-net',performative::'request',contents::[barPersonality]);
		} else {
			do start_conversation (to::list(agent),protocol::'fipa-contract-net',performative::'request',contents::[concertHallPersonality]);	
		}
	}

	action changeMood (float personality, float otherAgentPersonality) {
		// compute mood based on personality received
		if (personality < otherAgentPersonality) {
			mood <- mood + 1; // guest is greater personality, mood rises
		} else if (personality > otherAgentPersonality) {
			mood <- mood - 1; // guest is lower personality, mood falls
		} else {
			mood <- mood + 2; // guest and I are exact matches, mood rises double
		}
	}
}

species Bar{
	aspect base{
		draw rectangle(7,4) at: location color: #yellow;
	}
}


species ConcertHall{
	aspect base{
		draw rectangle(7,4) at: location color: #green;
	}
}

experiment name type: gui {
	output {
		display mydisplay type: opengl {
			species RockGuest aspect:base;
			species RapGuest aspect:base;
			species PopGuest aspect:base;
			species ClassicalGuest aspect:base;
			species IndieGuest aspect:base;
			species Bar aspect:base;
			species ConcertHall aspect:base;
		}
	}
}