/**
* Name: ID2209 Final Project
* Based on the internal empty template. 
* Author: vasigarans and aykhazanchi
* Tags: 
*/


model project

/* Insert your model definition here */

global {
	bool firstArrival <- false;	// this is a flag to start_conversation
	// when agent gets to target, if no neighbor found, consider yourself first and set the flag to true
	int noAgents<-10;
	init{
	
		float globalMood <- 0.0; 
		
		create Bar with:(location:point (15,15));
		create ConcertHall with:(location:point (60,60));
		
		
		create RockGuest number:noAgents;
		create IndieGuest number:noAgents;
		create PopGuest number:noAgents;
		create ClassicalGuest number:noAgents;
		create RapGuest number:noAgents;

	}
}


species RockGuest skills:[moving]{

	bool wander <- true;
//	String travelStatus <- 'stopped'; // stopped , talking , moving
	bool travel <- false;
	String target <- nil;
	point targetPoint <- nil;

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
		myPersonality <- (talkative * 1.0) + (creative * 0.75) + (shy * 0) + (adventure * 0.5) + (emotional * 0.25);
        barPersonality <- myPersonality + 5.0;
        concertHallPersonality <- myPersonality - 5.0;		
	}
			
	aspect base{
		rgb agentcolor<- rgb('purple');
		draw circle(1) color: agentcolor;
	}
	
	action toggleFlag (bool wanderArg, bool travelArg) {
		wander <- wanderArg;
		travel <- travelArg;
	}

	reflex wander when: (wander = true) {
		do goto target:{rnd(0,100),rnd(0,100)}; // go to random point and start wandering
		do wander;		
	}

	reflex go_travel when: (travel = true) {
		if (target is 'bar') {
			targetPoint <- Bar.location;
			do goto target:targetPoint;
		} else {
			targetPoint <- ConcertHall.location;
			do goto target:targetPoint;
		}
	}

	// This only gets triggered if the agent is at location == target
    reflex findNeighbor when: (self.location = targetPoint) {
		
		agent neighbor <- agents at_distance(2); // finds any agent located at a distance <= 2 from the caller agent. This will only happen if an agent is already at the same target point

		if (neighbor = nil) {
			if (firstArrival = nil) {
				// set yourself as firstArrival
				firstArrival <- self.index;
			}
		}
		else if (neighbor != nil) {
			if (firstArrival is self.index) {
				// start conversation
				do startConveration;
			}
			else {
				// you have a neighbor but you're not firstArrival
				// Wait for the conversation and respond to whatever you get
			}
		}
	}

	// not a reflex because we only want to run it when called
	action startConveration {
		
	}
	
}


species RapGuest skills:[moving]{

	bool wander <- true;
//	String travelStatus <- 'stopped'; // stopped , talking , moving
	bool travel <- false;
	String target <- nil;
	point targetPoint <- nil;
	
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
	
	reflex wander when: (wander = true) {
		do wander;
	}

	reflex go_travel when: (travel = true) {
		if (target is 'bar') {
			do goto target:Bar.location;
		} else {
			do goto target:ConcertHall.location;
		}

	}
}


species ClassicalGuest skills:[moving]{

	bool wander <- true;
//	String travelStatus <- 'stopped'; // stopped , talking , moving
	bool travel <- false;
	String target <- nil;
	point targetPoint <- nil;

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
	
	reflex wander when: (wander = true) {
		do wander;	
	}

	reflex go_travel when: (travel = true) {
		if (target is 'bar') {
			do goto target:Bar.location;
		} else {
			do goto target:ConcertHall.location;
		}
		
	}
}



species PopGuest skills:[moving]{

	bool wander <- true;
//	String travelStatus <- 'stopped'; // stopped , talking , moving
	bool travel <- false;
	String target <- nil;
	point targetPoint <- nil;

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
	
	reflex wander when: (wander = true) {
		do wander;
	}

	reflex go_travel when: (travel = true) {
		if (target is 'bar') {
			do goto target:Bar.location;
		} else {
			do goto target:ConcertHall.location;
		}

	}
}


species IndieGuest skills:[moving]{

	bool wander <- true;
//	String travelStatus <- 'stopped'; // stopped , talking , moving
	bool travel <- false;
	String target <- nil;
	point targetPoint <- nil;

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
	
	reflex wander when: (wander = true) {
		do wander;
	}

	reflex go_travel when: (travel = true) {
		if (target is 'bar') {
			do goto target:Bar.location;
		} else {
			do goto target:ConcertHall.location;
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
	// Define parameters here if necessary
	// parameter "My parameter" category: "My parameters" var: one_global_attribute;
	
	// Define attributes, actions, a init section and behaviors if necessary
	// init { }
		
	output {
		display mydisplay{
			species RockGuest aspect:base;
			species IndieGuest aspect:base;
			species PopGuest aspect:base;
			species ClassicalGuest aspect:base;
			species RapGuest aspect:base;
			species Bar aspect:base;
			species ConcertHall aspect:base;
		}
	}
}