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


# Collision Warning and Automatic Speed Control
Using Simulink.
Phase 6 detects when a vehicle/object is too close, gives a collision warning and automatically reduces the vehicle speed from 40 km/h to 20 km/h.
