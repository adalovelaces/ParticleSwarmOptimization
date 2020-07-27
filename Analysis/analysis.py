import importData as imp
import plotData as plt_data
import extractData as extrData
import timeHelper as timer
import plotDisplay as plt_disp

import os
import shutil
import pareto as par
import getData as dt_getter

global ROOT_PATH
global SIM_CONFIG
global PATH
global EXTRACT_PATH
global SIM_COUNT
global ITER_COUNT
global SWARM_COUNT
global PLOT_LIST
global PLOT_INDEXES
global NH_STRING_LIST

ROOT_PATH = ""
SIM_CONFIG = ""
PATH = ""
EXTRACT_PATH = ""

SIM_COUNT = 0
ITER_COUNT = 0
SWARM_COUNT = 20

PLOT_INDEXES = [9]
#PLOT_INDEXES = [1,4,8,9,10,12]#todo 10

PLOT_LIST = [ '', 'CONVERGENCE', 'BOX', 'PARETO', 'ENERGY']
PLOT_LIST += [ 'BOX_RADIUS', 'BOX_GBEST', 'BOX_ENERGY' ]
PLOT_LIST += [ 'ACCUMULATION', 'ORIENTATION', 'INTERDIST', 'DIST_OPT_PARTICLE', 'DIST_OPT_CENTER']

NH_TITLES = ['GBEST','RING','STAR','NEUMANN','PAYOFF','PROB','PAYOFFPROB','PAYOFFSW','PROBSW','PAYOFFPROBSW','SUB5','SUB10','SUB20']

def init():

    global ROOT_PATH
    global SIM_CONFIG
    global PATH
    global EXTRACT_PATH
    global SIM_COUNT
    global ITER_COUNT
    global SWARM_COUNT
    global PLOT_LIST
    global PLOT_INDEXES
    global NH_TITLES

    ROOT_PATH = imp.get_path()

    #clear_folder()

    SIM_CONFIG = imp.get_simulation_config()

    NH_LIST = SIM_CONFIG[ 3 ]

    SIM_COUNT = SIM_CONFIG[ 6 ]
    ITER_COUNT = SIM_CONFIG[ 7 ]
    SWARM_COUNT = SIM_CONFIG[ 8 ]

    imp.set_count( SIM_COUNT, ITER_COUNT, SWARM_COUNT )
    dt_getter.set_count( SIM_COUNT, ITER_COUNT, SWARM_COUNT )

    plt_data.init( SIM_COUNT, ITER_COUNT, PLOT_INDEXES, PLOT_LIST, NH_LIST, NH_TITLES )

    PATH = ROOT_PATH + "\\" + SIM_CONFIG[0][0] + "\\" + SIM_CONFIG[1][0] + "\\" + SIM_CONFIG[2][0] + "\\" + SIM_CONFIG[3][0]

    EXTRACT_PATH = extrData.create_extract_folder( ROOT_PATH, SIM_CONFIG[2] )

def clear_folder():

    path_plots = ROOT_PATH + '\\Plots'
    # Clear folder
    if (os.path.isdir( path_plots )):

        for root, dirs, files in os.walk( path_plots ):
            for file in files:
                os.remove( os.path.join( root, file ) )

        shutil.rmtree( path_plots )
        os.makedirs( path_plots )

    else:
        os.makedirs( path_plots )


def analysis_all_nh():
    print(SIM_CONFIG[3])
    print( "Start analysis all neighborhoods together" )
    timer.start( SIM_CONFIG )

    for vf in SIM_CONFIG[0]:

        for of in SIM_CONFIG[1]:

            for nh in SIM_CONFIG[ 3 ]:

                nh_name = nh
                radius = plt_disp.get_radius( nh )

                if (radius == 2):
                    plt_data.init_fig( vf, of, SIM_CONFIG[ 3 ], nh_name )

                for swarm in SIM_CONFIG[ 2 ]:

                    swarm_name = swarm + "-R" + str(radius)

                    print( swarm + " " + str( of ) + " " + str( vf ) + " " + str( nh_name ) )

                    result_accu = 0
                    result_orient = 0
                    result_interdist = 0
                    result_dist_opt_particle = 0
                    result_dist_opt_center = 0

                    in_path = ROOT_PATH + "\\Data\\" + swarm + "\\" + swarm + "_" + vf + of + nh

                    if 1 or 9 in PLOT_INDEXES:
                        result_gbest = imp.get_data( in_path, "Gbest" )

                    if 4 in PLOT_INDEXES:

                        result_sumUsedEnergy = imp.get_data_particle_sum(in_path, "UsedEnergy")
                        result_avgUsedEnergy = imp.get_data_particle_mean(in_path, "UsedEnergy")


                    # Accumulation Rate
                    if 8 in PLOT_INDEXES:

                        data_raw = imp.get_data_particle( in_path, "DistanceOpt" )
                        result_accu = dt_getter.get_data_accu( data_raw )

                    # Average orientation value of the particles
                    if 9 in PLOT_INDEXES:

                        data_raw_inter = imp.get_data( in_path, "DistInter" )
                        data_raw_wind = imp.get_data_particle( in_path, "OrientationWind" )

                        result_orient = dt_getter.get_data_orient( data_raw_inter, data_raw_wind )

                    # Average distance between the particles
                    if 10 in PLOT_INDEXES:

                        data_raw = imp.get_data( in_path, "DistInter" )
                        result_interdist = dt_getter.get_data_interdist( data_raw )

                    # Average distance of the particles towards the optimum
                    if 11 in PLOT_INDEXES:

                        data_raw = imp.get_data_particle( in_path, "DistanceOpt" )
                        result_dist_opt_particle = dt_getter.get_data_distOptParticle( data_raw )

                    # Distance of the swarm center towards the optimum
                    if 12 in PLOT_INDEXES:

                        data_raw = imp.get_data( in_path, "DistCenter" )
                        result_dist_opt_center = dt_getter.get_data_distOptCenter( data_raw )

                    if 1 in PLOT_INDEXES: plt_data.make_line( result_gbest, nh_name, swarm_name, 1 )
                    if 4 in PLOT_INDEXES: plt_data.make_line( result_avgUsedEnergy, nh_name, swarm_name, 4 )
                    if 8 in PLOT_INDEXES: plt_data.make_line( result_accu, nh_name, swarm_name, 8 )
                    if 9 in PLOT_INDEXES: plt_data.make_line_two( result_gbest, result_orient, nh_name, swarm_name, 9 )
                    if 10 in PLOT_INDEXES: plt_data.make_line( result_interdist, nh_name, swarm_name, 10 )
                    if 11 in PLOT_INDEXES: plt_data.make_line( result_dist_opt_particle, nh_name, swarm_name, 11 )
                    if 12 in PLOT_INDEXES:plt_data.make_line( result_dist_opt_center, nh_name, swarm_name, 12 )


                    #ex_path = EXTRACT_PATH + "\\" + swarm + "\\" + swarm + "_" + vf + of + nh

                    #extrData.extract_data( ex_path, "GBest", result_gbest )
                    #extrData.extract_data( ex_path, "UsedEnergy", result_avgUsedEnergy )

                    #print( "FINISHED NH " + nh )

                if( radius ==  30 and "ZPSO" in swarm ):

                    setting = [ vf, of, swarm, SIM_CONFIG[3] ]

                    plt_data.export_figure( ROOT_PATH, setting, nh, swarm )

                    plt_data.close_figures( nh )

                    print( "FINISHED EXPORT " + vf + " " + of )

                    timer.show_remaining_time( setting, SIM_CONFIG )
