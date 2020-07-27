import matplotlib.pyplot as plt
import plotDisplay as plt_disp
import os
import seaborn as sns

global PLOT_INDEXES
global PLOT_LIST
global NH_TITLES
global NH_LIST

global FONTSIZE_TICK
global FONTSIZE_LABEL
global FONTSIZE_TITLE

global FIG_CONV
global FIG_ENERGY
global FIG_ACCU
global FIG_ORIENT
global FIG_INTERDIST
global FIG_DIST_PARTICLE
global FIG_DIST_CENTER
global FIG_PARETO

global FIG_CONV_ALL
global FIG_ENERGY_ALL
global FIG_ACCU_ALL
global FIG_ORIENT_ALL
global FIG_INTERDIST_ALL
global FIG_DIST_PARTICLE_ALL
global FIG_DIST_CENTER_ALL
global FIG_PARETO_ALL

FIG_CONV = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
FIG_ENERGY = [0,0,0,0,0,0,0,0,0,0,0,0,0]
FIG_ACCU = [0,0,0,0,0,0,0,0,0,0,0,0,0]
FIG_ORIENT = [0,0,0,0,0,0,0,0,0,0,0,0,0]
FIG_INTERDIST = [0,0,0,0,0,0,0,0,0,0,0,0,0]
FIG_DIST_PARTICLE = [0,0,0,0,0,0,0,0,0,0,0,0,0]
FIG_DIST_CENTER = [0,0,0,0,0,0,0,0,0,0,0,0,0]
FIG_PARETO = [0,0,0,0,0,0,0,0,0,0,0,0,0]

FONTSIZE_TICK = 28
FONTSIZE_LABEL = 32
FONTSIZE_TITLE = 32
FONTSIZE_LEGEND = 28

MARKERSIZE_LEGEND = 2

NH_LIST = []

#===================================#
#               INIT                #
#===================================#

def init( plot_indexes_in, plot_list_in, nh_titles, nh_list ):

    global PLOT_INDEXES
    global PLOT_LIST
    global NH_TITLES
    global NH_LIST

    PLOT_INDEXES = plot_indexes_in
    PLOT_LIST = plot_list_in
    NH_TITLES = nh_titles
    NH_LIST = nh_list


    plt_disp.init( nh_titles )

def init_figures_conv( fig, title ):

    with sns.axes_style( "white" ):

        ax = fig.add_subplot( 111 )
        ax.set_xlabel( 'Iteration', fontsize=FONTSIZE_LABEL )
        ax.set_ylabel( 'Mean GBest', fontsize=FONTSIZE_LABEL )
        ax.tick_params( axis='both', which='major', labelsize=FONTSIZE_TICK, direction='in' )
        ax.set_yscale( 'log' )
        ax.set_title( title, fontsize=FONTSIZE_TITLE )

def init_figures_pareto( fig, title ):

    ax = fig.add_subplot( 111 )
    ax.set_xlabel( 'Iteration Optimum found', fontsize=FONTSIZE_LABEL )
    ax.set_ylabel( 'Used Energy', fontsize=FONTSIZE_LABEL )
    ax.tick_params( axis='both', which='major', labelsize=FONTSIZE_TICK, direction='in' )
    ax.set_title( title, fontsize=FONTSIZE_TITLE )

def init_figures_energy( fig, title ):

    ax = fig.add_subplot( 111 )
    ax.set_xlabel( 'Iteration', fontsize=FONTSIZE_LABEL )
    ax.set_ylabel( 'Energy', fontsize=FONTSIZE_LABEL )
    ax.tick_params( axis='both', which='major', labelsize=FONTSIZE_TICK, direction='in' )
    ax.set_title( title, fontsize=FONTSIZE_TITLE )

def init_figures_accu( fig, title ):

    with sns.axes_style( "white" ):
        ax = fig.add_subplot( 111 )
        ax.set_ylabel( 'Accumulation Rate', fontsize=FONTSIZE_LABEL )
        ax.tick_params( axis='both', which='major', labelsize=FONTSIZE_TICK, direction='in' )
        ax.set_title( title, fontsize=FONTSIZE_LABEL )
        ax.set_xlabel( 'Iteration', fontsize=FONTSIZE_LABEL )

def init_figures_orient( axes ):
    with sns.axes_style( "white" ):


        ax = axes[0]#fig.add_subplot( 121 )
        ax.set_title( "PPSO", fontsize=FONTSIZE_LABEL )
        ax.set_ylabel( 'Orientation', fontsize=FONTSIZE_LABEL )
        ax.set_xlabel( 'Iteration', fontsize=FONTSIZE_LABEL )
        ax.tick_params( axis='both', which='major', labelsize=FONTSIZE_TICK, direction='in' )
        ax.set_yscale( 'log' )

        ax2 = axes[1]#fig.add_subplot( 122 )
        ax2.set_title( "ZPSO", fontsize=FONTSIZE_LABEL )
        ax2.tick_params( axis='both', which='major', labelsize=FONTSIZE_TICK, direction='in', length=0 )
        ax2.set_xlabel( 'Iteration', fontsize=FONTSIZE_LABEL )
        ax2.set_yscale( 'log' )






