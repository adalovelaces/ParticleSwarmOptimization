import matplotlib.pyplot as plt
import matplotlib as mpl
import numpy as np
import os
from pathlib import Path
import matplotlib.patches as mpatches


path = str( Path.home() ) + "\\Desktop\\PythonPlots\\"
path_png = path + "PNG\\"
path_pdf = path + "PDF\\"

#============================== PLOT ENERGY FUNCTION LINE

def plotEnergyLine():

    if not os.path.exists( path_png ):
        os.makedirs( path_png )

    if not os.path.exists( path_pdf ):
        os.makedirs( path_pdf )


    # GET DATA ENERGY MODEL
    energy_x1 = np.linspace( 0, 180, 180 )
    energy_y1 = ( 10**( energy_x1 / 360 ) )*( energy_x1 - 150 ) + 150

    energy_x2 = np.linspace( 180, 0, 180 )
    energy_y2 = ( 10**( ( energy_x2 ) / 360 ) ) * ( ( energy_x2 ) - 150 ) + 150

    energy_x3 = np.linspace( -180, 0, 180 )

    # INIT FIGURE AND AXES
    fig_energy = plt.figure()
    ax_energy = fig_energy.add_subplot( 1, 1, 1 )
    ax_energy.set_xlabel( 'Angle', fontsize=10 )
    ax_energy.set_ylabel( 'Energy', fontsize=10 )

    # ADDITIONAL
    # cbax = fig.add_axes([0.85, 0.12, 0.05, 0.78])
    # cb = mpl.colorbar.ColorbarBase(cbax, cmap=cmap, norm=normalize, orientation='vertical')
    # cb.set_label("Energy Function", rotation=270, labelpad=15)

    # PLOT ENERGY FUNCTION
    plt.plot( energy_x1, energy_y1, 'black' )
    plt.plot( energy_x3, energy_y2, 'black' )

    # SET COLOR MAP
    #cmap = mpl.cm.bwr
    cmap = mpl.cm.get_cmap('YlOrRd')

    energy_z1 = energy_x1
    energy_z2 = energy_x2

    npts = 180
    normalize1 = mpl.colors.Normalize( vmin = energy_z1.min(), vmax = energy_z1.max() )
    normalize2 = mpl.colors.Normalize( vmin=energy_z2.min(), vmax=energy_z2.max() )

    # PLOT COLOR
    for i in range( npts - 1 ):
        plt.fill_between( [ energy_x1[i], energy_x1[i+1] ], [ energy_y1[i], energy_y1[i+1] ], color = cmap( normalize1( energy_z1[i] )))
    for i in range( npts - 1 ):
        plt.fill_between( [ energy_x3[i], energy_x3[i+1] ], [ energy_y2[i], energy_y2[i+1] ], color = cmap( normalize2( energy_z2[i] )))

    # SHOW PLOT
    #plt.show()

    # SAVE PLOT
    fig_energy.savefig( path_png + 'energy_plot.png', bbox_inches='tight' )
    fig_energy.savefig( path_pdf + 'energy_plot.pdf', bbox_inches='tight', dpi=300 )

    plt.close( fig_energy )

#============================== PLOT ENERGY FUNCTION CIRCLE

def plotEnergyCircle():

    color = mpl.cm.get_cmap('YlOrRd')

    angle1 = np.arange( 0, 181, 1 )

    angle2 = np.arange( 180, 361, 1 )
    angle3 = np.arange( 361, 180, -1 )
    zeniths = np.arange( 0, 30, 1 )
    values1 = angle1 * np.ones( (30, 181) )
    values2 = angle3 * np.ones( (30, 181) )


    fig, ax = plt.subplots( subplot_kw=dict( projection='polar' ) )
    pcol = ax.pcolormesh( angle1 * np.pi / 180.0, zeniths, values1, cmap=color, linewidth=0, rasterized=True )
    pcol.set_edgecolor('face')
    pcol = ax.pcolormesh( angle2 * np.pi / 180.0, zeniths, values2, cmap=color, linewidth=0, rasterized=True )
    pcol.set_edgecolor('face')
    ax.set_yticks( [ ] )
    ax.set_xticklabels([0,45,90,135,180,-135,-90,-45])
    ax.spines['polar'].set_visible(False)
    #np.pi / 180. * np.linspace(180, -180, 8, endpoint=False)
    ax.set_theta_zero_location("N")


    arrow = mpatches.FancyArrowPatch( (0,0), (0, 29), color='black', mutation_scale=1 , label='wind')
    arrow.set_arrowstyle("simple", head_length=5, head_width=5)
    ax.add_patch( arrow )

    #plt.show()

    # SAVE PLOT
    fig.savefig( path_png + 'energy_circle.png', bbox_inches='tight' )
    fig.savefig( path_pdf + 'energy_circle.pdf', bbox_inches='tight', dpi=300 )

    plt.close(fig)


#============================== PROGRAM BEGINNING


print("START PLOTTING FOR THESIS")

plotEnergyLine()
plotEnergyCircle()