from glob import glob
from pathlib import Path
import os
import numpy as np
import re

root_path = str( Path.home() ) + "\\Desktop\\Simulation"
swarm_size = -1


global sim_count
global iter_count
global swarm_count
sim_count = 0
iter_count = 0
swarm_count = 20

def set_count( sim, iter, swarm ):
    global sim_count
    global iter_count
    global swarm_count

    sim_count = sim
    iter_count = iter
    swarm_count = swarm

#########################################
#               GENERAL
#########################################


def set_root_path():

    global root_path

    folder = ""
    
    if folder == "":
        print("ERROR: NO IMPORT FOLDER DEFINED.")
        print("Define path in importData.py - set_root_path")

    root_path = folder

def get_path():

    set_root_path()
    return root_path


def get_simulation_config():

    path = root_path + "\\" + "Settings.txt"

    file = open( path, "r+" )
    all_lines = file.readlines()
    file.close()

    swarm = get_line_entries( all_lines[ 1 ], "" );
    vf = get_line_entries( all_lines[ 2 ], "VF" );
    of = get_line_entries( all_lines[ 3 ], "OF" );
    nhNum = get_line_entries( all_lines[ 4 ], "NH" );
    nhTitle = get_line_entries( all_lines[ 5 ], "" );
    radius = get_line_entries( all_lines[ 6 ], "" );
    simNum = int( all_lines[8][15:] )
    iterNum = int( all_lines[9][15:] )-1
    swarmSize = int( all_lines[15][15:] )


    global swarm_size
    swarm_size = int( all_lines[15][15:] )

    results = get_all_files( path )

    sim_config = []
    sim_config.append( vf )
    sim_config.append( of )
    sim_config.append( swarm )
    sim_config.append( nhNum )
    sim_config.append( results )
    sim_config.append( nhTitle )
    sim_config.append( simNum )
    sim_config.append( iterNum )
    sim_config.append( swarmSize )
    sim_config.append( radius )

    return sim_config


def get_line_entries( line, type ):

    subString = line[ line.find( "[" ) + 1:line.find( "]" ) ]

    entries = subString.split( ',' )

    for i in range( 0, len( entries ) ):

        entries[ i ] = type + entries[ i ]


    return entries


def get_all_files( path ):

    path = root_path + "\\" + "Settings.txt"

    file = open( path, "r+" )
    all_lines = file.readlines()
    file.close()

    sw = get_line_entries( all_lines[ 1 ], "" );
    vf = get_line_entries( all_lines[ 2 ], "VF" );
    of = get_line_entries( all_lines[ 3 ], "OF" );
    nh = get_line_entries( all_lines[ 4 ], "NH" );

    path += "\\" + sw[0] + "\\" + sw[0] + "_" + vf[ 0 ] + of[ 0 ] + nh[ 0 ]

    return get_files_in_path( path )


def get_files_in_path( file_path ):

    files = [ ]

    all_files = glob( file_path + "\\*" )

    for path in all_files:

        file_name = os.path.basename( path )
        files.append( file_name )

    return files


def get_folder_in_path( folder_path ):

    folder = []

    all_folder = glob( folder_path + "\\*" )

    for path in all_folder:

        folder_name = os.path.basename( path )
        if( ".txt" not in folder_name ):
            folder.append( folder_name )

    return folder

#########################################
#         SINGLE PARTICLE DATA
#########################################

def get_data_particle_vector_neighbor( root_path, type ):

    data = [ ]
    for i in range( 0, swarm_size ):

        path = root_path + '_P' + str( i ) + '_' + type + ".txt"

        if os.path.isfile( path ):

            single_data = get_file_data_neighbor_vector( path )

            data.append( single_data )

    return data

def get_data_particle( root_path, type ):

    data = []
    for i in range( 0, swarm_size ):

        path = root_path + '_P' + str( i ) + '_' + type + ".txt"

        if os.path.isfile( path ):

            data.append( get_file_data( path ) )

    return data


