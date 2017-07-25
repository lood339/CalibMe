from PIL import Image, ImageDraw
import numpy as np
from scipy.cluster.vq import vq, kmeans, whiten
from scipy.spatial.distance import cdist
import matplotlib.pyplot as plt
import cv2
import time

# Computes the cost of given boundaries. Good boundaries have zero cost.
def get_boundaries_cost( boundaries, good_boundaries ):
    return np.sum( boundaries != good_boundaries );

# Finds the indices of color_histograms given a series of cluster centres.
def cluster2boundaries(histograms, centres):

    # Find the cluster assignment of each histogram
    distances = cdist( histograms, centres )
    idx       = np.argmin( distances, 1 )

    # Find the points where the index changes
    boundaries = np.zeros( len(idx)+1, dtype = np.bool )

    for i in range( len(idx)-1 ):
        boundaries[i+1] = idx[i] != idx[i+1];

    return boundaries

# Computes histograms from gray images
def compute_gray_histograms( grays, nbins ):
    gray_hs = np.zeros(( nframes, nbins ), dtype = np.uint16 );

    for i in range( len(grays) ):
        gray_im = grays[i]
        v1 = np.histogram(gray_im.flatten(),bins=nbins, range=(0,255))
        gray_hs[i] = v1[0]

    return gray_hs;


def compute_color_histograms( colors, nbins ):
   color_hs = np.zeros((nframes,3 * nbins),dtype = np.uint16)
   for i in range(len(colors)):
      color_im = colors[i]
      #print(color_im.shape)
      r_his,_ = np.histogram(color_im[:,:,0].flatten(),nbins,(0,255))
      g_his,_ = np.histogram(color_im[:,:,1].flatten(),nbins,(0,255))
      b_his,_ = np.histogram(color_im[:,:,2].flatten(),nbins,(0,255))
      color_hs[i] = np.concatenate((r_his,g_his,b_his)   )   
   return color_hs;
      
# === Main code starts here ===
fname     = 'DataSet_001' # folder name 
nframes   = 1495      # number of frames
im_height = 720        # image height 
im_width  = 1280       # image width

# define the list of (manually determined) shot boundaries here
good_boundaries = [156,400,607,730,907,1159,1303];

# convert good_boundaries list to a binary array
gb_bool = np.zeros( nframes+1, dtype = np.bool )
gb_bool[ good_boundaries ] = True

# Create some space to load the images into memory
colors = np.zeros(( nframes, im_height, im_width, 3), dtype = np.uint8);
grays  = np.zeros(( nframes, im_height, im_width   ), dtype = np.uint8);

# Read the images and store them in color and grayscale formats
for i in range( nframes ):
    imname    = '%s/%d.jpg' % ( fname, i+1 )
    im        = Image.open( imname ).convert( 'RGB' )
    colors[i] = np.asarray(im, dtype = np.uint8)
    grays[i]  = np.asarray(im.convert( 'L' ))

# Initialize color histogram
#nclusters   = 8;
#nbins       = range(2,13)
#gray_costs  = np.zeros( len(nbins) );
#color_costs = np.zeros( len(nbins) );

# === GRAY HISTOGRAMS ===
#for n in nbins:
#   gray_hs = compute_gray_histograms(grays,n)
#   gray_hs_whitened = whiten(gray_hs)
#   karray,dist = kmeans(gray_hs_whitened,nclusters)
#   boundaries = cluster2boundaries(gray_hs_whitened,karray)
#   gray_costs[n-2] = get_boundaries_cost(boundaries,gb_bool)
  
# === END GRAY HISTOGRAM CODE ===
#plt.figure(1);
#plt.xlabel('Number of bins')
#plt.ylabel('Error in boundary detection')
#plt.title('Boundary detection using gray histograms')
#plt.plot(nbins, gray_costs)
#plt.axis([2, 13, -1, 10])
#plt.grid(True)
#plt.show()

# === COLOR HISTOGRAMS ===
#for n in nbins:
#    color_hs = compute_color_histograms(colors,n)
#    color_hs_whitened = whiten(color_hs)
#    karray_color,dist_color = kmeans(color_hs_whitened,nclusters)
#    boundaries_color = cluster2boundaries(color_hs_whitened,karray_color)
#    color_costs[n-2] = get_boundaries_cost(boundaries_color,gb_bool)
    
# === END COLOR HISTOGRAM CODE ===

#plt.figure(2);
#plt.xlabel('Number of bins')
#plt.ylabel('Error in boundary detection')
#plt.title('Boundary detection using color histograms')
#plt.plot(nbins, color_costs)
#plt.axis([2, 13, -1, 10])
#plt.grid(True)
#plt.show()

fdiffs = np.zeros( nframes )
# === ABSOLUTE FRAME DIFFERENCES ===
start1 = time.time()
for n in range(nframes-1):
   current_frame = grays[n].astype(float)
   next_frame = grays[n+1].astype(float)
   fdiffs[n] = sum(sum(cv2.absdiff(current_frame,next_frame)));
   
plt.figure(4)
plt.xlabel('Frame number')
plt.ylabel('Absolute frame difference')
plt.title('Absolute frame differences')
plt.plot(fdiffs)
plt.show()
end1 = time.time()
print(end1 - start1)
sqdiffs = np.zeros( nframes )
# === SQUARED FRAME DIFFERENCES ===
start2 = time.time()
for n in range(nframes-1):
   current_frame = grays[n].astype(float)
   next_frame = grays[n+1].astype(float)
   sqdiffs[n] = sum(sum(cv2.absdiff(current_frame**2,next_frame**2)))
   
plt.figure(5)
plt.xlabel('Frame number')
plt.ylabel('Squared frame difference')
plt.title('Squared frame differences')
plt.plot(sqdiffs)
plt.show()
end2 = time.time()
print(end2 - start2)
avgdiffs = np.zeros( nframes )
# === AVERAGE GRAY DIFFERENCES ===
start3 = time.time()
grays_avg = np.zeros(( nframes, im_height, im_width), dtype = np.float32);
for n in range(nframes):
   grays_avg[n] = np.average(grays[n])
for n in range(nframes - 1):
   avgdiffs[n] = sum(sum(cv2.absdiff(grays_avg[n],grays_avg[n+1])))
   
plt.figure(6)
plt.xlabel('Frame number')
plt.ylabel('Average gray frame difference')
plt.title('Average gray frame differences')
plt.plot(avgdiffs)
plt.show()
end3 = time.time()
print(end3 - start3)
histdiffs = np.zeros( nframes )
# === HISTOGRAM DIFFERENCES ===
#gray_hs = compute_gray_histograms(grays,10)
#for n in range(nframes-1):
#   histdiffs[n] = sum(cdist([gray_hs[n]],[gray_hs[n+1]],'euclidean'))
#
#plt.figure(7)
#plt.xlabel('Frame number')
#plt.ylabel('Histogram frame difference')
#plt.title('Histogram frame differences')
#plt.plot(histdiffs)
#plt.show()
