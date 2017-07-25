# shot.py
This is used to segment different cameras from a video sequence.
Three methods are provided: absolute frame differences,squared frame differences, average frame differences.
Use this by change parameters as follows:
line 52:fname
line 53:nframes
line 54:im_height
line 55:im_width
line 70:imname

The average frame differences method is quite fit to solve the problem, since it shows the clearest peaks(change points of cameras) in the curve.