def init_figures_interdist( fig, title ):
    with sns.axes_style( "white" ):
        ax = fig.add_subplot( 111 )
        ax.set_ylabel( 'Distance', fontsize=FONTSIZE_LABEL )
        ax.set_title( title, fontsize=FONTSIZE_LABEL )
        ax.set_xlabel( 'Iteration', fontsize=FONTSIZE_LABEL )
        ax.tick_params( axis='both', which='major', labelsize=FONTSIZE_TICK, direction='in' )

def init_figures_dist_particle( fig, title ):
    with sns.axes_style( "white" ):
        ax = fig.add_subplot( 111 )
        ax.set_ylabel( 'Distance', fontsize=FONTSIZE_LABEL )
        ax.set_title( title, fontsize=FONTSIZE_LABEL )
        ax.set_xlabel( 'Iteration', fontsize=FONTSIZE_LABEL )
        ax.tick_params( axis='both', which='major', labelsize=FONTSIZE_TICK, direction='in' )

def init_figures_dist_center( fig, title ):

    with sns.axes_style( "white" ):
        ax = fig.add_subplot( 111 )
        ax.set_ylabel( 'Distance', fontsize=FONTSIZE_LABEL )
        ax.set_title( title, fontsize=FONTSIZE_LABEL )
        ax.set_xlabel( 'Iteration', fontsize=FONTSIZE_LABEL )
        ax.tick_params( axis='both', which='major', labelsize=FONTSIZE_TICK, direction='in' )

def init_figures( vf, of, nh_list, nh ):

    plt.close( 'all' )

    sns.set_style( "white" )
    sns.set_context( 'talk', font_scale=2 )

    init_figures_two_swarms( vf, of, nh_list, nh )

def init_figures_two_swarms( vf, of, nh_list, nh ):

    global PLOT_INDEXES

    global FIG_CONV
    global FIG_ENERGY
    global FIG_ACCU
    global FIG_ORIENT
    global FIG_INTERDIST
    global FIG_DIST_PARTICLE
    global FIG_DIST_CENTER
    global FIG_PARETO

    sw_title = ""  # ""ALG: " + swarm + " "
    vf_title = "VF: " + plt_disp.get_title_vf( vf ) + " "
    of_title = "OF: " + plt_disp.get_title_of( of ) + " "
    nh_titles = plt_disp.get_nh_titles( nh )

    if 1 in PLOT_INDEXES:
        # for nh in nh_list:

        nh_num = plt_disp.get_nh_num( nh )
        FIG_CONV[ nh_num ] = plt.figure( figsize=(10, 8) )
        title = sw_title + vf_title + of_title + "NH: " + nh_titles
        init_figures_conv( FIG_CONV[ nh_num ], title )

    if 4 in PLOT_INDEXES:
        # for nh in nh_list:

        nh_num = plt_disp.get_nh_num( nh )
        FIG_ENERGY[ nh_num ] = plt.figure( figsize=(10, 8) )
        title = sw_title + vf_title + of_title + "NH: " + nh_titles
        init_figures_energy( FIG_ENERGY[ nh_num ], title )

    if 8 in PLOT_INDEXES:
        # for nh in nh_list:

        nh_num = plt_disp.get_nh_num( nh )
        FIG_ACCU[ nh_num ] = plt.figure( figsize=(10, 8) )
        title = sw_title + vf_title + of_title + "NH: " + nh_titles
        init_figures_accu( FIG_ACCU[ nh_num ], title )

    if 9 in PLOT_INDEXES:
        # for nh in nh_list:

        nh_num = plt_disp.get_nh_num( nh )
        fig, axes = plt.subplots( 1, 2, sharey=True, figsize=(12, 8) )
        title = sw_title + vf_title + of_title + "NH: " + nh_titles
        fig.suptitle( title, fontsize=FONTSIZE_TITLE )
        #FIG_ORIENT[ nh_num ] = plt.figure( figsize=(10, 8) )
        FIG_ORIENT[ nh_num ] = fig
        init_figures_orient( axes )

        fig.subplots_adjust( left=None, bottom=None, right=None, top=None, wspace=0, hspace=0.01 )

    if 10 in PLOT_INDEXES:
        #        for nh in nh_list:

        nh_num = plt_disp.get_nh_num( nh )
        FIG_INTERDIST[ nh_num ] = plt.figure( figsize=(10, 8) )
        title = sw_title + vf_title + of_title + "NH: " + nh_titles
        init_figures_interdist( FIG_INTERDIST[ nh_num ], title )

    if 11 in PLOT_INDEXES:
        #        for nh in nh_list:

        nh_num = plt_disp.get_nh_num( nh )
        FIG_DIST_PARTICLE[ nh_num ] = plt.figure( figsize=(10, 8) )
        title = sw_title + vf_title + of_title + "NH: " + nh_titles
        init_figures_dist_particle( FIG_DIST_PARTICLE[ nh_num ], title )

    if 12 in PLOT_INDEXES:
        #        for nh in nh_list:

        nh_num = plt_disp.get_nh_num( nh )
        FIG_DIST_CENTER[ nh_num ] = plt.figure( figsize=(10, 8) )
        title = sw_title + vf_title + of_title + "NH: " + nh_titles
        init_figures_dist_center( FIG_DIST_CENTER[ nh_num ], title )


