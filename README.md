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

# Phase 1: Lane detection Pipeline
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

# Phase 2 — Vehicle Detection and Tracking

Road Video → Vehicle Detection → Vehicle Classification → Vehicle Position Analysis → Vehicle Counting → Multi-Vehicle Tracking

Phase 2 helps the system understand the vehicles present on the road.
It detects vehicles and draws bounding boxes around them.
The system identifies vehicle types such as car, truck, and bus.
It calculates their position as left, center, or right in the camera view.
Finally, it tracks vehicles across multiple frames using unique IDs.


# Phase 3 — Vehicle State Information

Vehicle Detection Data → Vehicle Position → Speed Information → Distance Estimation → Lateral Position → Vehicle State Summary

Phase 3 converts the detected vehicle data into useful driving-state information.
It includes information about the ego vehicle, such as speed and current lane.
The system estimates the distance of surrounding vehicles.
It also calculates their approximate lateral position.
All this information is combined to understand the current traffic situation.


# Phase 4 — ADAS Lane Guidance

Vehicle State Information → Speed + Distance + Lane + Vehicle Type → Decision Fusion → ADAS Guidance → Safety Action

Phase 4 uses the information from the previous phases to make decisions.
It checks vehicle speed, distance, lane position, and vehicle type.
The system recommends a lane and checks whether a lane change is needed.
It also generates warnings such as slow down or maintain safe distance.
Finally, all inputs are combined to produce an ADAS safety decision.



# Phase 5 — Integrated ADAS System

Road Video → Lane Detection + Vehicle Detection → Vehicle State Analysis → ADAS Decision → HUD Visualization → Continuous Processing → Validation

Phase 5 connects all the previous phases into one complete ADAS system.
The system detects both lanes and surrounding vehicles from the road video.
It calculates vehicle state information such as distance and position.
Then, the ADAS decision logic generates appropriate safety guidance.
The final output is displayed continuously through an ADAS HUD/dashboard, and the system performance is measured and validated.

# Phase 6: Collision Warning and Automatic Speed Control
Using Simulink.
Basically Phase 6 detects when a vehicle/object is too close, gives a collision warning and automatically reduces the vehicle speed from 40 km/h to 20 km/h.
