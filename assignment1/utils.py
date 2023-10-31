import matplotlib.pyplot as plt


def pflat(p):
  """
  Divide by last coordinate to
  normalize the homogeneous coordinates
  """
  return p/p[-1]


def plot_points_2D(p):
  """
  Plot 2D points
  """
  plt.plot(p[0, :], p[1, :], marker='.', markersize=0.5)
  
  
def plot_points_3D(p):
  """
  Plot 3D points
  """
  plt.axes(projection='3d').plot3D(p[0, :], p[1, :], p[2, :], marker='.', markersize=1)
  plt.show()