#===================================#
#               GETTER              #
#===================================#

def get_fig( index, nh_string ):

    nh = plt_disp.get_nh_num( nh_string )

    global FIG_CONV
    global FIG_ENERGY
    global FIG_ACCU
    global FIG_ORIENT
    global FIG_INTERDIST
    global FIG_DIST_PARTICLE
    global FIG_DIST_CENTER

    if( index ==  1 ): return FIG_CONV[ nh ]
    if( index == 4 ): return FIG_ENERGY[ nh ]
    if( index == 8 ): return FIG_ACCU[ nh ]
    if( index == 9 ): return FIG_ORIENT[ nh ]
    if( index == 10 ): return FIG_INTERDIST[ nh ]
    if( index == 11 ): return FIG_DIST_PARTICLE[ nh ]
    if( index == 12 ): return FIG_DIST_CENTER[ nh ]

    return None

def get_axes( index, nh ):

    fig = get_fig( index, nh )

    return fig.axes

def get_path( path_folder_start, path_folder_end ):

    path_pdf = path_folder_start + '\\PDF' + path_folder_end + '\\'
    path_png = path_folder_start + '\\PNG' + path_folder_end + '\\'

    if not os.path.exists( path_pdf ):
        os.makedirs( path_pdf )

    if not os.path.exists( path_png ):
        os.makedirs( path_png )

    return [ path_pdf, path_png ]

#===================================#
#               EXPORT              #
#===================================#

def add_legend_single( index, nh ):

    global MARKERSIZE_LEGEND
    global FONTSIZE_LEGEND
    global NH_LIST

    markersize_legend = MARKERSIZE_LEGEND
    fontsize_legend = FONTSIZE_LEGEND


    fig = get_fig( index, nh )

    ax = fig.axes

    if( len(ax) > 1 and ax[ 1 ] is not None):
        handles_1, labels_1 = ax[ 0 ].get_legend_handles_labels()
        handles_3, labels_3 = ax[ 2 ].get_legend_handles_labels()
        handles_6, labels_6 = ax[ 5 ].get_legend_handles_labels()
        handles = handles_1 + handles_3  + handles_6
        labels = labels_1 + labels_3 +  labels_6

        ax[0].legend( handles, labels, markerscale=markersize_legend, fontsize=fontsize_legend, loc='upper center',
                    bbox_to_anchor=(0.5, -0.15), ncol=4 )

    else:
        handles, labels = ax[0].get_legend_handles_labels()
        ax[0].legend( handles, labels, markerscale=markersize_legend, fontsize=fontsize_legend, loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=2)



def add_legends( nh ):

    for i in PLOT_INDEXES:
        add_legend_single( i, nh )

def export_figure( path, setting, nh, swarm ):

    add_legends( nh )

    config = '\\' + setting[ 0 ] + '-' + setting[ 1 ] + '-' + swarm

    path_plots = path + '\\Plots\\'

    #path_all = get_path( path_plots, '\\' + swarm + '\\ALL' )
    path_all = get_path( path_plots, '\\ALL' )

    for index in PLOT_INDEXES:

        plot_title = PLOT_LIST[ index ]

        #path_plot = get_path( path_plots, '\\' + swarm + '\\' + plot_title )
        path_plot = get_path( path_plots, '\\' + plot_title )

        save_single( path_plot, index, config, nh )


    save_all( path_all, config, nh )

    close_figures( nh )

def save_all( path, config, nh ):

    global PLOT_INDEXES

    for index in PLOT_INDEXES:

        save_single( path, index, config, nh )

def save_single( path, index, config, nh ):

    global NH_LIST
    global NH_TITLES

    plot_title = PLOT_LIST[ index ]

    fig = get_fig( index, nh )

    nh_num = plt_disp.get_nh_num( nh )
    nh_string = NH_TITLES[ nh_num ]
    main_title = nh_string

    fig.savefig( path[ 0 ] + config + '_' + plot_title + '_' + main_title + '.pdf', bbox_inches = 'tight' )
    fig.savefig( path[ 1 ] + config + '_' + plot_title + '_' + main_title + '.png', bbox_inches = 'tight' )

def close_figures( nh ):

    global NH_LIST

    for index in PLOT_INDEXES:

        fig = get_fig( index, nh )

        if fig is not None:

            plt.close( fig )
