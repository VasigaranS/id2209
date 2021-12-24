/**
* Name: ID2209 Final Project
* Based on the internal empty template. 
* Author: vasigarans and aykhazanchi
* Tags: 
*/


model project

/* Insert your model definition here */

global {
	string firstArrivalBar <- nil;	// this is a flag to decide who arrives first and they start conversation
	string firstArrivalConcertHall <- nil;	// this is a flag to decide who arrives first and they start conversation
	// when agent gets to target, if no neighbor found, consider itself first and set firstArrival to its own index
	string barMeet<-"true";
	string concertMeet<-"true";
	int noAgents<-5;
	float globalMood;
	list<string> BusyAgents<-['-1','-1','-1','-1'];
	int globalCycles;	// Total number of interactions (globalMood is computed after each interaction)
	init{
	
		globalMood <- 0.0; 
		globalCycles <- 0;
		
		create Bar with:(location:point (0,0));
		create ConcertHall with:(location:point (100,100));
		create DestinyAgent;
		
		create RockGuest number:noAgents {
			loop i from:0 to:noAgents-1 {
				RockGuest[i].index <- i;
			}
		}
		create RapGuest number:noAgents {
			loop i from:0 to:noAgents-1 {
				RapGuest[i].index <- i;
			}
		}
		create PopGuest number:noAgents {
			loop i from:0 to:noAgents-1 {
				PopGuest[i].index <- i;
			}		
		}
		create ClassicalGuest number:noAgents {
			loop i from:0 to:noAgents-1 {
				ClassicalGuest[i].index <- i;
			}		
		}
		create IndieGuest number:noAgents {
			loop i from:0 to:noAgents-1 {
				IndieGuest[i].index <- i;
			}		
		}	
	}
}

