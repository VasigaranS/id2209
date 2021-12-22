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
	int noAgents<-5;
	init{
	
		float globalMood <- 0.0; 
	
		create Bar with:(location:point (15,15));
		create ConcertHall with:(location:point (60,60));
		create DestinyAgent;
		
		create RockGuest number:noAgents {
			//index <- self.index;
		}
		create RapGuest number:noAgents {
			//index <- self.index;
			//write(index);
		}
		create PopGuest number:noAgents {
			//index <- self.index;
		}
		create ClassicalGuest number:noAgents {
			//index <- self.index;
		}
		create IndieGuest number:noAgents {
			//index <- self.index;
		}
		
		
		
		loop counter from:0 to:noAgents-1{
			RockGuest myagent<-RockGuest[counter];
			myagent <- myagent.setIndex(counter);
		}
		
		loop counter from:0 to:noAgents-1{
			RapGuest myagent<-RapGuest[counter];
			myagent <- myagent.setIndex(counter);
		}
		
		loop counter from:0 to:noAgents-1{
			PopGuest myagent<-PopGuest[counter];
			myagent <- myagent.setIndex(counter);
		}
		
		loop counter from:0 to:noAgents-1{
			ClassicalGuest myagent<-ClassicalGuest[counter];
			myagent <- myagent.setIndex(counter);
		}
		
		loop counter from:0 to:noAgents-1{
			IndieGuest myagent<-IndieGuest[counter];
			myagent <- myagent.setIndex(counter);
		}		
	}
}
//[rockguest,rapguest,pop,indie,classical]
//[0,noAgents-1]
//[bar,concerthall]
//TODO Global Decider agent that informs two random guests to go to two locations (2 for bar, 2 concertHall)
//TODO Decider picks by randomly picking two guest types and a random index



species DestinyAgent  {
	
	int genre1;
	int f1;
	int genre2;
	int f2;
	int genre3;
	int f3;
	int genre4;
	int f4;
	bool meet<-true;
	
	
	
	list<string>genrelist<-['RockGuest','RapGuest','PopGuest','ClassicalGuest','IndieGuest'];
	
	reflex arrangeMeeting when: meet=true{
		 genre1<-rnd(0,4);
		 f1<-rnd(0,noAgents-1);
		 genre2<-rnd(0,4);
		 f2<-rnd(0,noAgents-1);
		 //meet<-false;
		 //write(genre1);
		 
		 write(genrelist[genre1]);
		 f3<-rnd(0,noAgents-1);
		 genre3<-rnd(0,4);
		 f4<-rnd(0,noAgents-1);
		 genre4<-rnd(0,4);
		 
		 
		 
		 loop while: (f3=f1 or f3=f2){
		 	f3<-rnd(0,noAgents-1);
		 }
		 
		 loop while: (f4=f1 or f4=f2 or f4=f3){
		 	f4<-rnd(0,noAgents-1);
		 }
		 
		 
		 //first meeting
		 do asktomeet(genrelist[genre1],f1,'bar');
		 do asktomeet(genrelist[genre2],f2,'bar');
		 
		 //second meeting
		 do asktomeet(genrelist[genre3],f3,'concerthall');
		 do asktomeet(genrelist[genre4],f4,'concerthall');
		 meet<-false;
		 
		 
		 
		 
		 
		 
		 
		
	}
	
	
	action asktomeet(string genre,int f,string t){
		
		if(genre='RockGuest'){
			
			ask RockGuest[f]{
		 	self.travel<-true;
		 	self.target<-t;
		 	
		 }
		}
		
		else if(genre='RapGuest'){
			
			ask RapGuest[f]{
		 	self.travel<-true;
		 	self.target<-t;
		 	
		 }
			
		}
		
		
		else if(genre='PopGuest'){
			
			ask PopGuest[f]{
		 	self.travel<-true;
		 	self.target<-t;
		 	
		 }
			
		}
		
		else if(genre='ClassicalGuest'){
			
			ask ClassicalGuest[f]{
		 	self.travel<-true;
		 	self.target<-t;
		 	
		 }
			
		}
		
		else if(genre='IndieGuest'){
			
			ask IndieGuest[f]{
		 	self.travel<-true;
		 	self.target<-t;
		 	
		 }
			
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
	
	bool test<-false;
	
	
	
	init {
		talkative <- rnd(0,10.0);
		creative <- rnd(0,10.0);
		shy <- rnd(0,10.0);
		adventure <- rnd(0,10.0);
		emotional <- rnd(0,10.0);
		mood <- rnd(0,10); // start with a random mood
        // weighted personalities based on what attributes they like more
		myPersonality <- (talkative * 1) + (creative * 0.75) + (shy * 0) + (adventure * 0.5) + (emotional * 0.25);
        barPersonality <- myPersonality+5.0;    // +/- 0, ie no change in personality
        concertHallPersonality <- myPersonality-5.0;
	}

	aspect base {
		rgb agentcolor<- rgb('purple');
		draw circle(1) color: agentcolor;
	}
	
	action toggleFlag (bool wanderArg, bool travelArg) {
		wander <- wanderArg;
		travel <- travelArg;
	}
	
	action setIndex(int num){
		index<-num;
	}

	reflex wander when: (wander = true) {
		//do goto target:{rnd(0,100),rnd(0,100)}; // go to random point and start wandering
		do wander;		
	}
	
	reflex testing when:test=true{
		
		write(index);
		write('worked');
	}	

	reflex go_travel when: (travel = true) {
		if (target = 'bar') {
			write('moving to bar');
			targetPoint <- {15,15}; // Bar location
			do goto target:targetPoint;
		} else {
			targetPoint <- {60,60};	// Concert hall location
			do goto target:targetPoint;
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
	
	action setIndex(int num){
		index<-num;
	}

	reflex wander when: (wander = true) {
		//do goto target:{rnd(0,100),rnd(0,100)}; // go to random point and start wandering
		do wander;		
	}

	reflex go_travel when: (travel = true) {
		if (target = 'bar') {
			targetPoint <- {15,15}; // Bar location
			do goto target:targetPoint;
		} else {
			targetPoint <- {60,60};	// Concert hall location
			do goto target:targetPoint;
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
	
	action setIndex(int num){
		index<-num;
	}

	reflex wander when: (wander = true) {
		//do goto target:{rnd(0,100),rnd(0,100)}; // go to random point and start wandering
		do wander;		
	}

	reflex go_travel when: (travel = true) {
		if (target = 'bar') {
			targetPoint <- {15,15}; // Bar location
			do goto target:targetPoint;
		} else {
			targetPoint <- {60,60};	// Concert hall location
			do goto target:targetPoint;
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
	
	action setIndex(int num){
		index<-num;
	}

	reflex wander when: (wander = true) {
		//do goto target:{rnd(0,100),rnd(0,100)}; // go to random point and start wandering
		do wander;		
	}

	reflex go_travel when: (travel = true) {
		if (target = 'bar') {
			targetPoint <- {15,15}; // Bar location
			do goto target:targetPoint;
		} else {
			targetPoint <- {60,60};	// Concert hall location
			do goto target:targetPoint;
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
	
	action setIndex(int num){
		index<-num;
	}

	reflex wander when: (wander = true) {
		//do goto target:{rnd(0,100),rnd(0,100)}; // go to random point and start wandering
		do wander;		
	}

	reflex go_travel when: (travel = true) {
		if (target = 'bar') {
			targetPoint <- {15,15}; // Bar location
			do goto target:targetPoint;
		} else {
			targetPoint <- {60,60};	// Concert hall location
			do goto target:targetPoint;
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