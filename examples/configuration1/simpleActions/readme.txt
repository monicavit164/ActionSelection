
This example shows how to train and test the adaptive action selection algorithm for an initial configuration composed of:

- one server s1
- two virtual machines deployed on S1, VM1 and VM2.

Available actions are:
- migration
- resources reconfiguration
- turn on and off of a server.

The ActionTraining.m is used to train the algorithm and as a result prints the quality matrix, representing the likelihood of impact of each action over each indicator.

The ActionTesting.m is used to test the algorithm at an increasing load. It returns a plot which compares the initial distance with the final distance at each load rate and the count of the number of times each action has been executed. 
