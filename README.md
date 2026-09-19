# ADAS-LANE-DETECTION
My M.tech Project

# Project Objective

The project aims to develop an ADAS (Advanced Driver Assistance System) prototype capable of understanding the road environment and providing lane-related guidance to the driver.

The initial system takes a road-driving video as input and processes it using computer vision and deep learning to:

Detect lane boundaries
Estimate the vehicle's current/ego lane
Obtain vehicle information such as type and speed
Recommend a suitable lane
Display the information through an ADAS-style visual interface

The project is being developed in MATLAB R2026a.

# 1: Lane detection Pipeline
Road Video
     ↓
Frame Extraction
     ↓
Image Processing
     ↓
Edge Detection
     ↓
Region of Interest (ROI)
     ↓
Hough Line Detection
     ↓
Lane Candidate Filtering
     ↓
Left / Right Lane Identification
     ↓
Deep Learning Lane Detection
     ↓
Lane Boundary Modeling
     ↓
Current/Ego Lane Estimation
     ↓
ADAS Visualization

# 2 — Vehicle Detection and Tracking

Road Video → Vehicle Detection → Vehicle Classification → Vehicle Position Analysis → Vehicle Counting → Multi-Vehicle Tracking

Phase 2 helps the system understand the vehicles present on the road.
It detects vehicles and draws bounding boxes around them.
The system identifies vehicle types such as car, truck, and bus.
It calculates their position as left, center, or right in the camera view.
Finally, it tracks vehicles across multiple frames using unique IDs.


# 3 — Vehicle State Information

Vehicle Detection Data → Vehicle Position → Speed Information → Distance Estimation → Lateral Position → Vehicle State Summary

Phase 3 converts the detected vehicle data into useful driving-state information.
It includes information about the ego vehicle, such as speed and current lane.
The system estimates the distance of surrounding vehicles.
It also calculates their approximate lateral position.
All this information is combined to understand the current traffic situation.


# 4 — ADAS Lane Guidance

Vehicle State Information → Speed + Distance + Lane + Vehicle Type → Decision Fusion → ADAS Guidance → Safety Action

Phase 4 uses the information from the previous phases to make decisions.
It checks vehicle speed, distance, lane position, and vehicle type.
The system recommends a lane and checks whether a lane change is needed.
It also generates warnings such as slow down or maintain safe distance.
Finally, all inputs are combined to produce an ADAS safety decision.



# 5 — Integrated ADAS System

Road Video → Lane Detection + Vehicle Detection → Vehicle State Analysis → ADAS Decision → HUD Visualization → Continuous Processing → Validation

Phase 5 connects all the previous phases into one complete ADAS system.
The system detects both lanes and surrounding vehicles from the road video.
It calculates vehicle state information such as distance and position.
Then, the ADAS decision logic generates appropriate safety guidance.
The final output is displayed continuously through an ADAS HUD/dashboard, and the system performance is measured and validated.

# 6: Collision Warning and Automatic Speed Control
Using Simulink.
Basically Phase 6 detects when a vehicle/object is too close, gives a collision warning and automatically reduces the vehicle speed from 40 km/h to 20 km/h.


# 7: focused on improving the simulation environment rather than changing the core ADAS logic.
The model was configured to use a fixed-step discrete solver, making it suitable for the current ADAS decision-based system. Performance monitoring scopes were added to observe the behavior of the Lane Departure Warning, Collision Warning, AEB system, and vehicle speed.

# 8: 
Implemented virtual CAN communication in Simulink to transmit vehicle-speed data, receive and decode it, and use the CAN-received speed in our ADAS system for collision warning and AEB testing.

SIL Validation: Implemented Software-in-the-Loop simulation to validate the ADAS controller before hardware deployment. The controller was tested with different vehicle-speed and distance conditions, and the SIL outputs were verified against the expected collision-warning and AEB responses.

# 9:
successfully demonstrated Software-in-the-Loop validation and a HIL-style closed-loop simulation of the ADAS controller. MATLAB lane information, CAN vehicle-speed communication, Stateflow decision logic, collision detection, AEB, automatic speed control, and the simulated vehicle plant were integrated into a common test environment. The controller produced the expected responses for normal driving, collision-warning, and emergency-braking scenarios, and the SIL results were consistent with the original Simulink controller for the tested conditions.

