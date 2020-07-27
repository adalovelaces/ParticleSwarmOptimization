import plotFigures as plt_fig
import plotDisplay as plt_disp
import getData as dt_getter
import numpy as numpy

global SIM_COUNT
global ITER_COUNT

global PLOT_INDEXES
global PLOT_LIST
global PLOT_TITLES

global NH_TITLES
global NH_LIST

global minimum
global FONTSIZE_TICK

minimum = 0.01
FONTSIZE_TICK = 28


PLOT_INDEXES = []
PLOT_LIST = []
NH_TITLES = []
NH_LIST = []



#===================================#
#             INIT                  #
#===================================#

def init( sim_count, iter_count, plot_indexes, plot_list, nh_list, nh_titles ):

    global SIM_COUNT
    global ITER_COUNT
    global PLOT_INDEXES
    global PLOT_LIST
    global NH_TITLES
    global NH_LIST
    global PLOT_TITLES

    SIM_COUNT = sim_count
    ITER_COUNT = iter_count
    PLOT_INDEXES = plot_indexes
    PLOT_LIST = plot_list
    NH_LIST = nh_list

    PLOT_TITLES = plt_disp.get_types()

    plt_disp.init( nh_titles )

    plt_fig.init( plot_indexes, plot_list, nh_titles, nh_list )


def init_fig( vf, of, nh_list, nh ):

    plt_fig.init_figures( vf, of, nh_list, nh )

def export_figure( root_path, setting, nh, swarm ):

    plt_fig.export_figure( root_path, setting, nh, swarm )

def close_figures( nh ):

    plt_fig.close_figures( nh )

#===================================#
#         PLOT SIMPLE DATA          #
#===================================#

def make_line( data, nh, swarm, index ):

    iter_data = dt_getter.get_iter_data( data )

    axes = plt_fig.get_axes( index, nh )

    plot_error_shadow( axes[0], swarm, iter_data )

def plot_error_shadow( axes, swarm, iter_data ):

    color = plt_disp.get_color( swarm )
    marker = plt_disp.get_marker( swarm )
    label = plt_disp.get_label( swarm )
    linestyle = plt_disp.get_linestyle( swarm )

    iter_mean = dt_getter.get_iter_mean( iter_data )

    x = numpy.array( range( 1, len( iter_mean ) + 1 ) )
    y = iter_mean
    error = dt_getter.get_iter_stderror( iter_data )

    ymax = [ ]
    ymin = [ ]

    for i in range( 0, len( y ) ):
        ymin.append( y[ i ] - error[ i ] )
        ymax.append( y[ i ] + error[ i ] )

    x_reduced = x[1::4].copy()
    y_reduced = y[1::4].copy()
    axes.plot( x_reduced, y_reduced, marker = marker, markersize = 5, color=color, linestyle=linestyle, label=label )

    axes.fill_between( x, ymax, ymin, color=color, alpha=0.3 )

    #axes.legend()

def make_line_two( data_1, data_2, nh, swarm, index ):

    iter_data_1 = dt_getter.get_iter_data( data_1 )
    iter_data_2 = dt_getter.get_iter_data( data_2 )

    axes = plt_fig.get_axes( index, nh )

    plot_error_shadow_two( axes, swarm, iter_data_1, iter_data_2 )

def plot_error_shadow_two( axes, swarm, iter_data_1, iter_data_2 ):

    if( "PPSO" in swarm ):
        axes = axes[0]
    else:
        axes = axes[1]

    old_swarm = swarm
    swarm = swarm[5:]

    color = plt_disp.get_color( swarm )
    marker = plt_disp.get_marker( swarm )
    label = plt_disp.get_label( swarm )
    linestyle = plt_disp.get_linestyle( swarm )

    iter_mean_1 = dt_getter.get_iter_mean( iter_data_1 )
    iter_mean_2 = dt_getter.get_iter_mean( iter_data_2 )

    x = numpy.array( range( 1, len( iter_mean_1 ) + 1 ) )
    y_1 = iter_mean_1
    y_2 = iter_mean_2
    error_1 = dt_getter.get_iter_stderror( iter_data_1 )
    error_2 = dt_getter.get_iter_stderror( iter_data_2 )

    ymax = [ ]
    ymin = [ ]

    for i in range( 0, len( y_1 ) ):
        ymin.append( y_1[ i ] - error_1[ i ] )
        ymax.append( y_1[ i ] + error_1[ i ] )

    x_reduced = x[ 1::7 ].copy()
    y_1_reduced = y_1[ 1::7 ].copy()

    axes.plot( x_reduced, y_1_reduced, marker = marker, markersize = 5, color=color, linestyle=linestyle, label=label )
    axes.fill_between( x, ymax, ymin, color=color, alpha=0.3 )

    ax_2 = axes.twinx()

    y_2[ 0 ] = y_2[ 2 ]
    y_2[ 1 ] = y_2[ 2 ]
    y_2_reduced = y_2[ 1::7 ].copy()


    ymax = [ ]
    ymin = [ ]

    for i in range( 0, len( y_2 ) ):
        ymin.append( y_2[ i ] - error_2[ i ] )
        ymax.append( y_2[ i ] + error_2[ i ] )

    ax_2.set_ylim( [ 0, 180 ] )
    ax_2.set_xlim( [ 0, 150 ] )

    axes.xaxis.set_ticks( numpy.arange( 0, 150, 25 ) )

    marker = plt_disp.get_marker( swarm + "2" )
    color = plt_disp.get_color( swarm + "2" )
    marker = plt_disp.get_marker( swarm + "2" )
    linestyle = plt_disp.get_linestyle( swarm + "2" )

    ax_2.plot( x_reduced, y_2_reduced, marker = marker, markersize = 5, color=color, linestyle=linestyle, label=label, alpha=0.7 )
    ax_2.fill_between( x, ymax, ymin, color=color, alpha=0.2 )
    ax_2.tick_params( axis='both', which='major', labelsize=FONTSIZE_TICK, direction='in' )

    if( "PPSO" in old_swarm ):
        ax_2.set_yticklabels( [] )
        ax_2.set_yticks( [] )

    if( "ZPSO" in old_swarm ):
        #axes.set_yticks([])
        ax_2.spines[ 'right' ].set_color( '#cf9d1f' )
        ax_2.tick_params( axis='y', colors='#cf9d1f' )
        ax_2.yaxis.label.set_color( '#cf9d1f' )



