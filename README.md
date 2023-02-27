# bollix

## PLAN
Overview: Open up the app and it will show your camera pointing at a pool table, overlaying best shots in AR.

- [ ] 1. Set up Unity AR-Core/AR-Kit and development environment. Likely Cloud GPU machine on Google Cloud or AR-CORE.
- [ ] 2. Build plane detection system for pool table.
  - [ ] 2.1 Use unity AR's built-in plane detection
  - [ ] 2.2 Match from the list of detected planes using expected pool table dimensions.
  - [ ] 2.3 calculate location of pockets from pool table plane.
  - [ ] 2.4 extra validation if needed.
- [ ] 3. ball detection system.
  - [ ] 3.1 Train a pool ball segmentation model in TensorFlow-Lite. Make sure it collects all balls, along with ball number.
  - [ ] 3.2 use TensorFlow Lite Converter to get trained model into format for TensorFlowSharp (import TensorFlowSharp plugin in unity)
  - [ ] 3.3 use trained model to collect ball boundaries and numbers.
  - [ ] 3.4 map object in image to ground position.
- [ ] 4. Build Pool Cue object
  - [ ] 4.1 object that has trajectory, power, and english
  - [ ] 4.2 maps to 3d-model that displays each of these attributes on table, along with model of the actual pool cue.
- [ ] 5. build shot calculator
  - [ ] 5.1 ball-level shot calculator: use ball-level information (ball location, pocket, walls, geometry, english) to create a simplified pool physics calculator for single shot. Needs a rating system for shot difficulty. Returns pool cue object.
  - [ ] 5.2 table-level shot calculator: use table-level information (next few shots) to iterate through shot calculator and select best shot on table.
  - [ ] 5.3 shot-explorer: floating trajectory is given on arbitrary pool cue positions based on user input, balls and walls.
- [ ] 7. Allow pool cue to be interacted with user input.
- [ ] 8. User interactivity:
  - [ ] 8.0 table and balls are detected
  - [ ] 8.1 when table is clicked on, table-level shot calculator is run, Pool Cue is overlayed.
  - [ ] 8.2 when ball is clicked on, ball-level shot calculator is calculated, Pool Cue is overlayed.
  - [ ] 8.3when cue is dragged, shot-explorer is calculated, Pool Cue is overlayed.

Requirements:
1. Performant; Make sure renderer and detector is lightweight
2. Monetizable; Make sure you can resell while using built-in object detection, etc.

Other Features:
  1. Training setups. ie. 30 degree line system for setting up shots. etc.