def get_data_particle_sum( root_path, type ):

    global swarm_size

    data = get_data_particle( root_path, type )

    mean_data = np.zeros( [ sim_count, iter_count ] )

    for particle in range( 0, swarm_count ):

        for sim in range( 0, sim_count ):

            for iter in range( 0, iter_count ):

                mean_data[ sim ][ iter ] += float( data[ particle ][ sim ][ iter ] )

    return mean_data

def get_data_particle_mean( root_path, type ):

    global swarm_size

    mean_data = get_data_particle_sum( root_path, type )

    for sim in range( 0, sim_count ):

        for iter in range( 0, iter_count ):

            mean_data[ sim ][ iter ] = mean_data[ sim ][ iter ] / swarm_size

    return mean_data

def get_data_particle_min( root_path, type ):

    global swarm_size

    data = get_data_particle( root_path, type )

    mean_data = np.ones( [ sim_count, iter_count ] ) * 10000000

    for particle in range( 0, swarm_count ):

        for sim in range( 0, sim_count ):

            for iter in range( 1, iter_count ):

                value = float( data[ particle ][ sim ][ iter ] )

                if( mean_data[ sim ][ iter ] > value ):

                    mean_data[ sim ][ iter ] = value

    return mean_data

def get_data_particle_max( root_path, type ):

    global swarm_size

    data = get_data_particle( root_path, type )

    mean_data = np.zeros( [ sim_count, iter_count ] )

    for particle in range( 0, swarm_count):

        for sim in range( 0, sim_count ):

            for iter in range( 1, iter_count ):

                value = float( data[ particle ][ sim ][ iter ] )

                if( mean_data[ sim ][ iter ] < value ):

                    mean_data[ sim ][ iter ] = value

    return mean_data

#########################################
#            SWARM DATA
#########################################

def get_data( path, type ):

    path += "_" + type + ".txt"

    if os.path.isfile( path ):
        return get_file_data( path )

    return

def get_file_data( file_path ):

    data = [] #includes arrays, each data entry is one simulation

    file = open( file_path, "r+" )
    all_lines = file.readlines()
    file.close()

    for i in range( 0, sim_count ):

        line = all_lines[ i ].split( ',' )
        line = line[1:iter_count+1]

        data.append( line )

    return data

def get_file_data_neighbor( file_path ):

    data = get_file_data_neighbor_vector( file_path )

    result = []

    for sim in range( 0, sim_count ):

        count_iter = []
        for iter in range( 0, iter_count ):

            count = 0
            for n in range( 0, swarm_count ):

                if data[sim][iter][n] == 1:
                    count += 1

            count_iter.append( count)

        result.append( count_iter )

    return result

def get_file_data_neighbor_vector( file_path ):

    global swarm_size

    file = open( file_path, "r+" )
    all_lines = file.readlines()
    file.close()


    vector = np.zeros( swarm_count )
    result_all = []

    for i in range( 0, sim_count ):

        result_iter = [ ]

        single_iter_line = all_lines[ i ].split( ',' )

        firstEntry = True


        for j in range( 0, len(single_iter_line) ):

            single_entry = single_iter_line[ j ]

            if '[' in single_entry and ']' in single_entry:

                if firstEntry:
                    firstEntry = False
                    continue

                vector = np.zeros( swarm_size  )

                single_entry = single_entry.replace( "[", "" )
                single_entry = single_entry.replace( "]", "" )

                temp_int = re.search( r'\d+', single_entry )

                if temp_int is not None:
                    temp_int = int( temp_int.group() )
                    vector[ temp_int ] = 1

                result_iter.append( vector )
                continue

            if '[' in single_entry:

                single_entry= single_entry.replace("[","")
                vector = np.zeros( swarm_size )

            if ']' in single_entry:

                single_entry= single_entry.replace("]","")

                if firstEntry:
                    firstEntry = False
                    continue

                result_iter.append( vector )


            temp_int = re.search(r'\d+', single_entry)

            if temp_int is not None:

                temp_int = int(temp_int.group())
                vector[ temp_int ] = 1

        result_all.append( result_iter )

    return result_all


def print_list( list ):

    list_string = ""
    for element in list:
        list_string += str( element) + " "

    list_string += "  "
    return list_string
