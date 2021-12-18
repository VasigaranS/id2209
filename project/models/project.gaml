/**
* Name: NewModel
* Based on the internal empty template. 
* Author: vasigarans and aykhazanchi
* Tags: 
*/


model NewModel

/* Insert your model definition here */

global
{
int noAgents<-10;

init{
	
	
		create BarAgent with:(location:point (15,15));
		create ConcertAgent with:(location:point (60,60));
		create RockAgent number:noAgents
			{
		 
			}
		create IndieAgent number:noAgents
		{
		 
		}
		create PopAgent number:noAgents
		{
		 
		}
		create ClassicalAgent number:noAgents
		{
		 
		}
		create RapAgent number:noAgents
		{
		 
		}
		

		
	
		
		
		}
}


species RockAgent skills:[moving]{
	
	
	
	aspect base{
	rgb agentcolor<- rgb('purple');
	

	

	draw circle(1) color: agentcolor;
	
	}
	
	reflex wander
	{
		

		do wander;
		
	}
	
}



species RapAgent skills:[moving]{
	
	
	
	
	aspect base{
	rgb agentcolor<- rgb('orange');
	

	

	draw circle(1) color: agentcolor;
	
	}
	
	reflex wander
	{

		do wander;
		
	}
	
}


species ClassicalAgent skills:[moving]{
	
	
	
	aspect base{
	rgb agentcolor<- rgb('pink');
	

	

	draw circle(1) color: agentcolor;
	
	}
	
	reflex wander
	{
		

		do wander;
		
	}
	
}



species PopAgent skills:[moving]{
	
	
	
	aspect base{
	rgb agentcolor<- rgb('blue');
	

	

	draw circle(1) color: agentcolor;
	
	}
	
	reflex wander
	{

		do wander;
		
	}
	
}


species IndieAgent skills:[moving]{
	
	
	
	
	aspect base{
	rgb agentcolor<- rgb('black');
	

	

	draw circle(1) color: agentcolor;
	
	}
	
	reflex wander
	{

		do wander;
		
	}
	
}



species BarAgent{
	
aspect base{
		draw rectangle(7,4) at: location color: #yellow;
	}
}


species ConcertAgent{
	
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
			species RockAgent aspect:base;
			species IndieAgent aspect:base;
			species PopAgent aspect:base;
			species ClassicalAgent aspect:base;
			species RapAgent aspect:base;
			species BarAgent aspect:base;
			species ConcertAgent aspect:base;
		}
}
}