species DestinyAgent  {
	
	int genre1;
	int f1;
	int genre2;
	int f2;
	int genre3;
	int f3;
	int genre4;
	int f4;

	list<string> genreList <- ['RockGuest','RapGuest','PopGuest','ClassicalGuest','IndieGuest'];

	reflex arrangeBarMeeting when: (barMeet="true"){
		string f1name;
		string f2name;
		BusyAgents[0]<-'-1';
		BusyAgents[1]<-'-1';

		genre1<-rnd(0,4);
		f1<-rnd(0,noAgents-1);
		f1name<-genreList[genre1]+f1;
		loop while:(BusyAgents contains f1name){
			f1<-rnd(0,noAgents-1);
			f1name<-genreList[genre1]+f1;
		}
		

		genre2<-rnd(0,4);
		f2<-rnd(0,noAgents-1);
		f2name<-genreList[genre2]+f2;
		
		loop while:(BusyAgents contains f2name){
			f2<-rnd(0,noAgents-1);
			f2name<-genreList[genre2]+f2;
		}
	
		// We only need to change index when the genre type is the exact same
		// ex: RockGuest0 (agent1) and RockGuest0 (agent3). PopGuest0 (agent1) and RockGuest0 (agent3) is ok
		if (genre1 = genre2) {
		loop while: (f2=f1 or BusyAgents contains f2name){
			
			f2<-rnd(0,noAgents-1);
			f2name<-genreList[genre2]+f2;
			}
		}
		
		
		BusyAgents[0]<-f1name;
		BusyAgents[1]<-f2name;
		write(BusyAgents);
		

		// reset firstArrival
		firstArrivalBar <- nil;

		//first meeting
		write 'Sending ' + genreList[genre1] + f1 + ' to meet ' + genreList[genre2] + f2 + ' at the bar';
		do asktomeet(genreList[genre1],f1,'bar', 1.0);
		do asktomeet(genreList[genre2],f2,'bar', 0.8);

		barMeet<-"false";
	}

	reflex arrangeConcertMeeting when: (concertMeet="true"){
		
		string f3name;
		string f4name;
		
		BusyAgents[2]<-'-1';
		BusyAgents[3]<-'-1';
				
		genre3<-rnd(0,4);
		f3<-rnd(0,noAgents-1);
		f3name<-genreList[genre3]+f3;
		
		loop while:(BusyAgents contains f3name){
			f3<-rnd(0,noAgents-1);
			f3name<-genreList[genre3]+f3;
		}

		genre4<-rnd(0,4);
		f4<-rnd(0,noAgents-1);
		f4name<-genreList[genre4]+f4;
		
		loop while:(BusyAgents contains f4name){
			f4<-rnd(0,noAgents-1);
			f4name<-genreList[genre4]+f4;
		}

		// We only need to change index when the genre type is the exact same
		// ex: RockGuest0 (agent1) and RockGuest0 (agent3). PopGuest0 (agent1) and RockGuest0 (agent3) is ok
		if (genre1 = genre3 or genre1 = genre4 or genre2 = genre3 or genre2 = genre4 or genre3 = genre4) {
			loop while: (f3=f1) or (f3=f2) or BusyAgents contains f3name {
				write 'stuck in loop f3';
				f3<-rnd(0,noAgents-1);
				f3name<-genreList[genre3]+f3;
			}
			loop while: (f4=f1) or (f4=f2) or (f4=f3)  or BusyAgents contains f4name {
				write 'stuck in loop f4';
				f4<-rnd(0,noAgents-1);
				f4name<-genreList[genre4]+f4;
			}
		}
		
		BusyAgents[2]<-f3name;
		BusyAgents[3]<-f4name;
		write(BusyAgents);

		// reset firstArrival
		firstArrivalConcertHall <- nil;

		//second meeting
		write 'Sending ' + genreList[genre3] + f3 + ' to meet ' + genreList[genre4] + f4 + ' at the concert hall';
		do asktomeet(genreList[genre3],f3,'concerthall', 1.0);
		do asktomeet(genreList[genre4],f4,'concerthall', 0.8);

		concertMeet<-"false";
	}

	action asktomeet(string genre,int f,string t, float movingSpeed){
		if(genre='RockGuest') {
			ask RockGuest[f] {
				self.travel<-true;
				self.wander<-false;
				self.target<-t;
				self.speed<-movingSpeed;
			}
		}
		else if(genre='RapGuest') {	
			ask RapGuest[f] {
				self.travel<-true;
				self.wander<-false;
				self.target<-t;
				self.speed<-movingSpeed;
			}
		}
		else if(genre='PopGuest') {
			ask PopGuest[f] {
				self.travel<-true;
				self.wander<-false;
				self.target<-t;
				self.speed<-movingSpeed;
			}
		}
		else if(genre='ClassicalGuest') {	
			ask ClassicalGuest[f] {
				self.travel<-true;
				self.wander<-false;
				self.target<-t;
				self.speed<-movingSpeed;
			}
		}
		else if(genre='IndieGuest') {	
			ask IndieGuest[f]{
				self.travel<-true;
				self.wander<-false;
				self.target<-t;
				self.speed<-movingSpeed;
			}
		}
	}

	reflex computeGlobalMood when: (barMeet = "mood" or concertMeet = "mood"){
		globalCycles <- globalCycles + 1; // keeps overall counter of global mood computations in order to get average
		loop genre over: genreList {
			loop i from:0 to:noAgents-1 {
				if (genre = "RockGuest") {
					globalMood <- ((globalMood + RockGuest[i].mood) / globalCycles);
				}
				if (genre = "RapGuest") {
					globalMood <- ((globalMood + RapGuest[i].mood) / globalCycles);
				}
				if (genre = "PopGuest") {
					globalMood <- ((globalMood + PopGuest[i].mood) / globalCycles);
				}
				if (genre = "ClassicalGuest") {
					globalMood <- ((globalMood + ClassicalGuest[i].mood) / globalCycles);
				}
				if (genre = "IndieGuest") {
					globalMood <- ((globalMood + IndieGuest[i].mood) / globalCycles);
				}
			}
		}
		write 'Global Mood ------ ' + globalMood;
		if (barMeet = "mood") {
			barMeet <- "true";
		}
		else if (concertMeet = "mood") {
			concertMeet <- "true";
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
        barPersonality <- myPersonality+5.0;    // +/- 0, ie no change in personality
        concertHallPersonality <- myPersonality-5.0;
	}

	aspect base {
		rgb agentcolor<- rgb('purple');
		draw circle(1) color: agentcolor;
	}

	reflex wander when: (wander = true) {
		self.speed<-1.0;
		list<point> clusters <- [{25,50}, {50,25}, {50,50}, {75,75}];
		point cluster <- clusters[rnd(0,3)];
		do goto target:cluster; // go to random cluster and start wandering
		do wander;		
	}	

	reflex go_travel when: (travel = true) {
		if (target = 'bar') {
			write 'I ' + self.name + ' am moving to bar';
			targetPoint <- {0,0}; // Bar location
			do goto target:targetPoint;
		} else {
			write 'I ' + self.name + ' am moving to concert hall';
			targetPoint <- {100,100};	// Concert hall location
			do goto target:targetPoint;
		}
	}
	
	// This only gets triggered if the agent is at location == target
    reflex findNeighbor when: (location = targetPoint) and (travel = true) {
		list<agent> neighbors <- agents at_distance(1); // finds any agent located at a distance <= 2 from the caller agent. This will only happen if an agent is already at the same target point
		agent neighbor;
		write 'I am ' + self.name + ' and my neighbors are: ' + neighbors;
		loop n over: neighbors {
			if (n.name != 'ConcertHall0') and (n.name != 'Bar0') {
				neighbor <- n;
				write 'I am ' + self.name + ' and my neighbor at ' + target + ' is : ' + neighbor;
			}
		}
		
		if (length(neighbors) <= 1) {
			if (target = 'bar') {
				firstArrivalBar <- self.name;
			}
			else {
				firstArrivalConcertHall <- self.name;
			}
		}
		else { // neighbor is not nil
			write 'I ' + self.name + ' found a neighbor - ' + neighbor;
			if (firstArrivalBar = self.name) or (firstArrivalConcertHall = self.name) {
				// start conversation
				write 'I ' + self.name + ' am starting the conversation';
				do startConveration;
			}
		}
	}
	
	reflex respondToInitiator when:(!empty(requests)) {
		write 'I ' + self.name + ' have received a conversation from someone!';
		message requestFromInitiator<-(requests at 0);
		float initiatorPersonality <- requestFromInitiator.contents as float;
		list fl<-requestFromInitiator.contents;
		//write(fl[0]);
		initiatorPersonality<-fl[0] as float;
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [barPersonality]);
			write 'I ' + self.name + ' have responded with my bar personality: ' + barPersonality;
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [concertHallPersonality]);
			write 'I ' + self.name + ' have responded with my concert personality: ' + concertHallPersonality;
		}
		self.travel <- false;
		self.wander <- true;
	}

	reflex readGuestResponse when: (!(empty(informs))) {
		message responseFromGuest <- (informs at 0);
		write 'I ' + self.name + ' have received a response from the guest';
		float guestPersonality <- responseFromGuest.contents as float;
		//write('contents '+ responseFromGuest.contents);
		list fl<-responseFromGuest.contents;
		//write(fl[0]);
		guestPersonality<-fl[0] as float;
		//write('guestPersonality '+guestPersonality);
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, guestPersonality);
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, guestPersonality);
		}
		self.travel <- false;
		self.wander <- true;
		if (target = 'bar') {
			barMeet <- "mood";
		} 
		else {
			concertMeet <- "mood";
		}
	}


	// not a reflex because we only want to run it when called
	action startConveration {
		list<agent> neighbors <- agents at_distance(1);
		agent neighbor;
		loop n over: neighbors {
			if (n.name != 'ConcertHall0') and (n.name != 'Bar0') {
				neighbor <- n;
			}
		}
		if (target = 'bar') {
			do start_conversation (to::list(neighbor),protocol::'fipa-contract-net',performative::'request',contents::[barPersonality]);
			write 'I ' + self.name + ' have started the conversation with - ' + agent + ' at the bar';
		} else {
			do start_conversation (to::list(neighbor),protocol::'fipa-contract-net',performative::'request',contents::[concertHallPersonality]);
			write 'I ' + self.name + ' have started the conversation with - ' + agent + ' at the concert hall';	
		}
	}

	action changeMood (float personality, float otherAgentPersonality) {
		write('personality '+personality);
		write('otherAgentPersonality '+otherAgentPersonality);
		
		// compute mood based on personality received
		if (personality < otherAgentPersonality) {
			mood <- mood + 1; // guest is greater personality, mood rises
			write 'My ' + self.name + ' mood increased by 1: ' + mood;
		} else if (personality > otherAgentPersonality) {
			mood <- mood - 1; // guest is lower personality, mood falls
			write 'My ' + self.name + ' mood decreased by 1: ' + mood;
		} else {
			mood <- mood + 2; // guest and I are exact matches, mood rises double
			write 'My ' + self.name + ' mood increased by 2: ' + mood;
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
	
	action setIndex(int num){
		index<-num;
	}

	reflex wander when: (wander = true) {
		list<point> clusters <- [{15,15}, {25,25}, {50,50}, {75,75}];
		point cluster <- clusters[rnd(0,3)];
		do goto target:cluster; // go to random cluster and start wandering
		do wander;		
	}

	reflex go_travel when: (travel = true) {
		if (target = 'bar') {
			targetPoint <- {0,0}; // Bar location
			do goto target:targetPoint;
		} else {
			targetPoint <- {100,100};	// Concert hall location
			do goto target:targetPoint;
		}
	}
	
	// This only gets triggered if the agent is at location == target
    reflex findNeighbor when: (location = targetPoint) and (travel = true) {
		list<agent> neighbors <- agents at_distance(1); // finds any agent located at a distance <= 2 from the caller agent. This will only happen if an agent is already at the same target point
		agent neighbor;
		write 'I am ' + self.name + ' and my neighbors are: ' + neighbors;
		loop n over: neighbors {
			if (n.name != 'ConcertHall0') and (n.name != 'Bar0') {
				neighbor <- n;
				write 'I am ' + self.name + ' and my neighbor at ' + target + ' is : ' + neighbor;
			}
		}
		
		if (length(neighbors) <= 1) {
			if (target = 'bar') {
				firstArrivalBar <- self.name;
			}
			else {
				firstArrivalConcertHall <- self.name;
			}
		}
		else { // neighbor is not nil
			write 'I ' + self.name + ' found a neighbor - ' + neighbor;
			if (firstArrivalBar = self.name) or (firstArrivalConcertHall = self.name) {
				// start conversation
				do startConveration;
			}
		}
	}
	
	reflex respondToInitiator when:(!empty(requests)) {
		message requestFromInitiator<-(requests at 0);
		float initiatorPersonality <- requestFromInitiator.contents as float;
		list fl<-requestFromInitiator.contents;
		//write(fl[0]);
		initiatorPersonality<-fl[0] as float;
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [barPersonality]);
			write 'I ' + self.name + ' have responded with my bar personality: ' + barPersonality;
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [concertHallPersonality]);
			write 'I ' + self.name + ' have responded with my concert personality: ' + concertHallPersonality;
		}
		self.travel <- false;
		self.wander <- true;
	}

	reflex readGuestResponse when: (!(empty(informs))) {
		message responseFromGuest <- (informs at 0);
		float guestPersonality <- responseFromGuest.contents as float;
		//write('contents '+ responseFromGuest.contents);
		list fl<-responseFromGuest.contents;
		//write(fl[0]);
		guestPersonality<-fl[0] as float;
		//write('guestPersonality '+guestPersonality);
		
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, guestPersonality);
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, guestPersonality);
		}
		self.travel <- false;
		self.wander <- true;
		if (target = 'bar') {
			barMeet <- "mood";
		} 
		else {
			concertMeet <- "mood";
		}
	}


	// not a reflex because we only want to run it when called
	action startConveration {
		list<agent> neighbors <- agents at_distance(1); // finds any agent located at a distance <= 2 from the caller agent. This will only happen if an agent is already at the same target point
		agent neighbor;
		loop n over: neighbors {
			if (n.name != 'ConcertHall0') and (n.name != 'Bar0') {
				neighbor <- n;
			}
		}
		if (target = 'bar') {
			do start_conversation (to::list(neighbor),protocol::'fipa-contract-net',performative::'request',contents::[barPersonality]);
		} else {
			do start_conversation (to::list(neighbor),protocol::'fipa-contract-net',performative::'request',contents::[concertHallPersonality]);	
		}
	}

	action changeMood (float personality, float otherAgentPersonality) {
		// compute mood based on personality received
		write('personality '+personality);
		write('otherAgentPersonality '+otherAgentPersonality);
		if (personality < otherAgentPersonality) {
			mood <- mood + 1; // guest is greater personality, mood rises
			write 'My ' + self.name + ' mood increased by 1: ' + mood;
		} else if (personality > otherAgentPersonality) {
			mood <- mood - 1; // guest is lower personality, mood falls
			write 'My ' + self.name + ' mood decreased by 1: ' + mood;
		} else {
			mood <- mood + 2; // guest and I are exact matches, mood rises double
			write 'My ' + self.name + ' mood increased by 2: ' + mood;
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
	
	action setIndex(int num){
		index<-num;
	}

	reflex wander when: (wander = true) {
		list<point> clusters <- [{15,15}, {25,25}, {50,50}, {75,75}];
		point cluster <- clusters[rnd(0,3)];
		do goto target:cluster; // go to random cluster and start wandering
		do wander;		
	}

	reflex go_travel when: (travel = true) {
		if (target = 'bar') {
			targetPoint <- {0,0}; // Bar location
			do goto target:targetPoint;
		} else {
			targetPoint <- {100,100};	// Concert hall location
			do goto target:targetPoint;
		}
	}
	
	// This only gets triggered if the agent is at location == target
    reflex findNeighbor when: (location = targetPoint) and (travel = true) {
		list<agent> neighbors <- agents at_distance(1); // finds any agent located at a distance <= 2 from the caller agent. This will only happen if an agent is already at the same target point
		agent neighbor;
		write 'I am ' + self.name + ' and my neighbors are: ' + neighbors;
		loop n over: neighbors {
			if (n.name != 'ConcertHall0') and (n.name != 'Bar0') {
				neighbor <- n;
				write 'I am ' + self.name + ' and my neighbor at ' + target + ' is : ' + neighbor;
			}
		}
		
		if (length(neighbors) <= 1) {
			if (target = 'bar') {
				firstArrivalBar <- self.name;
			}
			else {
				firstArrivalConcertHall <- self.name;
			}
		}
		else { // neighbor is not nil
			write 'I ' + self.name + ' found a neighbor - ' + neighbor;
			if (firstArrivalBar = self.name) or (firstArrivalConcertHall = self.name) {
				// start conversation
				do startConveration;
			}
		}
	}
	
	reflex respondToInitiator when:(!empty(requests)) {
		message requestFromInitiator<-(requests at 0);
		float initiatorPersonality <- requestFromInitiator.contents as float;
		list fl<-requestFromInitiator.contents;
		//write(fl[0]);
		initiatorPersonality<-fl[0] as float;
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [barPersonality]);
			write 'I ' + self.name + ' have responded with my bar personality: ' + barPersonality;
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [concertHallPersonality]);
			write 'I ' + self.name + ' have responded with my concert personality: ' + concertHallPersonality;
		}
		self.travel <- false;
		self.wander <- true;
	}

	reflex readGuestResponse when: (!(empty(informs))) {
		message responseFromGuest <- (informs at 0);
		float guestPersonality <- responseFromGuest.contents as float;
		//write('contents '+ responseFromGuest.contents);
		list fl<-responseFromGuest.contents;
		//write(fl[0]);
		guestPersonality<-fl[0] as float;
		//write('guestPersonality '+guestPersonality);
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, guestPersonality);
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, guestPersonality);
		}
		self.travel <- false;
		self.wander <- true;
		if (target = 'bar') {
			barMeet <- "mood";
		} 
		else {
			concertMeet <- "mood";
		}
	}


	// not a reflex because we only want to run it when called
	action startConveration {
		list<agent> neighbors <- agents at_distance(1); // finds any agent located at a distance <= 2 from the caller agent. This will only happen if an agent is already at the same target point
		agent neighbor;
		loop n over: neighbors {
			if (n.name != 'ConcertHall0') and (n.name != 'Bar0') {
				neighbor <- n;
			}
		}
		if (target = 'bar') {
			do start_conversation (to::list(neighbor),protocol::'fipa-contract-net',performative::'request',contents::[barPersonality]);
		} else {
			do start_conversation (to::list(neighbor),protocol::'fipa-contract-net',performative::'request',contents::[concertHallPersonality]);	
		}
	}

	action changeMood (float personality, float otherAgentPersonality) {
		// compute mood based on personality received
		write('personality '+personality);
		write('otherAgentPersonality '+otherAgentPersonality);
		if (personality < otherAgentPersonality) {
			mood <- mood + 1; // guest is greater personality, mood rises
			write 'My ' + self.name + ' mood increased by 1: ' + mood;
		} else if (personality > otherAgentPersonality) {
			mood <- mood - 1; // guest is lower personality, mood falls
			write 'My ' + self.name + ' mood decreased by 1: ' + mood;
		} else {
			mood <- mood + 2; // guest and I are exact matches, mood rises double
			write 'My ' + self.name + ' mood increased by 2: ' + mood;
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
		rgb agentcolor<- rgb('red');
		draw circle(1) color: agentcolor;
	}
	
	action setIndex(int num){
		index<-num;
	}

	reflex wander when: (wander = true) {
		list<point> clusters <- [{15,15}, {25,25}, {50,50}, {75,75}];
		point cluster <- clusters[rnd(0,3)];
		do goto target:cluster; // go to random cluster and start wandering
		do wander;		
	}

	reflex go_travel when: (travel = true) {
		if (target = 'bar') {
			targetPoint <- {0,0}; // Bar location
			do goto target:targetPoint;
		} else {
			targetPoint <- {100,100};	// Concert hall location
			do goto target:targetPoint;
		}
	}
	
	// This only gets triggered if the agent is at location == target
    reflex findNeighbor when: (location = targetPoint) and (travel = true) {
		list<agent> neighbors <- agents at_distance(1); // finds any agent located at a distance <= 2 from the caller agent. This will only happen if an agent is already at the same target point
		agent neighbor;
		write 'I am ' + self.name + ' and my neighbors are: ' + neighbors;
		loop n over: neighbors {
			if (n.name != 'ConcertHall0') and (n.name != 'Bar0') {
				neighbor <- n;
				write 'I am ' + self.name + ' and my neighbor at ' + target + ' is : ' + neighbor;
			}
		}
		
		if (length(neighbors) <= 1) {
			if (target = 'bar') {
				firstArrivalBar <- self.name;
			}
			else {
				firstArrivalConcertHall <- self.name;
			}
		}
		else { // neighbor is not nil
			write 'I ' + self.name + ' found a neighbor - ' + neighbor;
			if (firstArrivalBar = self.name) or (firstArrivalConcertHall = self.name) {
				// start conversation
				do startConveration;
			}
		}
	}
	
	reflex respondToInitiator when:(!empty(requests)) {
		message requestFromInitiator<-(requests at 0);
		float initiatorPersonality <- requestFromInitiator.contents as float;
		list fl<-requestFromInitiator.contents;
		//write(fl[0]);
		initiatorPersonality<-fl[0] as float;
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [barPersonality]);
			write 'I ' + self.name + ' have responded with my bar personality: ' + barPersonality;
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [concertHallPersonality]);
			write 'I ' + self.name + ' have responded with my concert personality: ' + concertHallPersonality;
		}
		self.travel <- false;
		self.wander <- true;
	}

	reflex readGuestResponse when: (!(empty(informs))) {
		message responseFromGuest <- (informs at 0);
		float guestPersonality <- responseFromGuest.contents as float;
		//write('contents '+ responseFromGuest.contents);
		list fl<-responseFromGuest.contents;
		//write(fl[0]);
		guestPersonality<-fl[0] as float;
		//write('guestPersonality '+guestPersonality);
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, guestPersonality);
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, guestPersonality);
		}
		self.travel <- false;
		self.wander <- true;
		if (target = 'bar') {
			barMeet <- "mood";
		} 
		else {
			concertMeet <- "mood";
		}
	}


	// not a reflex because we only want to run it when called
	action startConveration {
		list<agent> neighbors <- agents at_distance(1); // finds any agent located at a distance <= 2 from the caller agent. This will only happen if an agent is already at the same target point
		agent neighbor;
		loop n over: neighbors {
			if (n.name != 'ConcertHall0') and (n.name != 'Bar0') {
				neighbor <- n;
			}
		}
		if (target = 'bar') {
			do start_conversation (to::list(neighbor),protocol::'fipa-contract-net',performative::'request',contents::[barPersonality]);
		} else {
			do start_conversation (to::list(neighbor),protocol::'fipa-contract-net',performative::'request',contents::[concertHallPersonality]);	
		}
	}

	action changeMood (float personality, float otherAgentPersonality) {
		// compute mood based on personality received
		write('personality '+personality);
		write('otherAgentPersonality '+otherAgentPersonality);
		if (personality < otherAgentPersonality) {
			mood <- mood + 1; // guest is greater personality, mood rises
			write 'My ' + self.name + ' mood increased by 1: ' + mood;
		} else if (personality > otherAgentPersonality) {
			mood <- mood - 1; // guest is lower personality, mood falls
			write 'My ' + self.name + ' mood decreased by 1: ' + mood;
		} else {
			mood <- mood + 2; // guest and I are exact matches, mood rises double
			write 'My ' + self.name + ' mood increased by 2: ' + mood;
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
	
	action setIndex(int num){
		index<-num;
	}

	reflex wander when: (wander = true) {
		list<point> clusters <- [{15,15}, {25,25}, {50,50}, {75,75}];
		point cluster <- clusters[rnd(0,3)];
		do goto target:cluster; // go to random cluster and start wandering
		do wander;		
	}

	reflex go_travel when: (travel = true) {
		if (target = 'bar') {
			targetPoint <- {0,0}; // Bar location
			do goto target:targetPoint;
		} else {
			targetPoint <- {100,100};	// Concert hall location
			do goto target:targetPoint;
		}
	}
	
	// This only gets triggered if the agent is at location == target
    reflex findNeighbor when: (location = targetPoint) and (travel = true) {
		list<agent> neighbors <- agents at_distance(1); // finds any agent located at a distance <= 2 from the caller agent. This will only happen if an agent is already at the same target point
		agent neighbor;
		write 'I am ' + self.name + ' and my neighbors are: ' + neighbors;
		loop n over: neighbors {
			if (n.name != 'ConcertHall0') and (n.name != 'Bar0') {
				neighbor <- n;
				write 'I am ' + self.name + ' and my neighbor at ' + target + ' is : ' + neighbor;
			}
		}
		
		if (length(neighbors) <= 1) {
			if (target = 'bar') {
				firstArrivalBar <- self.name;
			}
			else {
				firstArrivalConcertHall <- self.name;
				write "I am first arrival at concert: " + firstArrivalConcertHall;
			}
		}
		else { // neighbor is not nil
			write 'I ' + self.name + ' found a neighbor - ' + neighbor;
			if (firstArrivalBar = self.name) or (firstArrivalConcertHall = self.name) {
				// start conversation
				do startConveration;
			}
		}
	}
	
	reflex respondToInitiator when:(!empty(requests)) {
		message requestFromInitiator<-(requests at 0);
		float initiatorPersonality <- requestFromInitiator.contents as float;
		list fl<-requestFromInitiator.contents;
		//write(fl[0]);
		initiatorPersonality<-fl[0] as float;
		
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [barPersonality]);
			write 'I ' + self.name + ' have responded with my bar personality: ' + barPersonality;
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, initiatorPersonality);
			// respond with your own personality
			do inform with: (message: requestFromInitiator, contents: [concertHallPersonality]);
			write 'I ' + self.name + ' have responded with my concert personality: ' + concertHallPersonality;
		}
		self.travel <- false;
		self.wander <- true;
	}

	reflex readGuestResponse when: (!(empty(informs))) {
		message responseFromGuest <- (informs at 0);
		
		
		float guestPersonality <- responseFromGuest.contents as float;
		//write('contents '+ responseFromGuest.contents);
		list fl<-responseFromGuest.contents;
		//write(fl[0]);
		guestPersonality<-fl[0] as float;
		//write('guestPersonality '+guestPersonality);
		if (target = 'bar') {
			// compute mood based on personality received
			do changeMood(barPersonality, guestPersonality);
		} else {
			// compute mood based on personality received
			do changeMood(concertHallPersonality, guestPersonality);
		}
		self.travel <- false;
		self.wander <- true;
		if (target = 'bar') {
			barMeet <- "mood";
		} 
		else {
			concertMeet <- "mood";
		}
	}


	// not a reflex because we only want to run it when called
	action startConveration {
		list<agent> neighbors <- agents at_distance(1); // finds any agent located at a distance <= 2 from the caller agent. This will only happen if an agent is already at the same target point
		agent neighbor;
		loop n over: neighbors {
			if (n.name != 'ConcertHall0') and (n.name != 'Bar0') {
				neighbor <- n;
			}
		}
		if (target = 'bar') {
			do start_conversation (to::list(neighbor),protocol::'fipa-contract-net',performative::'request',contents::[barPersonality]);
		} else {
			do start_conversation (to::list(neighbor),protocol::'fipa-contract-net',performative::'request',contents::[concertHallPersonality]);	
		}
	}

	action changeMood (float personality, float otherAgentPersonality) {
		// compute mood based on personality received
		write('personality '+personality);
		write('otherAgentPersonality '+otherAgentPersonality);
		if (personality < otherAgentPersonality) {
			mood <- mood + 1; // guest is greater personality, mood rises
			write 'My ' + self.name + ' mood increased by 1: ' + mood;
		} else if (personality > otherAgentPersonality) {
			mood <- mood - 1; // guest is lower personality, mood falls
			write 'My ' + self.name + ' mood decreased by 1: ' + mood;
		} else {
			mood <- mood + 2; // guest and I are exact matches, mood rises double
			write 'My ' + self.name + ' mood increased by 2: ' + mood;
		}
	}
}

species Bar{
	aspect base{
		draw rectangle(7,4) at: location color: #blue;
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