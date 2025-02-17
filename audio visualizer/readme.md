# audio visualizer
you can download the audiovisualizer in this folder to see how the parts change size or color based on the music's frequency data
below is a brief overview of how it works:

1. **attachment:**  
   the system welds visualizer parts to the player's character so they move with you in-game  

2. **audio analysis:**  
   an `audioanalyzer` object retrieves frequency spectrum data from the audio source in real time  

3. **visual effects:**  
   several scripts (`rainbow`, `volumebased`, `bpmbased`) use the frequency data to dynamically change part sizes, colors, or other properties  

4. **listener setup:**  
   an `audiolistener` is attached to the camera for accurate playback, while an `audiodeviceoutput` object handles the audio processing

to see how it works:
- open the file in roblox studio  
- press play and watch

you can further modify the scripts or integrate your own audio assets for different visual effects  
